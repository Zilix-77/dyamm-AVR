import '../components/models/component.dart';
import '../project/models/project.dart';

/// Minimal DC steady-state solver (Modified Nodal Analysis).
/// Scope: resistors, voltage sources, GND, switches, LEDs/diodes (fixed-Vf),
/// capacitors as opens, inductors as shorts. No AC, no transient, no convergence
/// iteration beyond a bounded LED on/off fixpoint (4 passes max).
/// Everything else (potentiometer, relay, transformer, ATmega32) is an open.

/// Result of one solve, in volts / amps / on-off states.
class CircuitSolution {
  final Map<String, double> nodeVoltages;
  final Map<String, bool> componentOn;
  final Map<String, double> branchCurrents;
  final String? error;
  const CircuitSolution({
    this.nodeVoltages = const {},
    this.componentOn = const {},
    this.branchCurrents = const {},
    this.error,
  });
}

const double _shortR = 0.01;

class _VSource {
  final String pos;
  final String neg;
  final double volts;
  _VSource(this.pos, this.neg, this.volts);
}

class _Resistor {
  final String a;
  final String b;
  final double ohms;
  final String? owner;
  _Resistor(this.a, this.b, this.ohms, [this.owner]);
}

/// Solves [project] and returns node voltages keyed by net root (`comp.pin`).
CircuitSolution solveDc(Project project) {
  // 1. Nets via union-find over wire endpoints.
  final parent = <String, String>{};
  String find(String x) {
    parent.putIfAbsent(x, () => x);
    var root = x;
    while (parent[root] != root) {
      root = parent[root]!;
    }
    parent[x] = root;
    return root;
  }

  void union(String a, String b) {
    parent[find(a)] = find(b);
  }

  String key(String comp, String pin) => '$comp.$pin';
  final byId = {for (final c in project.components) c.id: c};
  for (final w in project.wires) {
    if (!byId.containsKey(w.fromComponent) ||
        !byId.containsKey(w.toComponent)) {
      continue;
    }
    union(key(w.fromComponent, w.fromPin), key(w.toComponent, w.toPin));
  }

  String netOf(Component c, String pinId) => find(key(c.id, pinId));

  // Nets touching a GND pin are ground.
  final groundNets = <String>{};
  for (final c in project.components) {
    if (c.type == ComponentType.gnd && c.pins.isNotEmpty) {
      groundNets.add(netOf(c, c.pins.first.id));
    }
  }

  String? pinId(Component c, int i) =>
      i < c.pins.length ? c.pins[i].id : null;

  // 2. LED/diode on/off fixpoint (bounded).
  final on = <String, bool>{};
  CircuitSolution? last;
  for (var pass = 0; pass < 4; pass++) {
    last = _solveOnce(project, byId, netOf, pinId, groundNets, on);
    if (last.error != null) return last;
    var changed = false;
    for (final c in project.components) {
      if (c.type != ComponentType.led && c.type != ComponentType.diode) {
        continue;
      }
      final a = pinId(c, 0);
      final b = pinId(c, 1);
      if (a == null || b == null) continue;
      final vf = c.properties['vf'] ?? 0.7;
      final va = last.nodeVoltages[netOf(c, a)] ?? 0;
      final vb = last.nodeVoltages[netOf(c, b)] ?? 0;
      final shouldBeOn = (va - vb) > vf;
      if ((on[c.id] ?? false) != shouldBeOn) {
        on[c.id] = shouldBeOn;
        changed = true;
      }
    }
    if (!changed) break;
  }
  return last ?? const CircuitSolution();
}

CircuitSolution _solveOnce(
  Project project,
  Map<String, Component> byId,
  String Function(Component, String) netOf,
  String? Function(Component, int) pinId,
  Set<String> groundNets,
  Map<String, bool> on,
) {
  final resistors = <_Resistor>[];
  final sources = <_VSource>[];
  final ledSourceOf = <String, int>{};

  bool closed(Component c) => (c.properties['closed'] ?? 0) > 0;

  for (final c in project.components) {
    final a = pinId(c, 0);
    final b = pinId(c, 1);
    switch (c.type) {
      case ComponentType.resistor:
        if (a == null || b == null) continue;
        final na = netOf(c, a);
        final nb = netOf(c, b);
        if (na == nb) continue;
        final r = (c.properties['resistance'] ?? 0) <= 0
            ? _shortR
            : c.properties['resistance']!;
        resistors.add(_Resistor(na, nb, r, c.id));
      case ComponentType.led:
      case ComponentType.diode:
        if (a == null || b == null) continue;
        if (!(on[c.id] ?? false)) continue; // OFF: open circuit.
        final na = netOf(c, a);
        final internal = 'led:${c.id}';
        final ron = c.properties['ron'] ?? 10;
        final vf = c.properties['vf'] ?? 0.7;
        resistors.add(_Resistor(na, internal, ron <= 0 ? _shortR : ron, c.id));
        ledSourceOf[c.id] = sources.length;
        sources.add(_VSource(internal, netOf(c, b), vf));
      case ComponentType.pushButton:
      case ComponentType.switch_:
        if (a == null || b == null || !closed(c)) continue;
        final na = netOf(c, a);
        final nb = netOf(c, b);
        if (na == nb) continue;
        resistors.add(_Resistor(na, nb, _shortR, c.id));
      case ComponentType.inductor:
        if (a == null || b == null) continue;
        final na = netOf(c, a);
        final nb = netOf(c, b);
        if (na == nb) continue;
        resistors.add(_Resistor(na, nb, _shortR, c.id));
      case ComponentType.capacitor:
        continue; // DC steady state: open.
      case ComponentType.vcc:
        if (a == null) continue;
        sources.add(_VSource(
            netOf(c, a), _groundKey, c.properties['voltage'] ?? 5.0));
      case ComponentType.dcSource:
        if (a == null || b == null) continue;
        sources.add(_VSource(
            netOf(c, a), netOf(c, b), c.properties['voltage'] ?? 5.0));
      case ComponentType.gnd:
      case ComponentType.potentiometer:
      case ComponentType.relay:
      case ComponentType.transformer:
      case ComponentType.atmega32:
        continue; // No DC model yet: open circuit.
    }
  }

  // 3. Node indexing (ground excluded).
  final nets = <String>{};
  for (final r in resistors) {
    nets.add(r.a);
    nets.add(r.b);
  }
  for (final s in sources) {
    nets.add(s.pos);
    nets.add(s.neg);
  }
  nets.add(_groundKey);
  nets.addAll(groundNets);
  final nodes = nets
      .where((n) => n != _groundKey && !groundNets.contains(n))
      .toList();
  final index = {for (var i = 0; i < nodes.length; i++) nodes[i]: i};
  final n = nodes.length;
  final m = sources.length;
  if (n == 0) {
    return CircuitSolution(
      nodeVoltages: {for (final net in nets) net: 0},
      componentOn: Map.of(on),
    );
  }

  // 4. MNA stamps.
  final size = n + m;
  final a = List.generate(size, (_) => List.filled(size, 0.0));
  final z = List.filled(size, 0.0);
  int? idx(String net) {
    if (net == _groundKey || groundNets.contains(net)) return null;
    return index[net];
  }

  for (final r in resistors) {
    final g = 1.0 / r.ohms;
    final i = idx(r.a);
    final j = idx(r.b);
    if (i != null) a[i][i] += g;
    if (j != null) a[j][j] += g;
    if (i != null && j != null) {
      a[i][j] -= g;
      a[j][i] -= g;
    }
  }
  for (var k = 0; k < m; k++) {
    final s = sources[k];
    final i = idx(s.pos);
    final j = idx(s.neg);
    if (i != null) {
      a[i][n + k] += 1;
      a[n + k][i] += 1;
    }
    if (j != null) {
      a[j][n + k] -= 1;
      a[n + k][j] -= 1;
    }
    z[n + k] = s.volts;
  }

  // 5. Gaussian elimination with partial pivot.
  for (var col = 0; col < size; col++) {
    var piv = col;
    for (var row = col + 1; row < size; row++) {
      if (a[row][col].abs() > a[piv][col].abs()) piv = row;
    }
    if (a[piv][col].abs() < 1e-12) {
      return const CircuitSolution(
          error: 'Unsolvable network: floating net or missing ground.');
    }
    if (piv != col) {
      final t = a[col];
      a[col] = a[piv];
      a[piv] = t;
      final tz = z[col];
      z[col] = z[piv];
      z[piv] = tz;
    }
    for (var row = col + 1; row < size; row++) {
      final f = a[row][col] / a[col][col];
      for (var k = col; k < size; k++) {
        a[row][k] -= f * a[col][k];
      }
      z[row] -= f * z[col];
    }
  }
  final x = List.filled(size, 0.0);
  for (var row = size - 1; row >= 0; row--) {
    var s = z[row];
    for (var k = row + 1; k < size; k++) {
      s -= a[row][k] * x[k];
    }
    x[row] = s / a[row][row];
  }

  double volt(String net) {
    if (net == _groundKey || groundNets.contains(net)) return 0;
    return x[index[net]!];
  }

  final voltages = {for (final net in nets) net: volt(net)};
  final currents = <String, double>{};
  for (final r in resistors) {
    if (r.owner != null) {
      currents[r.owner!] = (volt(r.a) - volt(r.b)) / r.ohms;
    }
  }
  // LED current flows through its Vf source, not the series resistor alone.
  for (final c in project.components) {
    if ((c.type == ComponentType.led || c.type == ComponentType.diode) &&
        (on[c.id] ?? false)) {
      final k = ledSourceOf[c.id];
      if (k != null) currents[c.id] = x[n + k];
    }
  }
  return CircuitSolution(
    nodeVoltages: voltages,
    componentOn: Map.of(on),
    branchCurrents: currents,
  );
}

const String _groundKey = '__gnd__';
