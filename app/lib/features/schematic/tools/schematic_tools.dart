import '../models/schematic.dart';

import 'package:flutter/material.dart';

/// Default 3×3 pad order (PRD §33).
const defaultTools = [
  SchematicTool.select,
  SchematicTool.move,
  SchematicTool.wire,
  SchematicTool.delete,
  SchematicTool.cut,
  SchematicTool.copy,
  SchematicTool.paste,
  SchematicTool.rotate,
  SchematicTool.more,
];

String toolLabel(SchematicTool t) => switch (t) {
  SchematicTool.select => 'Select',
  SchematicTool.move => 'Move',
  SchematicTool.wire => 'Wire',
  SchematicTool.delete => 'Delete',
  SchematicTool.cut => 'Cut',
  SchematicTool.copy => 'Copy',
  SchematicTool.paste => 'Paste',
  SchematicTool.rotate => 'Rotate',
  SchematicTool.more => 'More',
};

IconData toolIcon(SchematicTool t) => switch (t) {
  SchematicTool.select => Icons.near_me,
  SchematicTool.move => Icons.open_with,
  SchematicTool.wire => Icons.share_outlined,
  SchematicTool.delete => Icons.delete_outline,
  SchematicTool.cut => Icons.content_cut,
  SchematicTool.copy => Icons.content_copy,
  SchematicTool.paste => Icons.content_paste_outlined,
  SchematicTool.rotate => Icons.rotate_right,
  SchematicTool.more => Icons.more_horiz,
};
