import 'package:flutter/material.dart';

import '../../components/component_library.dart';
import '../../components/widgets/component_tile.dart';

/// Bottom library strip (PRD §32).
class ComponentLibraryBar extends StatelessWidget {
  const ComponentLibraryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final t in componentLibrary) ComponentTile(label: componentLabel(t)),
        ],
      ),
    );
  }
}
