import '../models/project.dart';

/// Project save/load contract over StorageService (PRD §38).
abstract class ProjectStorage {
  Future<void> save(Project project);
  Future<Project?> open(String name);
}
