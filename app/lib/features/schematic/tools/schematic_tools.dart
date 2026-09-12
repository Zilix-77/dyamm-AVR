import '../models/schematic.dart';

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

String toolLabel(SchematicTool t) => t.name[0].toUpperCase();
