import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sim_state.dart';
import '../project/project_manager.dart';
import '../project/services/project_storage.dart';
import '../simulation/simulation.dart';
import 'canvas/schematic_canvas.dart';
import 'widgets/library_bar.dart';
import 'widgets/tool_pad.dart';

/// Main Editor shell, Phase 0 (PRD §28-§34).
/// Layout only: sim controls, library, tool pad and minimap are visual
/// placeholders until Phases 1/3+.
class WorkspaceScreen extends ConsumerStatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen> {
  final _zoomController = TransformationController();

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  void _zoom(double factor) {
    final v = _zoomController.value;
    final s = (v.getMaxScaleOnAxis() * factor).clamp(0.2, 4.0);
    _zoomController.value = Matrix4.diagonal3Values(s, s, 1);
  }

  @override
  Widget build(BuildContext context) {
    final sim = ref.watch(simControllerProvider);
    final simCtl = ref.read(simControllerProvider.notifier);
    final projectName = ref.watch(
      sessionProvider.select((s) => s.active?.name ?? ''),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Close project',
          icon: const Icon(Icons.close),
          onPressed: () => ref.read(sessionProvider.notifier).close(),
        ),
        title: Text(projectName.isEmpty ? 'Editor' : projectName),
        actions: [
          // Placeholders (Phase 3+): toggle UI state only, no engine.
          IconButton(
            tooltip: 'Run (placeholder)',
            icon: const Icon(Icons.play_arrow),
            onPressed: sim == SimState.running ? null : simCtl.run,
          ),
          IconButton(
            tooltip: 'Pause (placeholder)',
            icon: const Icon(Icons.pause),
            onPressed: sim == SimState.running ? simCtl.pause : null,
          ),
          IconButton(
            tooltip: 'Stop (placeholder)',
            icon: const Icon(Icons.stop),
            onPressed: sim == SimState.stopped ? null : simCtl.stop,
          ),
        ],
      ),
      drawer: const ProjectPanel(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                SchematicCanvas(controller: _zoomController),
                const Positioned(
                  right: 8,
                  bottom: 8,
                  child: MinimapPlaceholder(),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: ZoomControls(
                    onZoomIn: () => _zoom(1.25),
                    onZoomOut: () => _zoom(0.8),
                    onReset: () => _zoomController.value = Matrix4.identity(),
                  ),
                ),
              ],
            ),
          ),
          const ComponentLibraryBar(),
        ],
      ),
      floatingActionButton: const ToolPad(),
    );
  }
}

/// Left project/file panel: save action + file entries.
class ProjectPanel extends ConsumerWidget {
  const ProjectPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(sessionProvider.select((s) => s.active?.name ?? ''));
    final count = ref.watch(sessionProvider.select(
        (s) => s.active == null ? 0 : s.active!.components.length + s.active!.wires.length));
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text(name)),
          ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Save'),
            subtitle: Text('$count items'),
            onTap: () async {
              await ref
                  .read(sessionProvider.notifier)
                  .saveCurrent(await FileProjectStorage.appDir());
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Project saved')),
                );
              }
            },
          ),
          const ListTile(
            leading: Icon(Icons.code),
            title: Text('Firmware (placeholder)'),
          ),
        ],
      ),
    );
  }
}

/// Live minimap arrives later; keeps layout space (PRD §28).
class MinimapPlaceholder extends StatelessWidget {
  const MinimapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 96,
      height: 72,
      child: Card(child: Center(child: Text('Minimap'))),
    );
  }
}

class ZoomControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReset;
  const ZoomControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filledTonal(
          tooltip: 'Zoom in',
          onPressed: onZoomIn,
          icon: const Icon(Icons.add),
        ),
        IconButton.filledTonal(
          tooltip: 'Zoom out',
          onPressed: onZoomOut,
          icon: const Icon(Icons.remove),
        ),
        IconButton.filledTonal(
          tooltip: 'Reset zoom',
          onPressed: onReset,
          icon: const Icon(Icons.center_focus_strong),
        ),
      ],
    );
  }
}
