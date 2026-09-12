import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(sessionProvider.select((s) => s.active));
    if (active == null) return const ProjectManagerScreen();
    return const WorkspaceScreen();
  }
}
