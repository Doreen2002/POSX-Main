
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common_utils/app_colors.dart';
import '../widgets_components/hardware_optimization_panel.dart';
import '../widgets_components/auto_persist.dart';
import '../data_source/local/user_preference.dart';
import '../data_source/local/pref_keys.dart';
import '../services/backup_credential_writer.dart';
import '../services/backup_scheduler.dart';

class BackupSettingsSection extends StatefulWidget {
  const BackupSettingsSection({Key? key}) : super(key: key);
  @override
  State<BackupSettingsSection> createState() => BackupSettingsSectionState();
}

class BackupSettingsSectionState extends State<BackupSettingsSection> {
  final TextEditingController _folder = TextEditingController();
  int _retention = 3;
  int _runs = 1;
  TimeOfDay _first = const TimeOfDay(hour: 2, minute: 0);
  bool _busy = false;

  final String _defaultFolder = r'C:\PosX\mariadb\backups';
  final String _script = r'C:\PosX\mariadb\backup_mariadb.ps1';

  // allowed options
  static const List<int> _retentionOptions = [3, 4, 5];
  static const List<int> _runsOptions = [1, 2];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _folder.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    final folder = UserPreference.getString(PrefKeys.backupFolder);
    final retention = UserPreference.getInt(PrefKeys.backupRetentionDays);
    final runs = UserPreference.getInt(PrefKeys.backupRunsPerDay);
    final h = UserPreference.getInt(PrefKeys.backupFirstRunHour) ?? _first.hour;
    final m = UserPreference.getInt(PrefKeys.backupFirstRunMinute) ?? _first.minute;

    setState(() {
      _folder.text = folder ?? _defaultFolder;
      _retention = _retentionOptions.contains(retention) ? (retention ?? _retention) : _retentionOptions.first;
      _runs = _runsOptions.contains(runs) ? (runs ?? _runs) : _runsOptions.first;
      _first = TimeOfDay(hour: h, minute: m);
    });
  }

  List<String> _times() {
    final t1 = '${_first.hour.toString().padLeft(2, '0')}:${_first.minute.toString().padLeft(2, '0')}';
    if (_runs == 1) return [t1];
    final t2Hour = (_first.hour + 12) % 24;
    final t2 = '${t2Hour.toString().padLeft(2, '0')}:${_first.minute.toString().padLeft(2, '0')}';
    return [t1, t2];
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putString(PrefKeys.backupFolder, _folder.text);
      await UserPreference.putInt(PrefKeys.backupRetentionDays, _retention);
      await UserPreference.putInt(PrefKeys.backupRunsPerDay, _runs);
      await UserPreference.putInt(PrefKeys.backupFirstRunHour, _first.hour);
      await UserPreference.putInt(PrefKeys.backupFirstRunMinute, _first.minute);

      final dir = Directory(_folder.text);
      if (!await dir.exists()) await dir.create(recursive: true);

      final credsPath = Directory(_folder.text).parent.path + '${Platform.pathSeparator}creds.json';
      await BackupCredentialWriter.writeCredsFile(credsPath);

      final ok = await BackupScheduler.createOrUpdateTasks(
        times: _times(),
        retentionDays: _retention,
        scriptPath: _script,
        runAsSystem: false,
      );

      if (!ok) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Saved but scheduling failed (admin required)'),
          backgroundColor: Colors.orange,
        ));
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup settings saved')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _runNow() async {
    setState(() => _busy = true);
    try {
      final credsPath = Directory(_folder.text).parent.path + '${Platform.pathSeparator}creds.json';
      await BackupCredentialWriter.writeCredsFile(credsPath);
      final res = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', _script], runInShell: true);
      if (res.exitCode == 0) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${res.stderr ?? res.stdout}')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure dropdown values are valid for the current options to avoid duplicate/value-mismatch errors.
    final safeRetention = _retentionOptions.contains(_retention) ? _retention : _retentionOptions.first;
    final safeRuns = _runsOptions.contains(_runs) ? _runs : _runsOptions.first;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Local MariaDB Backups', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          TextField(controller: _folder, decoration: const InputDecoration(labelText: 'Backup folder')),
          SizedBox(height: 8.h),
          Row(children: [
            const Text('Retention'),
            const SizedBox(width: 8),
            // Safe Dropdown for retention
            DropdownButton<int>(
              value: safeRetention,
              items: _retentionOptions
                  .map((d) => DropdownMenuItem<int>(value: d, child: Text('$d')))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _retention = v);
              },
            ),
            const SizedBox(width: 20),
            const Text('Runs/day'),
            const SizedBox(width: 8),
            // Safe Dropdown for runs
            DropdownButton<int>(
              value: safeRuns,
              items: _runsOptions
                  .map((d) => DropdownMenuItem<int>(value: d, child: Text('$d')))
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _runs = v);
              },
            ),
          ]),
          SizedBox(height: 8.h),
          Row(children: [
            const Text('First run'),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () async {
                final t = await showTimePicker(context: context, initialTime: _first);
                if (t != null && mounted) setState(() => _first = t);
              },
              child: Text(_first.format(context)),
            ),
          ]),
          SizedBox(height: 12.h),
          Row(children: [
            ElevatedButton(
              onPressed: _busy ? null : _save,
              child: _busy
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: _busy ? null : _runNow, child: const Text('Backup Now')),
          ]),
        ]),
      ),
    );
  }
}
