import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/models/component.dart';
import 'models/project.dart';

export 'models/project.dart';

/// Project state: components + wires (PRD §40). UI mutates via notifier only.
final projectManagerProvider =
    NotifierProvider<ProjectManager, Project>(ProjectManager.new);

class ProjectManager extends Notifier<Project> {
  @override
  Project build() => const Project(name: 'untitled');

  void addComponent(Component c) =>
      state = Project(name: state.name, components: [...state.components, c], wires: state.wires);

  void addWire(Wire w) =>
      state = Project(name: state.name, components: state.components, wires: [...state.wires, w]);

  void clear() => state = Project(name: state.name);
}
