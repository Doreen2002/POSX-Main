import 'dart:convert';
import 'dart:io';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';

class BackupCredentialWriter {
  /// Writes a credentials JSON to the given path.
  /// Example path: C:\PosX\mariadb\creds.json
  /// This will set NTFS ACLs so only the current user can read it.
  static Future<void> writeCredsFile(String path) async {
    await UserPreference.getInstance();
    final host = UserPreference.getString(PrefKeys.databaseHostUrl) ?? '127.0.0.1';
    final user = UserPreference.getString(PrefKeys.databaseUser) ?? '';
    final port = UserPreference.getString(PrefKeys.databasePort) ?? '3306';
    final db = UserPreference.getString(PrefKeys.databaseName) ?? '';
    final pwd = UserPreference.getString(PrefKeys.databasePassword) ?? '';

    final map = {
      'host': host,
      'user': user,
      'port': port,
      'database': db,
      // we write plain password per user's preference; consider encrypting with DPAPI later
      'password_plain': pwd,
    };

    final dir = File(path).parent;
    if (!await dir.exists()) await dir.create(recursive: true);
    final file = File(path);
    await file.writeAsString(jsonEncode(map), flush: true);

    // Tighten ACLs by calling icacls (Windows only)
    try {
      if (Platform.isWindows) {
        // remove inheritance
        await Process.run('icacls', [path, '/inheritance:r']);
        // grant read to current user only
        final userName = Platform.environment['USERNAME'] ?? '';
        await Process.run('icacls', [path, '/grant:r', '$userName:(R)']);
      }
    } catch (e) {
      // ignore ACL errors; file still written
    }
  }
}
