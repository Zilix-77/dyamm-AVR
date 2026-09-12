import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'project_manager.dart';

/// First screen (Phase 0): branding, New Project, in-memory recents.
/// File-based open arrives in Phase 2.
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
            ],
          ),
        ),
      ),
    );
  }
}

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
