import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/editor_theme.dart';
import '../../components/component_library.dart';
import '../editor_state.dart';
import '../painters/component_symbols.dart';

/// Stitch category chips — selectable UI state only (filtering is Phase 3).
const libraryCategories = [
  'All',
  'MCU',
  'Basic',
  'Passive',
  'Diodes & Transistors',
  'Logic',
  'Sensors',
  'Display',
  'Power',
  'Actuators',
  'Misc',
];

/// Bottom component library drawer: header + search placeholder + category
/// chips + 13 symbol tiles. Tapping a tile arms canvas-tap placement via the
/// existing [pendingPlacementProvider] (real behavior, kept).
class ComponentLibraryBar extends ConsumerStatefulWidget {
  const ComponentLibraryBar({super.key});

  @override
  ConsumerState<ComponentLibraryBar> createState() =>
      _ComponentLibraryBarState();
}

class _ComponentLibraryBarState extends ConsumerState<ComponentLibraryBar> {
  String _category = 'All';

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(pendingPlacementProvider);
    return Container(
      color: EditorColors.panel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: title + search placeholder.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: const BoxDecoration(
              color: EditorColors.headerStrip,
              border: Border(bottom: BorderSide(color: EditorColors.border)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Narrow shelf: search collapses away (icon implies it).
                final narrow = constraints.maxWidth < 460;
                return Row(
                  children: [
                    const Text(
                      'Component Library',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: EditorColors.muted,
                      size: 16,
                    ),
                    const Spacer(),
                    if (!narrow)
                      const SizedBox(
                        width: 200,
                        height: 28,
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Search components...',
                            prefixIcon: Icon(
                              Icons.search,
                              size: 14,
                              color: EditorColors.muted,
                            ),
                          ),
                        ),
                      ),
                    if (!narrow)
                      const Tooltip(
                        message: 'List view (Phase 3)',
                        child: Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.menu,
                            size: 16,
                            color: EditorColors.muted,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          // Category chips.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: const BoxDecoration(
              color: EditorColors.chipStrip,
              border: Border(bottom: BorderSide(color: EditorColors.border)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final c in libraryCategories)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: _CategoryChip(
                        label: c,
                        selected: c == _category,
                        onTap: () => setState(() => _category = c),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // 13 symbol tiles.
          Expanded(
            child: ListView.separated(
              key: const Key('library-tiles'),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: componentLibrary.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final t = componentLibrary[i];
                return _LibraryTile(
                  type: t,
                  selected: pending == t,
                  onTap: () =>
                      ref.read(pendingPlacementProvider.notifier).state =
                          (pending == t) ? null : t,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? Colors.white : EditorColors.card,
        border: selected ? null : Border.all(color: EditorColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.black : EditorColors.muted,
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          fontSize: 11,
        ),
      ),
    ),
  );
}

class _LibraryTile extends StatelessWidget {
  final ComponentType type;
  final bool selected;
  final VoidCallback onTap;
  const _LibraryTile({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: selected
          ? '${componentLabel(type)} — tap canvas to place'
          : '${componentLabel(type)} — tap to arm placement',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 96,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? EditorColors.active : EditorColors.card,
            border: Border.all(
              color: selected ? Colors.white : EditorColors.border,
              width: selected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TileSymbol(
                  type: type,
                  ink: selected ? Colors.white : EditorColors.bright,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    componentLabel(type),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? Colors.white : EditorColors.muted,
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
