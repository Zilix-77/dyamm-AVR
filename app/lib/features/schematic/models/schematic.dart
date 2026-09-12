/// Schematic editing state (PRD §6.1).
enum SchematicTool {
  select,
  move,
  wire,
  delete,
  cut,
  copy,
  paste,
  rotate,
  more,
}

class Selection {
  final List<String> componentIds;
  const Selection([this.componentIds = const []]);
  bool get isEmpty => componentIds.isEmpty;
}
