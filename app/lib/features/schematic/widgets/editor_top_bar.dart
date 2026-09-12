import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/sim_state.dart';
import '../../../core/theme/editor_theme.dart';
import '../../project/project_manager.dart';
import '../../project/services/project_storage.dart';
import '../../simulation/simulation.dart';
import '../editor_state.dart';
import 'magnet_icon.dart';

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
        // Portrait transition frames / very narrow screens: placeholders
        // hide entirely (their tools live in the pad); bar never overflows.
        final minimal = constraints.maxWidth < 600;
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
                  padding: EdgeInsets.symmetric(
                    horizontal: minimal ? 8 : 14,
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
                      if (!minimal) ...[
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Text(
                          '$projectName.dyamm',
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
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
                      onPressed: sim == SimState.running
                          ? null
                          : () {
                              refreshSimulation(ref);
                              simCtl.run();
                            },
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
              if (!minimal) ...[
                _GridToggle(compact: compact),
                _SnapToggle(compact: compact),
                if (!compact) const _BarDivider(),
                _UndoRedo(compact: compact),
                if (!compact) const _BarDivider(),
                _SaveButton(compact: compact),
                _PlaceholderIcon(
                  icon: Icons.settings_outlined,
                  tooltip: 'Settings (planned)',
                  compact: compact,
                ),
              ],
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

/// Toggle button with honest on/off visuals (white = on, dimmed = off).
class _ToggleIcon extends StatelessWidget {
  final String tooltip;
  final bool value;
  final VoidCallback onTap;
  final Widget icon;
  const _ToggleIcon({
    required this.tooltip,
    required this.value,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        onPressed: onTap,
        icon: icon,
        color: value ? Colors.white : EditorColors.muted,
      ),
    ),
  );
}

class _GridToggle extends ConsumerWidget {
  final bool compact;
  const _GridToggle({this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(showGridProvider);
    return _ToggleIcon(
      tooltip: on ? 'Grid: on' : 'Grid: off',
      value: on,
      onTap: () => ref.read(showGridProvider.notifier).state = !on,
      icon: const Icon(Icons.grid_on_outlined, size: 22),
    );
  }
}

class _SnapToggle extends ConsumerWidget {
  final bool compact;
  const _SnapToggle({this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final on = ref.watch(snapEnabledProvider);
    return _ToggleIcon(
      tooltip: on ? 'Snap: on' : 'Snap: off',
      value: on,
      onTap: () => ref.read(snapEnabledProvider.notifier).state = !on,
      icon: MagnetIcon(size: 22, color: on ? Colors.white : EditorColors.muted),
    );
  }
}

class _UndoRedo extends ConsumerWidget {
  final bool compact;
  const _UndoRedo({this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Rebuilds on every history change.
    ref.watch(historyVersionProvider);
    final ctl = ref.read(sessionProvider.notifier);
    final canUndo = ctl.canUndo();
    final canRedo = ctl.canRedo();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 44,
          height: 44,
          child: IconButton(
            tooltip: 'Undo',
            onPressed: canUndo ? ctl.undo : null,
            icon: const Icon(Icons.undo, size: 22),
            color: Colors.white,
            disabledColor: EditorColors.muted,
          ),
        ),
        SizedBox(
          width: 44,
          height: 44,
          child: IconButton(
            tooltip: 'Redo',
            onPressed: canRedo ? ctl.redo : null,
            icon: const Icon(Icons.redo, size: 22),
            color: Colors.white,
            disabledColor: EditorColors.muted,
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends ConsumerWidget {
  final bool compact;
  const _SaveButton({this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
    width: 44,
    height: 44,
    child: IconButton(
      tooltip: 'Save project',
      onPressed: () async {
        final err = await ref
            .read(sessionProvider.notifier)
            .saveCurrent(await FileProjectStorage.appDir());
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(err ?? 'Project saved'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      icon: const Icon(Icons.bookmark_border, size: 22),
      color: Colors.white,
    ),
  );
}
