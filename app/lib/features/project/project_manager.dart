import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/models/component.dart';
import 'services/project_storage.dart';

export 'models/project.dart';

/// In-memory session (Phase 0). No persistence, no `.dyamm` format yet.
@immutable
class ProjectSession {
  final List<Project> recents;
  final Project? active;
  const ProjectSession({this.recents = const [], this.active});

  ProjectSession copyWith({List<Project>? recents, Project? active}) =>
      ProjectSession(recents: recents ?? this.recents, active: active);
}

final sessionProvider = NotifierProvider<SessionController, ProjectSession>(
  SessionController.new,
);

/// Result of [SessionController.create] for dialog validation feedback.
enum CreateResult { ok, emptyName }

class SessionController extends Notifier<ProjectSession> {
  @override
  ProjectSession build() => const ProjectSession();

  CreateResult create(String rawName) {
    final name = rawName.trim();
    if (name.isEmpty) return CreateResult.emptyName;
    final project = Project(name: name);
    state = ProjectSession(
      recents: [
        project,
        for (final p in state.recents)
          if (p.name != name) p,
      ],
      active: project,
    );
    return CreateResult.ok;
  }

  void open(Project project) {
    state = ProjectSession(
      recents: [
        project,
        for (final p in state.recents)
          if (p.name != project.name) p,
      ],
      active: project,
    );
  }

  void close() => state = ProjectSession(recents: state.recents);

  void addComponent(Component c) {
    _updateActive(components: [..._activeComponents, c]);
  }

  void moveComponent(String id, double x, double y) {
    _updateActive(
      components: [
        for (final c in _activeComponents)
          if (c.id == id) c.copyWith(x: x, y: y) else c,
      ],
    );
  }

  void deleteComponent(String id) {
    _updateActive(
      components: [for (final c in _activeComponents) if (c.id != id) c],
      wires: [
        for (final w in _activeWires)
          if (w.fromComponent != id && w.toComponent != id) w,
      ],
    );
  }

  void rotateComponent(String id) {
    _updateActive(
      components: [
        for (final c in _activeComponents)
          if (c.id == id) c.copyWith(rotation: (c.rotation + 90) % 360) else c,
      ],
    );
  }

  /// Toggles switch_/pushButton `closed` property. No-op for other types.
  void toggleSwitch(String id) {
    _updateActive(
      components: [
        for (final c in _activeComponents)
          if (c.id == id &&
              (c.type == ComponentType.switch_ ||
                  c.type == ComponentType.pushButton))
            c.copyWith(properties: {
              ...c.properties,
              'closed': (c.properties['closed'] ?? 0) > 0 ? 0.0 : 1.0,
            })
          else
            c,
      ],
    );
  }

  void addWire(Wire w) {
    _updateActive(wires: [..._activeWires, w]);
  }

  void removeWire(String id) {
    _updateActive(wires: [for (final w in _activeWires) if (w.id != id) w]);
  }

  Future<void> saveCurrent(ProjectStorage storage) async {
    final active = state.active;
    if (active == null) return;
    await storage.save(active);
  }

  /// Opens a saved project by file name. Returns false when missing/corrupt.
  Future<bool> openSaved(ProjectStorage storage, String name) async {
    Project? project;
    try {
      project = await storage.open(name);
    } catch (_) {
      return false;
    }
    if (project == null) return false;
    open(project);
    return true;
  }

  List<Component> get _activeComponents => state.active?.components ?? [];
  List<Wire> get _activeWires => state.active?.wires ?? [];

  void _updateActive({List<Component>? components, List<Wire>? wires}) {
    final active = state.active;
    if (active == null) return;
    final updated = Project(
      name: active.name,
      components: components ?? active.components,
      wires: wires ?? active.wires,
    );
    state = ProjectSession(
      recents: [
        for (final p in state.recents)
          if (p.name != updated.name) p,
        updated,
      ],
      active: updated,
    );
  }
}
