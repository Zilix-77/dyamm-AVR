import 'package:flutter/material.dart';

import 'features/schematic/workspace.dart';

/// Root widget — single-workspace CAD shell (PRD §27-§28).
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
      home: const WorkspaceScreen(),
    );
  }
}
