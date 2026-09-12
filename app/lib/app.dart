import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/editor_theme.dart';
import 'features/project/project_manager.dart';
import 'features/project/project_manager_screen.dart';
import 'features/schematic/workspace.dart';

/// Root widget — Riverpod screen switch (Phase 0, no routes yet).
/// No active project → Project Manager; otherwise → Main Editor.
class DyammApp extends StatelessWidget {
  const DyammApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dyamm-AVR Schema design',
      theme: editorTheme(),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends ConsumerStatefulWidget {
  const RootScreen({super.key});

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen> {
  bool? _editorApplied;

  @override
  void dispose() {
    // Restore free rotation if this root ever unmounts.
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _applyOrientation(bool inEditor) {
    // Platform call only on transitions, not every rebuild.
    if (_editorApplied == inEditor) return;
    _editorApplied = inEditor;
    SystemChrome.setPreferredOrientations(
      inEditor
          ? const [
              DeviceOrientation.landscapeLeft,
              DeviceOrientation.landscapeRight,
            ]
          : const [DeviceOrientation.portraitUp],
    );
  }

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(sessionProvider.select((s) => s.active));
    // Per-screen orientation (single choke point):
    // portrait file manager, hard-locked landscape editor.
    _applyOrientation(active != null);
    if (active == null) return const ProjectManagerScreen();
    return const WorkspaceScreen();
  }
}
