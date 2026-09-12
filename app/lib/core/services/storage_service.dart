/// Offline-first local persistence contract (PRD §41).
/// Impl: JSON files under app documents dir. No cloud.
abstract class StorageService {
  Future<void> writeJson(String key, Map<String, dynamic> json);
  Future<Map<String, dynamic>?> readJson(String key);
}
