import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/editor_theme.dart';
import 'project_manager.dart';
import 'services/project_storage.dart';

/// DYAMM project lobby — Bauhaus Neo-Brutalist per DESIGN.md:
/// paper ground, ink blocks, offset shadows, uppercase CTAs.
/// Logic untouched (session recents + on-disk `.dyamm` open).
class ProjectManagerScreen extends ConsumerWidget {
  const ProjectManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    return Theme(
      data: managerTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'DYAMM',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
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
                  decoration: Brutalist.card(),
                  child: const Column(
                    children: [
                      Icon(Icons.memory, size: 56, color: Brutalist.ink),
                      SizedBox(height: 12),
                      Text(
                        'DYAMM-AVR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                          color: Brutalist.ink,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'SCHEMA DESIGN · PROJECT LOBBY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Brutalist.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  style: Brutalist.button(bg: Brutalist.yellow).copyWith(
                    foregroundColor: const WidgetStatePropertyAll(
                      Brutalist.ink,
                    ),
                  ),
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => const NewProjectDialog(),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'NEW PROJECT',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(height: 28),
                const _SectionTitle('RECENT PROJECTS'),
                const SizedBox(height: 10),
                if (session.recents.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: Brutalist.card(),
                    child: const Text(
                      'NO PROJECTS YET. CREATE ONE TO OPEN THE EDITOR.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                else
                  for (final p in session.recents)
                    _BrutalRow(
                      icon: Icons.folder,
                      label: p.name,
                      onTap: () => ref.read(sessionProvider.notifier).open(p),
                    ),
                const SizedBox(height: 28),
                const _SectionTitle('ON THIS DEVICE'),
                const SizedBox(height: 10),
                const _SavedProjectList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Container(
    color: Brutalist.ink,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    child: Text(
      text,
      style: const TextStyle(
        color: Brutalist.paper,
        fontWeight: FontWeight.w900,
        letterSpacing: 2,
        fontSize: 13,
      ),
    ),
  );
}

class _BrutalRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _BrutalRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: Brutalist.card(),
        child: Row(
          children: [
            Icon(icon, color: Brutalist.ink),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward, color: Brutalist.ink),
          ],
        ),
      ),
    ),
  );
}

/// Lists `.dyamm` files saved on device; tap opens into the editor.
/// Shows nothing while loading and an error line on failure.
class _SavedProjectList extends ConsumerWidget {
  const _SavedProjectList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(_savedProjectsProvider);
    return saved.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Text(
        'COULD NOT LIST SAVED PROJECTS: $e',
        style: const TextStyle(
          color: Brutalist.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      data: (names) => Column(
        children: [
          if (names.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: Brutalist.card(),
              child: const Text(
                'NOTHING SAVED YET. USE SAVE IN THE EDITOR.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            )
          else
            for (final n in names)
              _BrutalRow(
                icon: Icons.sd_storage,
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
    return Theme(
      data: managerTheme(),
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          side: Brutalist.borderSide,
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: Brutalist.paper,
        title: const Text(
          'NEW PROJECT',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Project name',
            errorText: _error,
          ),
          onSubmitted: (_) => _submit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            style: Brutalist.button(),
            onPressed: _submit,
            child: const Text('CREATE'),
          ),
        ],
      ),
    );
  }
}
