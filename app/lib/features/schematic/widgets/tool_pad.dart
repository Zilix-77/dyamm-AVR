import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../editor_state.dart';
import '../models/schematic.dart';
import '../tools/schematic_tools.dart';

/// 3×3 contextual tool pad (PRD §33). Selects the active editor tool.
class ToolPad extends ConsumerWidget {
  const ToolPad({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeToolProvider);
    return SizedBox(
      width: 168,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        children: [
          for (final t in defaultTools)
            _ToolButton(
              tool: t,
              active: t == active,
              onTap: () {
                ref.read(activeToolProvider.notifier).state = t;
                if (t != SchematicTool.wire) {
                  ref.read(pendingWireProvider.notifier).state = null;
                }
              },
            ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final SchematicTool tool;
  final bool active;
  final VoidCallback onTap;
  const _ToolButton(
      {required this.tool, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: active ? Theme.of(context).colorScheme.primary : null,
          foregroundColor:
              active ? Theme.of(context).colorScheme.onPrimary : null,
        ),
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(toolLabel(tool)[0],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(toolLabel(tool),
                style: const TextStyle(fontSize: 9),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
