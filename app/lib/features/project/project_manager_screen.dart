import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/editor_theme.dart';
import 'project_manager.dart';
import 'services/project_storage.dart';

/// DYAMM project lobby — dark-CAD visual language per screen.png:
/// canvas ground, panel cards, bordered rows, white primary CTA.
/// Portrait vertical file manager; logic untouched
/// (session recents + on-disk `.dyamm` open).
class ProjectManagerScreen extends ConsumerWidget {
  const ProjectManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DYAMM',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: EditorColors.panel,
                  border: Border.all(color: EditorColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Icon(
                          Icons.memory,
                          size: 32,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'DYAMM',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '-AVR',
                          style: TextStyle(
                            fontSize: 34,
                            color: EditorColors.muted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Schema design · project lobby',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: EditorColors.fontMono,
                        color: EditorColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const NewProjectDialog(),
                ),
                icon: const Icon(Icons.add),
                label: const Text('New Project'),
              ),
              const SizedBox(height: 28),
              const _SectionTitle('Recent Projects'),
              const SizedBox(height: 10),
              if (session.recents.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: EditorColors.panel,
                    border: Border.all(color: EditorColors.border),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'No projects yet. Create one to open the editor.',
                    style: TextStyle(color: EditorColors.muted, fontSize: 12),
                  ),
                )
              else
                for (final p in session.recents)
                  _FileRow(
                    icon: Icons.folder_outlined,
                    label: p.name,
                    onTap: () => ref.read(sessionProvider.notifier).open(p),
                  ),
              const SizedBox(height: 28),
              const _SectionTitle('On This Device'),
              const SizedBox(height: 10),
              const _SavedProjectList(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Dock-style section header: uppercase 12px, letter-spaced, bottom border.
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: EditorColors.border)),
    ),
    child: Text(
      text.toUpperCase(),
      style: const TextStyle(
        color: EditorColors.bright,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
        fontSize: 12,
      ),
    ),
  );
}

class _FileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _FileRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Material(
      color: EditorColors.card,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: EditorColors.border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: EditorColors.muted),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: EditorColors.bright,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '.dyamm',
                style: TextStyle(
                  color: EditorColors.muted,
                  fontFamily: EditorColors.fontMono,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: EditorColors.muted,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Lists `.dyamm` files saved on device; tap opens into the editor.
/// Shows nothing while loading and an error strip on failure.
class _SavedProjectList extends ConsumerWidget {
  const _SavedProjectList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(_savedProjectsProvider);
    return saved.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF3A1414),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'Could not list saved projects: $e',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      data: (names) => Column(
        children: [
          if (names.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EditorColors.panel,
                border: Border.all(color: EditorColors.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Nothing saved yet. Use Save in the editor.',
                style: TextStyle(color: EditorColors.muted, fontSize: 12),
              ),
            )
          else
            for (final n in names)
              _FileRow(
                icon: Icons.sd_storage_outlined,
                label: n,
                onTap: () async {
                  final ok = await ref
                      .read(sessionProvider.notifier)
                      .openSaved(await FileProjectStorage.appDir(), n);
                  if (!ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open $n')),
                    );
                  }
                },
              ),
        ],
      ),
    );
  }
}

final _savedProjectsProvider = FutureProvider<List<String>>((ref) async {
  final storage = await FileProjectStorage.appDir();
  return storage.list();
});

/// Name dialog owns its controller so dispose aligns with the route lifecycle.
class NewProjectDialog extends ConsumerStatefulWidget {
  const NewProjectDialog({super.key});

  @override
  ConsumerState<NewProjectDialog> createState() => _NewProjectDialogState();
}

class _NewProjectDialogState extends ConsumerState<NewProjectDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final result = ref.read(sessionProvider.notifier).create(_controller.text);
    if (result == CreateResult.emptyName) {
      setState(() => _error = 'Enter a project name');
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: EditorColors.panel,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: EditorColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      title: const Text(
        'New Project',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: const TextStyle(color: EditorColors.bright),
        decoration: InputDecoration(
          labelText: 'Project name',
          errorText: _error,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: EditorColors.muted),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: _submit,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
