import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'project_manager.dart';
import 'services/project_storage.dart';

/// First screen: branding, New Project, recents + on-disk projects.
class ProjectManagerScreen extends ConsumerWidget {
  const ProjectManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('SimAVR')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              const Icon(Icons.memory, size: 64),
              const SizedBox(height: 8),
              Text('SimAVR',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              const Text('Project-based AVR circuit environment',
                  textAlign: TextAlign.center),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const NewProjectDialog(),
                ),
                icon: const Icon(Icons.add),
                label: const Text('New Project'),
              ),
              const SizedBox(height: 24),
              Text('Recent Projects',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (session.recents.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child:
                        Text('No projects yet. Create one to open the editor.'),
                  ),
                )
              else
                for (final p in session.recents)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.folder),
                      title: Text(p.name),
                      onTap: () =>
                          ref.read(sessionProvider.notifier).open(p),
                    ),
                  ),
              const SizedBox(height: 24),
              Text('On This Device',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              const _SavedProjectList(),
            ],
          ),
        ),
      ),
    );
  }
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
      error: (e, _) => Text('Could not list saved projects: $e'),
      data: (names) => Column(
        children: [
          if (names.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Nothing saved yet. Use Save in the editor.'),
              ),
            )
          else
            for (final n in names)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.sd_storage),
                  title: Text(n),
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
      title: const Text('New Project'),
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
            child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Create')),
      ],
    );
  }
}
