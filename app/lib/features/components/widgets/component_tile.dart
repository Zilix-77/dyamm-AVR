import 'package:flutter/material.dart';

/// Single library entry tile (PRD §32).
class ComponentTile extends StatelessWidget {
  final String label;
  const ComponentTile({super.key, required this.label});

  @override
  Widget build(BuildContext context) => Chip(label: Text(label));
}
