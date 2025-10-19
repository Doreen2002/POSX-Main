import 'dart:io';
import 'package:offline_pos/data_source/local/user_preference.dart';

class BackupScheduler {
  static const String taskBaseName = 'PosX_MariaDB_Backup';

  /// Create or update scheduled tasks based on provided times (HH:mm strings).
  /// If [runAsSystem] is true the task will be created to run as SYSTEM (requires admin privileges).
  static Future<bool> createOrUpdateTasks({required List<String> times, int retentionDays = 7, String scriptPath = r'C:\PosX\mariadb\backup_mariadb.ps1', bool runAsSystem = true}) async {
    if (!Platform.isWindows) return false;

    // sanitize times: keep only up to 2 entries of HH:mm
    final sanitized = times.where((t) => t.trim().isNotEmpty).take(2).toList();
    if (sanitized.isEmpty) return false;

    // Remove existing tasks we manage
    await deleteAllTasks();

    bool allOk = true;

    for (var i = 0; i < sanitized.length; i++) {
      final time = sanitized[i];
      final name = (sanitized.length == 1) ? taskBaseName : '${taskBaseName}_${i == 0 ? 'A' : 'B'}';

      // Build schtasks args
      final args = <String>[
        '/Create',
        '/SC',
        'DAILY',
        '/TN',
        name,
        '/TR',
        'powershell.exe -NoProfile -ExecutionPolicy Bypass -File "${scriptPath.replaceAll('\"', '\\\"')}"',
        '/ST',
        time,
        '/F'
      ];

      if (runAsSystem) {
        // add RUN AS SYSTEM
        // Insert before the force flag
        args.insertAll(args.length - 1, ['/RU', 'SYSTEM']);
      }

      try {
        final result = await Process.run('schtasks', args, runInShell: true);
        if (result.exitCode != 0) {
          allOk = false;
        }
      } catch (e) {
        allOk = false;
      }
    }

    // persist settings
    await UserPreference.getInstance();
    await UserPreference.putStringList('backup_times', sanitized);
    await UserPreference.putInt('backup_retention_days', retentionDays);
    await UserPreference.putString('backup_script_path', scriptPath);

    return allOk;
  }

  /// Delete any tasks created by this service
  static Future<void> deleteAllTasks() async {
    if (!Platform.isWindows) return;
    final names = [taskBaseName, '${taskBaseName}_A', '${taskBaseName}_B'];
    for (final name in names) {
      try {
        await Process.run('schtasks', ['/Delete', '/TN', name, '/F'], runInShell: true);
      } catch (_) {}
    }
  }

  /// Helper: read scheduled backup settings from UserPreference
  static Future<Map<String, dynamic>> getSavedBackupSettings() async {
    await UserPreference.getInstance();
    final times = UserPreference.getStringList('backup_times') ?? <String>[];
    final retention = UserPreference.getInt('backup_retention_days') ?? 7;
    final scriptPath = UserPreference.getString('backup_script_path') ?? r'C:\PosX\mariadb\backup_mariadb.ps1';
    return {'times': times, 'retention': retention, 'script': scriptPath};
  }
}
