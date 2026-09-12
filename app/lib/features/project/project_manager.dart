import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/models/component.dart';
import 'models/project.dart';

export 'models/project.dart';

/// In-memory session (Phase 0). No persistence, no `.dyamm` format yet.
@immutable
class ProjectSession {
  final List<Project> recents;
  final Project? active;
  const ProjectSession({this.recents = const [], this.active});

  ProjectSession copyWith({List<Project>? recents, Project? active}) =>
      ProjectSession(recents: recents ?? this.recents, active: active);
}

final sessionProvider = NotifierProvider<SessionController, ProjectSession>(
  SessionController.new,
);

/// Result of [SessionController.create] for dialog validation feedback.
enum CreateResult { ok, emptyName }

class SessionController extends Notifier<ProjectSession> {
  @override
  ProjectSession build() => const ProjectSession();

  CreateResult create(String rawName) {
    final name = rawName.trim();
    if (name.isEmpty) return CreateResult.emptyName;
    final project = Project(name: name);
    state = ProjectSession(
      recents: [
        project,
        for (final p in state.recents)
          if (p.name != name) p,
      ],
      active: project,
    );
    return CreateResult.ok;
  }

  void open(Project project) {
    state = ProjectSession(
      recents: [
        project,
        for (final p in state.recents)
          if (p.name != project.name) p,
      ],
      active: project,
    );
  }

  void close() => state = ProjectSession(recents: state.recents);

  void addComponent(Component c) {
    final active = state.active;
    if (active == null) return;
    final updated = Project(
      name: active.name,
      components: [...active.components, c],
      wires: active.wires,
    );
    state = ProjectSession(
      recents: [
        for (final p in state.recents)
          if (p.name != updated.name) p,
        updated,
      ],
      active: updated,
    );
  }
}
