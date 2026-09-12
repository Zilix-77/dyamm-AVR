import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sim_state.dart';
import '../simulation/simulation.dart';
import 'canvas/schematic_canvas.dart';
import 'widgets/library_bar.dart';
import 'widgets/tool_pad.dart';

/// Schematic workspace shell (PRD §28-§34): toolbar + canvas + library + 3×3 pad.
class WorkspaceScreen extends ConsumerWidget {
  const WorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sim = ref.watch(simControllerProvider);
    final simCtl = ref.read(simControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('dyamm-AVR Schema design'),
        actions: [
          IconButton(tooltip: 'Run', icon: const Icon(Icons.play_arrow),
              onPressed: sim == SimState.running ? null : simCtl.run),
          IconButton(tooltip: 'Pause', icon: const Icon(Icons.pause),
              onPressed: sim == SimState.running ? simCtl.pause : null),
          IconButton(tooltip: 'Stop', icon: const Icon(Icons.stop),
              onPressed: sim == SimState.stopped ? null : simCtl.stop),
        ],
      ),
      body: const Column(
        children: [
          Expanded(child: SchematicCanvas()),
          ComponentLibraryBar(),
        ],
      ),
      floatingActionButton: const ToolPad(),
    );
  }
}
