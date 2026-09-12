import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/editor_theme.dart';
import '../../project/project_manager.dart';
import '../../project/project_manager_screen.dart';
import '../../project/services/project_storage.dart';

/// Left dock panel — Stitch order: PROJECT · PROPERTIES · SIMULATION ·
/// LAYERS + version footer. Only New/Open are live (existing session logic);
/// Save/Save As are disabled until Phase 4 (.dyamm persistence).
class ProjectPanel extends ConsumerWidget {
  const ProjectPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const Drawer(
    width: 256,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    child: ProjectPanelBody(),
  );
}

/// Fixed-dock variant of the same content (landscape editor shows it open;
/// the hamburger collapses it). Shared so drawer and dock never diverge.
class ProjectPanelBody extends ConsumerWidget {
  const ProjectPanelBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(sessionProvider.select((s) => s.active?.name ?? ''));
    // Material (not ColoredBox) so ExpansionTile ink effects have an ancestor.
    return Material(
      color: EditorColors.panel,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const _SectionHeader(title: 'Project', expanded: true),
                _RowButton(
                  icon: Icons.note_add_outlined,
                  label: 'New',
                  onTap: () {
                    _closeDrawerIfOpen(context);
                    showDialog<void>(
                      context: context,
                      builder: (_) => const NewProjectDialog(),
                    );
                  },
                ),
                const _OpenRow(),
                _RowButton(
                  icon: Icons.download_outlined,
                  label: 'Save',
                  onTap: () async {
                    final storage = await FileProjectStorage.appDir();
                    final err = await ref
                        .read(sessionProvider.notifier)
                        .saveCurrent(storage);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            err == null
                                ? 'Saved to ${storage.dir.path}'
                                : 'Save failed: $err',
                          ),
                        ),
                      );
                    }
                  },
                ),
                const _RowButton(
                  icon: Icons.file_copy_outlined,
                  label: 'Save As',
                  enabled: false,
                  disabledTooltip: 'Phase 4 — .dyamm persistence',
                ),
                if (name.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 8, 10, 4),
                    padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: EditorColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$name.dyamm',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: EditorColors.fontMono,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Rename (Phase 4)',
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: EditorColors.muted,
                          ),
                          onPressed: null,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                const _PlaceholderSection(title: 'Properties'),
                const _PlaceholderSection(title: 'Simulation'),
                const _PlaceholderSection(title: 'Layers'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: EditorColors.border)),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 8,
                  height: 8,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Version : 1.0.0',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: EditorColors.muted,
                      fontFamily: EditorColors.fontMono,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool expanded;
  const _SectionHeader({required this.title, this.expanded = false});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: EditorColors.border)),
    ),
    child: Row(
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: EditorColors.bright,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 0.8,
          ),
        ),
        const Spacer(),
        Icon(
          expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_right,
          color: EditorColors.muted,
          size: 18,
        ),
      ],
    ),
  );
}

class _PlaceholderSection extends StatelessWidget {
  final String title;
  const _PlaceholderSection({required this.title});

  @override
  Widget build(BuildContext context) => ExpansionTile(
    dense: true,
    title: Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 0.8,
      ),
    ),
    subtitle: const Text(
      'Planned',
      style: TextStyle(color: EditorColors.muted, fontSize: 11),
    ),
    children: const [
      Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Arrives with its phase — layout reserved.',
            style: TextStyle(color: EditorColors.muted, fontSize: 11),
          ),
        ),
      ),
    ],
  );
}

class _RowButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final String? disabledTooltip;
  final VoidCallback? onTap;
  const _RowButton({
    required this.icon,
    required this.label,
    this.enabled = true,
    this.disabledTooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Icon(icon, size: 16, color: EditorColors.muted),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: EditorColors.bright,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!enabled && disabledTooltip != null) {
      return Tooltip(message: disabledTooltip, child: row);
    }
    return row;
  }
}

/// Open row: picks from in-memory recents via existing `open()`.
class _OpenRow extends ConsumerWidget {
  const _OpenRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recents = ref.watch(sessionProvider.select((s) => s.recents));
    return _RowButton(
      icon: Icons.folder_open_outlined,
      label: recents.isEmpty ? 'Open' : 'Open (${recents.length})',
      onTap: recents.isEmpty
          ? null
          : () {
              final first = recents.first;
              ref.read(sessionProvider.notifier).open(first);
              _closeDrawerIfOpen(context);
            },
    );
  }
}

/// Pops only when opened as an overlay drawer (never the editor route).
void _closeDrawerIfOpen(BuildContext context) {
  if (Scaffold.of(context).isDrawerOpen) Navigator.pop(context);
}
