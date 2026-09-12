import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/editor_theme.dart';
import '../editor_state.dart';
import '../models/schematic.dart';
import '../tools/schematic_tools.dart';

/// Right 3×3 CAD tool pad — icon + label grid bound to the existing
/// [activeToolProvider]. Select renders active-white per Stitch.
/// Tool actions beyond selection state are roadmap-gated.
class ToolPad extends ConsumerWidget {
  const ToolPad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeToolProvider);
    return Container(
      color: EditorColors.pad,
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.15,
        children: [
          for (final t in defaultTools)
            _ToolCell(
              tool: t,
              active: t == active,
              onTap: () {
                if (t == SchematicTool.cut ||
                    t == SchematicTool.copy ||
                    t == SchematicTool.paste ||
                    t == SchematicTool.more) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${toolLabel(t)} is not implemented yet'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  return;
                }
                ref.read(activeToolProvider.notifier).state = t;
                if (t != SchematicTool.wire) {
                  ref.read(pendingWireProvider.notifier).state = null;
                }
                if (t != SchematicTool.select &&
                    t != SchematicTool.move &&
                    t != SchematicTool.wire) {
                  ref.read(pendingPlacementProvider.notifier).state = null;
                }
              },
            ),
        ],
      ),
    );
  }
}

class _ToolCell extends StatelessWidget {
  final SchematicTool tool;
  final bool active;
  final VoidCallback onTap;
  const _ToolCell({
    required this.tool,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tool == SchematicTool.more
        ? 'More tools (planned)'
        : '${toolLabel(tool)} tool',
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: active ? Colors.white : EditorColors.card,
          border: active ? null : Border.all(color: EditorColors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                toolIcon(tool),
                size: 20,
                color: active ? Colors.black : EditorColors.bright,
              ),
              const SizedBox(height: 2),
              Text(
                toolLabel(tool),
                style: TextStyle(
                  color: active ? Colors.black : EditorColors.muted,
                  fontWeight: active ? FontWeight.bold : FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
