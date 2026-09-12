import 'package:flutter/material.dart';

import '../tools/schematic_tools.dart';

/// 3×3 contextual tool pad (PRD §33).
class ToolPad extends StatelessWidget {
  const ToolPad({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        children: [
          for (final t in defaultTools)
            IconButton(
              tooltip: t.name,
              onPressed: () {},
              icon: Text(toolLabel(t)),
            ),
        ],
      ),
    );
  }
}
