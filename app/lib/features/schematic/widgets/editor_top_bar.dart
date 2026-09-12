import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/sim_state.dart';
import '../../../core/theme/editor_theme.dart';
import '../../project/project_manager.dart';
import '../../simulation/simulation.dart';

/// Landscape editor top bar — Stitch order:
/// hamburger · DYAMM mark · project pill · Run/Pause/Stop · utility cluster.
/// Under 860px wide the brand text and button labels collapse to icons.
class EditorTopBar extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onMenu;
  const EditorTopBar({super.key, required this.onMenu});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sim = ref.watch(simControllerProvider);
    final simCtl = ref.read(simControllerProvider.notifier);
    final projectName = ref.watch(
      sessionProvider.select((s) => s.active?.name ?? 'untitled'),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 860;
        return Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            color: EditorColors.panel,
            border: Border(bottom: BorderSide(color: EditorColors.border)),
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Toggle project panel',
                style: IconButton.styleFrom(minimumSize: const Size(36, 36)),
                icon: const Icon(Icons.menu, color: EditorColors.bright),
                onPressed: onMenu,
              ),
              const SizedBox(
                width: 36,
                height: 36,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Icon(Icons.memory, color: Colors.black, size: 20),
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: 10),
                const Text(
                  'DYAMM',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: -0.5,
                  ),
                ),
                const Text(
                  '-AVR',
                  style: TextStyle(color: EditorColors.muted, fontSize: 16),
                ),
              ],
              const SizedBox(width: 12),
              Flexible(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 44),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: EditorColors.pill,
                    border: Border.all(color: EditorColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          '$projectName.dyamm',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: EditorColors.bright,
                            fontFamily: EditorColors.fontMono,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (!compact) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: EditorColors.muted,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: EditorColors.sheet,
                  border: Border.all(color: EditorColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SimButton(
                      label: 'Run',
                      icon: Icons.play_arrow,
                      filled: true,
                      iconOnly: compact,
                      onPressed: sim == SimState.running ? null : simCtl.run,
                    ),
                    const SizedBox(width: 4),
                    _SimButton(
                      label: 'Pause',
                      icon: Icons.pause,
                      iconOnly: compact,
                      onPressed: sim == SimState.running ? simCtl.pause : null,
                    ),
                    const SizedBox(width: 4),
                    _SimButton(
                      label: 'Stop',
                      icon: Icons.stop,
                      iconOnly: compact,
                      onPressed: sim == SimState.stopped ? null : simCtl.stop,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _PlaceholderIcon(
                icon: Icons.grid_on_outlined,
                tooltip: 'Toggle grid (Phase 3)',
                compact: compact,
              ),
              _PlaceholderIcon(
                  icon: Icons.straighten,
                tooltip: 'Snap to grid (Phase 3)',
                compact: compact,
              ),
              if (!compact) const _BarDivider(),
              _PlaceholderIcon(
                icon: Icons.undo,
                tooltip: 'Undo (Phase 3)',
                compact: compact,
              ),
              _PlaceholderIcon(
                icon: Icons.redo,
                tooltip: 'Redo (Phase 3)',
                compact: compact,
              ),
              if (!compact) const _BarDivider(),
              _PlaceholderIcon(
                icon: Icons.bookmark_border,
                tooltip: 'Save (Phase 4 — .dyamm persistence)',
                compact: compact,
              ),
              _PlaceholderIcon(
                icon: Icons.settings_outlined,
                tooltip: 'Settings (planned)',
                compact: compact,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SimButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final bool iconOnly;
  final VoidCallback? onPressed;
  const _SimButton({
    required this.label,
    required this.icon,
    this.filled = false,
    this.iconOnly = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => FilledButton(
    style: FilledButton.styleFrom(
      backgroundColor: filled ? Colors.white : EditorColors.card,
      foregroundColor: filled ? Colors.black : EditorColors.bright,
      disabledBackgroundColor: filled ? EditorColors.active : EditorColors.card,
      disabledForegroundColor: EditorColors.muted,
      minimumSize: const Size(0, 44),
      padding: EdgeInsets.symmetric(
        horizontal: iconOnly ? 10 : 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: filled
          ? BorderSide.none
          : const BorderSide(color: EditorColors.border),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    ),
    onPressed: onPressed,
    child: iconOnly
        ? Icon(icon, size: 16)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 6),
              Text(label),
            ],
          ),
  );
}

class _PlaceholderIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool compact;
  const _PlaceholderIcon({
    required this.icon,
    required this.tooltip,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: SizedBox(
      width: compact ? 32 : 40,
      height: 40,
      child: Icon(
        icon,
        size: 20,
        color: EditorColors.bright.withValues(alpha: 0.4),
      ),
    ),
  );
}

class _BarDivider extends StatelessWidget {
  const _BarDivider();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 24,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    color: EditorColors.border,
  );
}
