import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/component_library.dart';
import '../editor_state.dart';

/// Bottom library strip (PRD §32). Tapping a tile arms canvas-tap placement.
class ComponentLibraryBar extends ConsumerWidget {
  const ComponentLibraryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(pendingPlacementProvider);
    return SizedBox(
      height: 64,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        children: [
          for (final t in componentLibrary)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(componentLabel(t)),
                selected: pending == t,
                onSelected: (_) => ref
                    .read(pendingPlacementProvider.notifier)
                    .state = (pending == t) ? null : t,
              ),
            ),
        ],
      ),
    );
  }
}
