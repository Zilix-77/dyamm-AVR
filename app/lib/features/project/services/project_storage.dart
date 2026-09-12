import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/project.dart';

export '../models/project.dart';

/// Project save/load contract (PRD §38).
abstract class ProjectStorage {
  Future<void> save(Project project);
  Future<Project?> open(String name);
  Future<List<String>> list();
}

/// JSON files in the app documents directory, one `<name>.dyamm` per project.
/// Phase 2 scope: no folders, no thumbnails, no delete UI.
class FileProjectStorage implements ProjectStorage {
  final Directory dir;
  const FileProjectStorage(this.dir);

  static Future<FileProjectStorage> appDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/simavr_projects');
    await dir.create(recursive: true);
    if (!await dir.exists()) {
      throw StateError('storage unavailable at ${dir.path}');
    }
    return FileProjectStorage(dir);
  }

  String _file(String name) =>
      '${dir.path}/${_sanitize(name)}.dyamm';

  static String _sanitize(String name) =>
      name.replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_');

  @override
  Future<void> save(Project project) =>
      File(_file(project.name)).writeAsString(jsonEncode(project.toJson()));

  @override
  Future<Project?> open(String name) async {
    final f = File(_file(name));
    if (!await f.exists()) return null;
    return Project.fromJson(
        Map<String, dynamic>.from(jsonDecode(await f.readAsString()) as Map));
  }

  @override
  Future<List<String>> list() async {
    if (!await dir.exists()) return [];
    final names = <String>[];
    await for (final e in dir.list()) {
      if (e is File && e.path.endsWith('.dyamm')) {
        names.add(e.uri.pathSegments.last.replaceAll(RegExp(r'\.dyamm$'), ''));
      }
    }
    names.sort();
    return names;
  }
}
