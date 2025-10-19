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

/// Single clean Hardware Settings page.
class HardwareSettingsPage extends StatelessWidget {
  const HardwareSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(children: [Icon(Icons.settings, size: 22.sp, color: Colors.white), SizedBox(width: 8.w), const Text('Hardware Settings')]),
        backgroundColor: AppColors.appbarGreen,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          ReceiptPrinterSection(),
          SizedBox(height: 12),
          VFDSection(),
          SizedBox(height: 12),
          CashDrawerSection(),
          SizedBox(height: 12),
          BackupSettingsSection(),
          SizedBox(height: 16),
          HardwareOptimizationPanel(),
        ]),
      ),
    );
  }
}

class ReceiptPrinterSection extends StatelessWidget {
  const ReceiptPrinterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Receipt Printer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Builder(builder: (ctx) => SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () async { ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Scanning for printers...'))); await Future.delayed(const Duration(milliseconds: 400)); }, icon: const Icon(Icons.search), label: const Text('Scan for Printers')))),
          SizedBox(height: 12.h),
          AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Silent Print'))),
          AutoPersist<bool>(prefKey: PrefKeys.autoPrintReceipt, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Auto-print on payment'))),
          SizedBox(height: 12.h),
          AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) {
            final available = <String>['Default Printer', 'Epson TM-T20', 'Star TSP143'];
            return DropdownButton<String>(value: val, isExpanded: true, items: available.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => onChanged(v));
          }),
          SizedBox(height: 12.h),
          Builder(builder: (ctx) => SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Test print queued'))), child: const Text('Test Print')))),
        ]),
      ),
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

    /// Hardware Settings - single clean implementation.
    class HardwareSettingsPage extends StatelessWidget {
      const HardwareSettingsPage({Key? key}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,
          appBar: AppBar(
            title: Row(children: [Icon(Icons.settings, size: 22.sp, color: Colors.white), SizedBox(width: 8.w), const Text('Hardware Settings')]),
            backgroundColor: AppColors.appbarGreen,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(12.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              ReceiptPrinterSection(),
              SizedBox(height: 12),
              VFDSection(),
              SizedBox(height: 12),
              CashDrawerSection(),
              SizedBox(height: 12),
              BackupSettingsSection(),
              SizedBox(height: 16),
              HardwareOptimizationPanel(),
            ]),
          ),
        );
      }
    }

    class ReceiptPrinterSection extends StatefulWidget {
      const ReceiptPrinterSection({Key? key}) : super(key: key);
      @override
      State<ReceiptPrinterSection> createState() => _ReceiptPrinterSectionState();
    }

    class _ReceiptPrinterSectionState extends State<ReceiptPrinterSection> {
      final TextEditingController _phoneController = TextEditingController();
      List<String> _available = [];
      bool _scanning = false;

      @override
      void initState() {
        super.initState();
        UserPreference.getInstance().then((_) {
          _phoneController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? '';
          setState(() {});
        });
      }

      @override
      void dispose() {
        _phoneController.dispose();
        super.dispose();
      }

      Future<void> _scan() async {
        setState(() => _scanning = true);
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
          _available = ['Default Printer', 'Epson TM-T20', 'Star TSP143'];
          _scanning = false;
        });
      }

      void _testPrint() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test print queued')));

      @override
      Widget build(BuildContext context) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Receipt Printer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _scanning ? null : _scan, icon: _scanning ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.search), label: Text(_scanning ? 'Scanning...' : 'Scan for Printers'))),
              SizedBox(height: 12.h),
              if (_available.isNotEmpty)
                AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) {
                  return DropdownButton<String>(value: val, isExpanded: true, items: _available.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => onChanged(v));
                }),
              SizedBox(height: 12.h),
              AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Silent Print'))),
              AutoPersist<bool>(prefKey: PrefKeys.autoPrintReceipt, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Auto-print on payment'))),
              SizedBox(height: 12.h),
              TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone for receipts'), keyboardType: TextInputType.phone, onChanged: (v) async { await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.receiptPhoneNumber, v); }),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _testPrint, child: const Text('Test Print'))),
            ]),
          ),
        );
      }
    }

    class VFDSection extends StatelessWidget {
      const VFDSection({Key? key}) : super(key: key);
      @override
      Widget build(BuildContext context) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('VFD Display', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              AutoPersist<bool>(prefKey: PrefKeys.vfdEnabled, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Enable VFD Display'))),
              SizedBox(height: 8.h),
              Builder(builder: (ctx) => SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('VFD test message sent'))), child: const Text('Test VFD')))),
            ]),
          ),
        );
      }
    }

    class CashDrawerSection extends StatelessWidget {
      const CashDrawerSection({Key? key}) : super(key: key);
      @override
      Widget build(BuildContext context) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Cash Drawer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              AutoPersist<bool>(prefKey: PrefKeys.openCashDrawer, defaultValue: true, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Open cash drawer on sale'))),
              SizedBox(height: 8.h),
              Builder(builder: (ctx) => SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Open cash drawer'))), child: const Text('Test Cash Drawer')))),
            ]),
          ),
        );
      }
    }

    class BackupSettingsSection extends StatefulWidget {
      const BackupSettingsSection({Key? key}) : super(key: key);
      @override
      State<BackupSettingsSection> createState() => _BackupSettingsSectionState();
    }

    class _BackupSettingsSectionState extends State<BackupSettingsSection> {
      final TextEditingController _folder = TextEditingController();
      int _retention = 3;
      int _runs = 1;
      TimeOfDay _first = const TimeOfDay(hour: 2, minute: 0);
      bool _busy = false;

      final String _defaultFolder = r'C:\PosX\mariadb\backups';
      final String _script = r'C:\PosX\mariadb\backup_mariadb.ps1';

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
        _folder.text = UserPreference.getString(PrefKeys.backupFolder) ?? _defaultFolder;
        _retention = UserPreference.getInt(PrefKeys.backupRetentionDays) ?? 3;
        _runs = UserPreference.getInt(PrefKeys.backupRunsPerDay) ?? 1;
        final h = UserPreference.getInt(PrefKeys.backupFirstRunHour) ?? _first.hour;
        final m = UserPreference.getInt(PrefKeys.backupFirstRunMinute) ?? _first.minute;
        setState(() => _first = TimeOfDay(hour: h, minute: m));
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

          final ok = await BackupScheduler.createOrUpdateTasks(times: _times(), retentionDays: _retention, scriptPath: _script, runAsSystem: false);
          if (!ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved but scheduling failed (admin required)'), backgroundColor: Colors.orange));
          else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup settings saved')));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
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
          if (res.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
          else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${res.stderr ?? res.stdout}')));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
        } finally {
          if (mounted) setState(() => _busy = false);
        }
      }

      @override
      Widget build(BuildContext context) {
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
                DropdownButton<int>(value: _retention, items: [3, 4, 5].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retention = v ?? 3)),
                const SizedBox(width: 20),
                const Text('Runs/day'),
                const SizedBox(width: 8),
                DropdownButton<int>(value: _runs, items: [1, 2].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _runs = v ?? 1)),
              ]),
              SizedBox(height: 8.h),
              Row(children: [
                const Text('First run'),
                const SizedBox(width: 8),
                TextButton(onPressed: () async { final t = await showTimePicker(context: context, initialTime: _first); if (t != null) setState(() => _first = t); }, child: Text(_first.format(context))),
              ]),
              SizedBox(height: 12.h),
              Row(children: [
                ElevatedButton(onPressed: _busy ? null : _save, child: _busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save')),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: _busy ? null : _runNow, child: const Text('Backup Now')),
              ]),
            ]),
          ),
        );
      }
    }
          ]),
        ),
      );
    }
  }

    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    setState(() => _scanning = true);
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _available = ['Default Printer', 'Epson TM-T20', 'Star TSP143'];
      _scanning = false;
    });
  }

  void _testPrint() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test print queued')));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Receipt Printer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _scanning ? null : _scan, icon: _scanning ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.search), label: Text(_scanning ? 'Scanning...' : 'Scan for Printers'))),
          SizedBox(height: 12.h),
          if (_available.isNotEmpty)
            AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) {
              return DropdownButton<String>(value: val, isExpanded: true, items: _available.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => onChanged(v));
            }),
          SizedBox(height: 12.h),
          AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Silent Print'))),
          AutoPersist<bool>(prefKey: PrefKeys.autoPrintReceipt, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Auto-print on payment'))),
          SizedBox(height: 12.h),
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone for receipts'), keyboardType: TextInputType.phone, onChanged: (v) async { await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.receiptPhoneNumber, v); }),
          SizedBox(height: 12.h),
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _testPrint, child: const Text('Test Print'))),
        ]),
      ),
    );
  }
}

class _VFDSection extends StatefulWidget {
  const _VFDSection({Key? key}) : super(key: key);
  @override
  State<_VFDSection> createState() => _VFDSectionState();
}

class _VFDSectionState extends State<_VFDSection> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) => setState(() => _enabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? false));
  }

  void _test() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('VFD test message sent')));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('VFD Display', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          SwitchListTile(value: _enabled, onChanged: (v) async { setState(() => _enabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.vfdEnabled, v); }, title: const Text('Enable VFD Display')),
          if (_enabled) SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _test, child: const Text('Test VFD'))),
        ]),
      ),
    );
  }
}

class _CashDrawerSection extends StatefulWidget {
  const _CashDrawerSection({Key? key}) : super(key: key);
  @override
  State<_CashDrawerSection> createState() => _CashDrawerSectionState();
}

class _CashDrawerSectionState extends State<_CashDrawerSection> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) => setState(() => _enabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? false));
  }

  void _test() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open cash drawer')));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cash Drawer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          SwitchListTile(value: _enabled, onChanged: (v) async { setState(() => _enabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.openCashDrawer, v); }, title: const Text('Open cash drawer on sale')),
          if (_enabled) SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _test, child: const Text('Test Cash Drawer'))),
        ]),
      ),
    );
  }
}

class _BackupSettingsSection extends StatefulWidget {
  const _BackupSettingsSection({Key? key}) : super(key: key);
  @override
  State<_BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<_BackupSettingsSection> {
  final TextEditingController _folder = TextEditingController();
  int _retention = 3;
  int _runs = 1;
  TimeOfDay _first = const TimeOfDay(hour: 2, minute: 0);
  bool _busy = false;

  final String _defaultFolder = r'C:\PosX\\mariadb\\backups';
  final String _script = r'C:\PosX\\mariadb\\backup_mariadb.ps1';

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
    _folder.text = UserPreference.getString(PrefKeys.backupFolder) ?? _defaultFolder;
    _retention = UserPreference.getInt(PrefKeys.backupRetentionDays) ?? 3;
    _runs = UserPreference.getInt(PrefKeys.backupRunsPerDay) ?? 1;
    final h = UserPreference.getInt(PrefKeys.backupFirstRunHour) ?? _first.hour;
    final m = UserPreference.getInt(PrefKeys.backupFirstRunMinute) ?? _first.minute;
    setState(() => _first = TimeOfDay(hour: h, minute: m));
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

      final creds = Directory(_folder.text).parent.path + '${Platform.pathSeparator}creds.json';
      await BackupCredentialWriter.writeCredsFile(creds);

      final ok = await BackupScheduler.createOrUpdateTasks(times: _times(), retentionDays: _retention, scriptPath: _script, runAsSystem: true);
      if (!ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved but scheduling failed (needs admin)'), backgroundColor: Colors.orange));
      else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup settings saved')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _runNow() async {
    setState(() => _busy = true);
    try {
      final creds = Directory(_folder.text).parent.path + '${Platform.pathSeparator}creds.json';
      await BackupCredentialWriter.writeCredsFile(creds);
      final res = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', _script], runInShell: true);
      if (res.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${res.stderr ?? res.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            DropdownButton<int>(value: _retention, items: [3, 4, 5].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retention = v ?? 3)),
            const SizedBox(width: 20),
            const Text('Runs/day'),
            const SizedBox(width: 8),
            DropdownButton<int>(value: _runs, items: [1, 2].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _runs = v ?? 1)),
          ]),
          SizedBox(height: 8.h),
          Row(children: [
            const Text('First run'),
            const SizedBox(width: 8),
            TextButton(onPressed: () async { final t = await showTimePicker(context: context, initialTime: _first); if (t != null) setState(() => _first = t); }, child: Text(_first.format(context))),
          ]),
          SizedBox(height: 12.h),
          Row(children: [
            ElevatedButton(onPressed: _busy ? null : _save, child: _busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: _busy ? null : _runNow, child: const Text('Backup Now')),
          ]),
        ]),
      ),
    );
  }
}
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

/// Minimal, single implementation for Hardware Settings page.
class HardwareSettingsPage extends StatelessWidget {
  const HardwareSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(children: [Icon(Icons.settings, size: 22.sp, color: Colors.white), SizedBox(width: 8.w), const Text('Hardware Settings')]),
        backgroundColor: AppColors.appbarGreen,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          _ReceiptPrinterSection(),
          SizedBox(height: 12),
          _VFDSection(),
          SizedBox(height: 12),
          _CashDrawerSection(),
          SizedBox(height: 12),
          _BackupSettingsSection(),
          SizedBox(height: 16),
          HardwareOptimizationPanel(),
        ]),
      ),
    );
  }
}

// (Sections omitted for brevity — they are identical to the earlier compact implementations.)

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

/// Single clean implementation of hardware settings page.
class HardwareSettingsPage extends StatelessWidget {
  const HardwareSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(children: [Icon(Icons.settings, size: 22.sp, color: Colors.white), SizedBox(width: 8.w), const Text('Hardware Settings')]),
        backgroundColor: AppColors.appbarGreen,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          _ReceiptPrinterSection(),
          SizedBox(height: 12),
          _VFDSection(),
          SizedBox(height: 12),
          _CashDrawerSection(),
          SizedBox(height: 12),
          _BackupSettingsSection(),
          SizedBox(height: 16),
          HardwareOptimizationPanel(),
        ]),
      ),
    );
  }
}

// The rest of the file implements compact sections (printer, vfd, cash drawer, backups)
class _ReceiptPrinterSection extends StatefulWidget {
  const _ReceiptPrinterSection({Key? key}) : super(key: key);
  @override
  State<_ReceiptPrinterSection> createState() => _ReceiptPrinterSectionState();
}

class _ReceiptPrinterSectionState extends State<_ReceiptPrinterSection> {
  final TextEditingController _phoneController = TextEditingController();
  List<String> _available = [];
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) {
      _phoneController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? '';
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    setState(() => _scanning = true);
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _available = ['Default Printer', 'Epson TM-T20', 'Star TSP143'];
      _scanning = false;
    });
  }

  void _testPrint() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test print queued')));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Receipt Printer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _scanning ? null : _scan, icon: _scanning ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.search), label: Text(_scanning ? 'Scanning...' : 'Scan for Printers'))),
          SizedBox(height: 12.h),
          if (_available.isNotEmpty)
            AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) {
              return DropdownButton<String>(value: val, isExpanded: true, items: _available.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => onChanged(v));
            }),
          SizedBox(height: 12.h),
          AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Silent Print'))),
          AutoPersist<bool>(prefKey: PrefKeys.autoPrintReceipt, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Auto-print on payment'))),
          SizedBox(height: 12.h),
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone for receipts'), keyboardType: TextInputType.phone, onChanged: (v) async { await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.receiptPhoneNumber, v); }),
          SizedBox(height: 12.h),
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _testPrint, child: const Text('Test Print'))),
        ]),
      ),
    );
  }
}

class _VFDSection extends StatefulWidget {
  const _VFDSection({Key? key}) : super(key: key);
  @override
  State<_VFDSection> createState() => _VFDSectionState();
}

class _VFDSectionState extends State<_VFDSection> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) => setState(() => _enabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? false));
  }

  void _test() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('VFD test message sent')));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('VFD Display', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          SwitchListTile(value: _enabled, onChanged: (v) async { setState(() => _enabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.vfdEnabled, v); }, title: const Text('Enable VFD Display')),
          if (_enabled) SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _test, child: const Text('Test VFD'))),
        ]),
      ),
    );
  }
}

class _CashDrawerSection extends StatefulWidget {
  const _CashDrawerSection({Key? key}) : super(key: key);
  @override
  State<_CashDrawerSection> createState() => _CashDrawerSectionState();
}

class _CashDrawerSectionState extends State<_CashDrawerSection> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) => setState(() => _enabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? false));
  }

  void _test() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open cash drawer')));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cash Drawer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          SwitchListTile(value: _enabled, onChanged: (v) async { setState(() => _enabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.openCashDrawer, v); }, title: const Text('Open cash drawer on sale')),
          if (_enabled) SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _test, child: const Text('Test Cash Drawer'))),
        ]),
      ),
    );
  }
}

class _BackupSettingsSection extends StatefulWidget {
  const _BackupSettingsSection({Key? key}) : super(key: key);
  @override
  State<_BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<_BackupSettingsSection> {
  final TextEditingController _folder = TextEditingController();
  int _retention = 3;
  int _runs = 1;
  TimeOfDay _first = const TimeOfDay(hour: 2, minute: 0);
  bool _busy = false;

  final String _defaultFolder = r'C:\PosX\mariadb\backups';
  final String _script = r'C:\PosX\mariadb\backup_mariadb.ps1';

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
    _folder.text = UserPreference.getString(PrefKeys.backupFolder) ?? _defaultFolder;
    _retention = UserPreference.getInt(PrefKeys.backupRetentionDays) ?? 3;
    _runs = UserPreference.getInt(PrefKeys.backupRunsPerDay) ?? 1;
    final h = UserPreference.getInt(PrefKeys.backupFirstRunHour) ?? _first.hour;
    final m = UserPreference.getInt(PrefKeys.backupFirstRunMinute) ?? _first.minute;
    setState(() => _first = TimeOfDay(hour: h, minute: m));
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

      final creds = Directory(_folder.text).parent.path + '${Platform.pathSeparator}creds.json';
      await BackupCredentialWriter.writeCredsFile(creds);

      final ok = await BackupScheduler.createOrUpdateTasks(times: _times(), retentionDays: _retention, scriptPath: _script, runAsSystem: true);
      if (!ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved but scheduling failed (needs admin)'), backgroundColor: Colors.orange));
      else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup settings saved')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _runNow() async {
    setState(() => _busy = true);
    try {
      final creds = Directory(_folder.text).parent.path + '${Platform.pathSeparator}creds.json';
      await BackupCredentialWriter.writeCredsFile(creds);
      final res = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', _script], runInShell: true);
      if (res.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${res.stderr ?? res.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            DropdownButton<int>(value: _retention, items: [3, 4, 5].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retention = v ?? 3)),
            const SizedBox(width: 20),
            const Text('Runs/day'),
            const SizedBox(width: 8),
            DropdownButton<int>(value: _runs, items: [1, 2].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _runs = v ?? 1)),
          ]),
          SizedBox(height: 8.h),
          Row(children: [
            const Text('First run'),
            const SizedBox(width: 8),
            TextButton(onPressed: () async { final t = await showTimePicker(context: context, initialTime: _first); if (t != null) setState(() => _first = t); }, child: Text(_first.format(context))),
          ]),
          SizedBox(height: 12.h),
          Row(children: [
            ElevatedButton(onPressed: _busy ? null : _save, child: _busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: _busy ? null : _runNow, child: const Text('Backup Now')),
          ]),
        ]),
      ),
    );
  }
}
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

/// Hardware Settings - single consolidated, clean implementation.
class HardwareSettingsPage extends StatelessWidget {
  const HardwareSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(children: [Icon(Icons.settings, size: 22.sp, color: Colors.white), SizedBox(width: 8.w), const Text('Hardware Settings')]),
        backgroundColor: AppColors.appbarGreen,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          _ReceiptPrinterSection(),
          SizedBox(height: 12),
          _VFDSection(),
          SizedBox(height: 12),
          _CashDrawerSection(),
          SizedBox(height: 12),
          _BackupSettingsSection(),
          SizedBox(height: 16),
          HardwareOptimizationPanel(),
        ]),
      ),
    );
  }
}

class _ReceiptPrinterSection extends StatefulWidget {
  const _ReceiptPrinterSection({Key? key}) : super(key: key);
  @override
  State<_ReceiptPrinterSection> createState() => _ReceiptPrinterSectionState();
}

class _ReceiptPrinterSectionState extends State<_ReceiptPrinterSection> {
  final TextEditingController _phoneController = TextEditingController();
  List<String> _available = [];
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) {
      _phoneController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? '';
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    setState(() => _scanning = true);
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _available = ['Default Printer', 'Epson TM-T20', 'Star TSP143'];
      _scanning = false;
    });
  }

  void _testPrint() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test print queued')));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Receipt Printer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _scanning ? null : _scan, icon: _scanning ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.search), label: Text(_scanning ? 'Scanning...' : 'Scan for Printers'))),
          SizedBox(height: 12.h),
          if (_available.isNotEmpty)
            AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) {
              return DropdownButton<String>(value: val, isExpanded: true, items: _available.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => onChanged(v));
            }),
          SizedBox(height: 12.h),
          AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Silent Print'))),
          AutoPersist<bool>(prefKey: PrefKeys.autoPrintReceipt, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Auto-print on payment'))),
          SizedBox(height: 12.h),
          TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone for receipts'), keyboardType: TextInputType.phone, onChanged: (v) async { await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.receiptPhoneNumber, v); }),
          SizedBox(height: 12.h),
          SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _testPrint, child: const Text('Test Print'))),
        ]),
      ),
    );
  }
}

class _VFDSection extends StatefulWidget {
  const _VFDSection({Key? key}) : super(key: key);
  @override
  State<_VFDSection> createState() => _VFDSectionState();
}

class _VFDSectionState extends State<_VFDSection> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) => setState(() => _enabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? false));
  }

  void _test() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('VFD test message sent')));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('VFD Display', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          SwitchListTile(value: _enabled, onChanged: (v) async { setState(() => _enabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.vfdEnabled, v); }, title: const Text('Enable VFD Display')),
          if (_enabled) SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _test, child: const Text('Test VFD'))),
        ]),
      ),
    );
  }
}

class _CashDrawerSection extends StatefulWidget {
  const _CashDrawerSection({Key? key}) : super(key: key);
  @override
  State<_CashDrawerSection> createState() => _CashDrawerSectionState();
}

class _CashDrawerSectionState extends State<_CashDrawerSection> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) => setState(() => _enabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? false));
  }

  void _test() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open cash drawer')));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cash Drawer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          SwitchListTile(value: _enabled, onChanged: (v) async { setState(() => _enabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.openCashDrawer, v); }, title: const Text('Open cash drawer on sale')),
          if (_enabled) SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _test, child: const Text('Test Cash Drawer'))),
        ]),
      ),
    );
  }
}

class _BackupSettingsSection extends StatefulWidget {
  const _BackupSettingsSection({Key? key}) : super(key: key);
  @override
  State<_BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<_BackupSettingsSection> {
  final TextEditingController _folder = TextEditingController();
  int _retention = 3;
  int _runs = 1;
  TimeOfDay _first = const TimeOfDay(hour: 2, minute: 0);
  bool _busy = false;

  final String _defaultFolder = r'C:\PosX\mariadb\backups';
  final String _script = r'C:\PosX\mariadb\backup_mariadb.ps1';

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
    _folder.text = UserPreference.getString(PrefKeys.backupFolder) ?? _defaultFolder;
    _retention = UserPreference.getInt(PrefKeys.backupRetentionDays) ?? 3;
    _runs = UserPreference.getInt(PrefKeys.backupRunsPerDay) ?? 1;
    final h = UserPreference.getInt(PrefKeys.backupFirstRunHour) ?? _first.hour;
    final m = UserPreference.getInt(PrefKeys.backupFirstRunMinute) ?? _first.minute;
    setState(() => _first = TimeOfDay(hour: h, minute: m));
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

      final creds = Directory(_folder.text).parent.path + '${Platform.pathSeparator}creds.json';
      await BackupCredentialWriter.writeCredsFile(creds);

      final ok = await BackupScheduler.createOrUpdateTasks(times: _times(), retentionDays: _retention, scriptPath: _script, runAsSystem: true);
      if (!ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved but scheduling failed (needs admin)'), backgroundColor: Colors.orange));
      else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup settings saved')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _runNow() async {
    setState(() => _busy = true);
    try {
      final creds = Directory(_folder.text).parent.path + '${Platform.pathSeparator}creds.json';
      await BackupCredentialWriter.writeCredsFile(creds);
      final res = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', _script], runInShell: true);
      if (res.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${res.stderr ?? res.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            DropdownButton<int>(value: _retention, items: [3, 4, 5].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retention = v ?? 3)),
            const SizedBox(width: 20),
            const Text('Runs/day'),
            const SizedBox(width: 8),
            DropdownButton<int>(value: _runs, items: [1, 2].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _runs = v ?? 1)),
          ]),
          SizedBox(height: 8.h),
          Row(children: [
            const Text('First run'),
            const SizedBox(width: 8),
            TextButton(onPressed: () async { final t = await showTimePicker(context: context, initialTime: _first); if (t != null) setState(() => _first = t); }, child: Text(_first.format(context))),
          ]),
          SizedBox(height: 12.h),
          Row(children: [
            ElevatedButton(onPressed: _busy ? null : _save, child: _busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: _busy ? null : _runNow, child: const Text('Backup Now')),
          ]),
        ]),
      ),
    );
  }
}

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

/// Hardware Settings - single clean implementation
class HardwareSettingsPage extends StatelessWidget {
  const HardwareSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(children: [Icon(Icons.settings, size: 22.sp, color: Colors.white), SizedBox(width: 8.w), const Text('Hardware Settings')]),
        backgroundColor: AppColors.appbarGreen,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ReceiptPrinterCard(),
          SizedBox(height: 12.h),
          VFDCard(),
          SizedBox(height: 12.h),
          CashDrawerCard(),
          SizedBox(height: 12.h),
          BackupCard(),
          SizedBox(height: 16.h),
          const HardwareOptimizationPanel(),
        ]),
      ),
    );
  }
}

class ReceiptPrinterCard extends StatelessWidget {
  ReceiptPrinterCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(children: [
          const Expanded(child: Text('Silent Print (global)')),
          AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: onChanged)),
        ]),
      ),
    );
  }
}

class VFDCard extends StatelessWidget {
  VFDCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(children: [
          const Expanded(child: Text('Enable VFD Display')),
          AutoPersist<bool>(prefKey: PrefKeys.vfdEnabled, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: onChanged)),
        ]),
      ),
    );
  }
}

class CashDrawerCard extends StatelessWidget {
  CashDrawerCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(children: [
          const Expanded(child: Text('Open Cash Drawer on Sale')),
          AutoPersist<bool>(prefKey: PrefKeys.openCashDrawer, defaultValue: true, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: onChanged)),
        ]),
      ),
    );
  }
}

class BackupCard extends StatefulWidget {
  BackupCard({Key? key}) : super(key: key);
  @override
  State<BackupCard> createState() => _BackupCardState();
}

class _BackupCardState extends State<BackupCard> {
  final _folder = TextEditingController();
  int _retention = 3;
  int _runs = 1;
  TimeOfDay _first = const TimeOfDay(hour: 2, minute: 0);
  bool _saving = false;

  final _default = r'C:\PosX\mariadb\backups';
  final _script = r'C:\PosX\mariadb\backup_mariadb.ps1';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    _folder.text = UserPreference.getString(PrefKeys.backupFolder) ?? _default;
    _retention = UserPreference.getInt(PrefKeys.backupRetentionDays) ?? 3;
    _runs = UserPreference.getInt(PrefKeys.backupRunsPerDay) ?? 1;
    final h = UserPreference.getInt(PrefKeys.backupFirstRunHour) ?? _first.hour;
    final m = UserPreference.getInt(PrefKeys.backupFirstRunMinute) ?? _first.minute;
    setState(() => _first = TimeOfDay(hour: h, minute: m));
  }

  List<String> _times() {
    final t1 = '${_first.hour.toString().padLeft(2, '0')}:${_first.minute.toString().padLeft(2, '0')}';
    if (_runs == 1) return [t1];
    final t2Hour = (_first.hour + 12) % 24;
    final t2 = '${t2Hour.toString().padLeft(2, '0')}:${_first.minute.toString().padLeft(2, '0')}';
    return [t1, t2];
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putString(PrefKeys.backupFolder, _folder.text);
      await UserPreference.putInt(PrefKeys.backupRetentionDays, _retention);
      await UserPreference.putInt(PrefKeys.backupRunsPerDay, _runs);
      await UserPreference.putInt(PrefKeys.backupFirstRunHour, _first.hour);
      await UserPreference.putInt(PrefKeys.backupFirstRunMinute, _first.minute);

      final dir = Directory(_folder.text);
      if (!await dir.exists()) await dir.create(recursive: true);

      final creds = Directory(_folder.text).parent.path + '${Platform.pathSeparator}creds.json';
      await BackupCredentialWriter.writeCredsFile(creds);

      final ok = await BackupScheduler.createOrUpdateTasks(times: _times(), retentionDays: _retention, scriptPath: _script, runAsSystem: true);
      if (!ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved but scheduling failed (needs admin)'), backgroundColor: Colors.orange));
      else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup settings saved')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _runNow() async {
    setState(() => _saving = true);
    try {
      final creds = Directory(_folder.text).parent.path + '${Platform.pathSeparator}creds.json';
      await BackupCredentialWriter.writeCredsFile(creds);
      final res = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', _script], runInShell: true);
      if (res.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${res.stderr ?? res.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Local MariaDB Backups', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(controller: _folder, decoration: const InputDecoration(labelText: 'Backup folder')),
          const SizedBox(height: 8),
          Row(children: [
            const Text('Retention'),
            const SizedBox(width: 8),
            DropdownButton<int>(value: _retention, items: [3, 4, 5].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retention = v ?? 3)),
            const SizedBox(width: 20),
            const Text('Runs/day'),
            const SizedBox(width: 8),
            DropdownButton<int>(value: _runs, items: [1, 2].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _runs = v ?? 1)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Text('First run'),
            const SizedBox(width: 8),
            TextButton(onPressed: () async { final t = await showTimePicker(context: context, initialTime: _first); if (t != null) setState(() => _first = t); }, child: Text(_first.format(context))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            ElevatedButton(onPressed: _saving ? null : _save, child: _saving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: _saving ? null : _runNow, child: const Text('Backup Now')),
          ])
        ]),
      ),
    );
  }
}


import '../common_utils/app_colors.dart';
import '../widgets_components/hardware_optimization_panel.dart';
import '../widgets_components/auto_persist.dart';
import '../data_source/local/user_preference.dart';
import '../data_source/local/pref_keys.dart';
import '../services/backup_credential_writer.dart';
import '../services/backup_scheduler.dart';

/// Hardware Settings - single consolidated implementation.
class HardwareSettingsPage extends StatelessWidget {
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

  // A small, single-copy implementation of the hardware settings page.
  class HardwareSettingsPage extends StatelessWidget {
    const HardwareSettingsPage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hardware Settings'), backgroundColor: AppColors.appbarGreen),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12.w),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            ReceiptPrinterSection(),
            SizedBox(height: 12),
            VFDDisplaySection(),
            SizedBox(height: 12),
            CashDrawerSection(),
            SizedBox(height: 12),
            BackupSettingsSection(),
            SizedBox(height: 20),
            HardwareOptimizationPanel(),
          ]),
        ),
      );
    }
  }

  class ReceiptPrinterSection extends StatelessWidget {
    const ReceiptPrinterSection({Key? key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(children: [
            const Expanded(child: Text('Enable Printer')),
            AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: onChanged)),
          ]),
        ),
      );
    }
  }

  class VFDDisplaySection extends StatelessWidget {
    const VFDDisplaySection({Key? key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(children: [
            const Expanded(child: Text('Enable VFD')),
            AutoPersist<bool>(prefKey: PrefKeys.vfdEnabled, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: onChanged)),
          ]),
        ),
      );
    }
  }

  class CashDrawerSection extends StatelessWidget {
    const CashDrawerSection({Key? key}) : super(key: key);
    @override
    Widget build(BuildContext context) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(children: [
            const Expanded(child: Text('Open Cash Drawer after payment')),
            AutoPersist<bool>(prefKey: PrefKeys.openCashDrawer, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: onChanged)),
          ]),
        ),
      );
    }
  }

  class BackupSettingsSection extends StatefulWidget {
    const BackupSettingsSection({Key? key}) : super(key: key);
    @override
    State<BackupSettingsSection> createState() => _BackupSettingsSectionState();
  }

  class _BackupSettingsSectionState extends State<BackupSettingsSection> {
    final TextEditingController _folderController = TextEditingController();
    int _retentionDays = 3;
    int _runsPerDay = 1;
    TimeOfDay _firstRunTime = const TimeOfDay(hour: 2, minute: 0);
    bool _isSaving = false;

    final String _defaultFolder = r'C:\PosX\mariadb\backups';
    final String _scriptPath = r'C:\PosX\mariadb\backup_mariadb.ps1';

    @override
    void initState() {
      super.initState();
      _load();
    }

    Future<void> _load() async {
      await UserPreference.getInstance();
      _folderController.text = UserPreference.getString(PrefKeys.backupFolder) ?? _defaultFolder;
      _retentionDays = UserPreference.getInt(PrefKeys.backupRetentionDays) ?? 3;
      _runsPerDay = UserPreference.getInt(PrefKeys.backupRunsPerDay) ?? 1;
      final h = UserPreference.getInt(PrefKeys.backupFirstRunHour) ?? _firstRunTime.hour;
      final m = UserPreference.getInt(PrefKeys.backupFirstRunMinute) ?? _firstRunTime.minute;
      setState(() => _firstRunTime = TimeOfDay(hour: h, minute: m));
    }

    List<String> _computeRunTimes() {
      final list = <String>[];
      final first = '${_firstRunTime.hour.toString().padLeft(2, '0')}:${_firstRunTime.minute.toString().padLeft(2, '0')}';
      list.add(first);
      if (_runsPerDay == 2) {
        int hour = (_firstRunTime.hour + 12) % 24;
        final second = '${hour.toString().padLeft(2, '0')}:${_firstRunTime.minute.toString().padLeft(2, '0')}';
        list.add(second);
      }
      return list;
    }

    Future<void> _save() async {
      setState(() => _isSaving = true);
      try {
        await UserPreference.getInstance();
        await UserPreference.putString(PrefKeys.backupFolder, _folderController.text);
        await UserPreference.putInt(PrefKeys.backupRetentionDays, _retentionDays);
        await UserPreference.putInt(PrefKeys.backupRunsPerDay, _runsPerDay);
        await UserPreference.putInt(PrefKeys.backupFirstRunHour, _firstRunTime.hour);
        await UserPreference.putInt(PrefKeys.backupFirstRunMinute, _firstRunTime.minute);

        final dir = Directory(_folderController.text);
        if (!await dir.exists()) await dir.create(recursive: true);

        final credsPath = Directory(_folderController.text).parent.path + '\\creds.json';
        final writer = BackupCredentialWriter();
        await writer.writeCredsFile(credsPath);

        final times = _computeRunTimes();
        final scheduler = BackupScheduler();
        final ok = await scheduler.createOrUpdateTasks(times: times, retentionDays: _retentionDays, scriptPath: _scriptPath, runAsSystem: false);
        if (!ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved but scheduling failed (admin required).'), backgroundColor: Colors.orange));
        else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup settings saved')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }

    Future<void> _backupNow() async {
      setState(() => _isSaving = true);
      try {
        final writer = BackupCredentialWriter();
        final credsPath = Directory(_folderController.text).parent.path + '\\creds.json';
        await writer.writeCredsFile(credsPath);

        final result = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', _scriptPath], runInShell: true);
        if (result.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
        else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${result.stderr ?? result.stdout}')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Local MariaDB Backups', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            TextField(controller: _folderController, decoration: const InputDecoration(labelText: 'Backup folder')),
            SizedBox(height: 8.h),
            Row(children: [
              const Text('Retention'),
              const SizedBox(width: 8),
              DropdownButton<int>(value: _retentionDays, items: [3, 4, 5].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retentionDays = v ?? 3)),
              const SizedBox(width: 20),
              const Text('Runs/day'),
              const SizedBox(width: 8),
              DropdownButton<int>(value: _runsPerDay, items: [1, 2].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _runsPerDay = v ?? 1))
            ]),
            SizedBox(height: 8.h),
            Row(children: [
              const Text('First run'),
              const SizedBox(width: 8),
              TextButton(onPressed: () async { final t = await showTimePicker(context: context, initialTime: _firstRunTime); if (t != null) setState(() => _firstRunTime = t); }, child: Text(_firstRunTime.format(context)))
            ]),
            SizedBox(height: 12.h),
            Row(children: [
              ElevatedButton(onPressed: _isSaving ? null : _save, child: _isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Save')),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: _isSaving ? null : _backupNow, child: const Text('Backup Now'))
            ]),
          ]),
        ),
      );
    }
  }
  const HardwareSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(children: [Icon(Icons.settings, size: 22.sp, color: Colors.white), SizedBox(width: 10.w), const Text('Hardware Settings')]),
        backgroundColor: AppColors.appbarGreen,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _headerCard(),
          SizedBox(height: 12.h),
          const ReceiptPrinterSection(),
          SizedBox(height: 12.h),
          const VFDDisplaySection(),
          SizedBox(height: 12.h),
          const CashDrawerSection(),
          SizedBox(height: 12.h),
          const BackupSettingsSection(),
          SizedBox(height: 20.h),
          const HardwareOptimizationPanel(),
        ]),
      ),
    );
  }

  Widget _headerCard() => Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 1))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Configure Hardware & Backups', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.appbarGreen)),
          SizedBox(height: 6.h),
          Text('Receipt printers, VFD, cash drawer and local MariaDB backup settings.', style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade700)),
        ]),
      );
}

/// Receipt Printer
class ReceiptPrinterSection extends StatelessWidget {
  const ReceiptPrinterSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Receipt Printer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Row(children: [
            const Expanded(child: Text('Enable Printer (global)')),
            AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: onChanged)),
          ]),
        ]),
      ),
    );
  }
}

/// VFD Display
class VFDDisplaySection extends StatelessWidget {
  const VFDDisplaySection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('VFD Customer Display', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Row(children: [
            const Expanded(child: Text('Enable VFD')),
            AutoPersist<bool>(prefKey: PrefKeys.vfdEnabled, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: onChanged)),
          ]),
        ]),
      ),
    );
  }
}

/// Cash Drawer
class CashDrawerSection extends StatelessWidget {
  const CashDrawerSection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cash Drawer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Row(children: [
            const Expanded(child: Text('Open Cash Drawer after payment')),
            AutoPersist<bool>(prefKey: PrefKeys.openCashDrawer, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: onChanged)),
          ]),
        ]),
      ),
    );
  }
}

/// Backup Settings UI
class BackupSettingsSection extends StatefulWidget {
  const BackupSettingsSection({Key? key}) : super(key: key);
  @override
  State<BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<BackupSettingsSection> {
  final TextEditingController _folderController = TextEditingController();
  int _retentionDays = 3;
  int _runsPerDay = 1;
  TimeOfDay _firstRunTime = const TimeOfDay(hour: 2, minute: 0);
  bool _isSaving = false;

  final String _defaultFolder = r'C:\PosX\mariadb\backups';
  final String _scriptPath = r'C:\PosX\mariadb\backup_mariadb.ps1';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    _folderController.text = UserPreference.getString(PrefKeys.backupFolder) ?? _defaultFolder;
    _retentionDays = UserPreference.getInt(PrefKeys.backupRetentionDays) ?? 3;
    _runsPerDay = UserPreference.getInt(PrefKeys.backupRunsPerDay) ?? 1;
    final h = UserPreference.getInt(PrefKeys.backupFirstRunHour) ?? _firstRunTime.hour;
    final m = UserPreference.getInt(PrefKeys.backupFirstRunMinute) ?? _firstRunTime.minute;
    setState(() => _firstRunTime = TimeOfDay(hour: h, minute: m));
  }

  List<String> _computeRunTimes() {
    final list = <String>[];
    final first = '${_firstRunTime.hour.toString().padLeft(2, '0')}:${_firstRunTime.minute.toString().padLeft(2, '0')}';
    list.add(first);
    if (_runsPerDay == 2) {
      int hour = (_firstRunTime.hour + 12) % 24;
      final second = '${hour.toString().padLeft(2, '0')}:${_firstRunTime.minute.toString().padLeft(2, '0')}';
      list.add(second);
    }
    return list;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putString(PrefKeys.backupFolder, _folderController.text);
      await UserPreference.putInt(PrefKeys.backupRetentionDays, _retentionDays);
      await UserPreference.putInt(PrefKeys.backupRunsPerDay, _runsPerDay);
      await UserPreference.putInt(PrefKeys.backupFirstRunHour, _firstRunTime.hour);
      await UserPreference.putInt(PrefKeys.backupFirstRunMinute, _firstRunTime.minute);

      final dir = Directory(_folderController.text);
      if (!await dir.exists()) await dir.create(recursive: true);

      final credsPath = Directory(_folderController.text).parent.path + '\\creds.json';
      final writer = BackupCredentialWriter();
      await writer.writeCredsFile(credsPath);

      final times = _computeRunTimes();
      final scheduler = BackupScheduler();
      final ok = await scheduler.createOrUpdateTasks(times: times, retentionDays: _retentionDays, scriptPath: _scriptPath, runAsSystem: false);
      if (!ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved but scheduling failed (admin required).'), backgroundColor: Colors.orange));
      else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup settings saved')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _backupNow() async {
    setState(() => _isSaving = true);
    try {
      final writer = BackupCredentialWriter();
      final credsPath = Directory(_folderController.text).parent.path + '\\creds.json';
      await writer.writeCredsFile(credsPath);

      final result = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', _scriptPath], runInShell: true);
      if (result.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${result.stderr ?? result.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Local MariaDB Backups', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          TextField(controller: _folderController, decoration: const InputDecoration(labelText: 'Backup folder')),
          SizedBox(height: 8.h),
          Row(children: [
            const Text('Retention'),
            const SizedBox(width: 8),
            DropdownButton<int>(value: _retentionDays, items: [3, 4, 5].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retentionDays = v ?? 3)),
            const SizedBox(width: 20),
            const Text('Runs/day'),
            const SizedBox(width: 8),
            DropdownButton<int>(value: _runsPerDay, items: [1, 2].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _runsPerDay = v ?? 1))
          ]),
          SizedBox(height: 8.h),
          Row(children: [
            const Text('First run'),
            const SizedBox(width: 8),
            TextButton(onPressed: () async { final t = await showTimePicker(context: context, initialTime: _firstRunTime); if (t != null) setState(() => _firstRunTime = t); }, child: Text(_firstRunTime.format(context)))
          ]),
          SizedBox(height: 12.h),
          Row(children: [
            ElevatedButton(onPressed: _isSaving ? null : _save, child: _isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Save')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: _isSaving ? null : _backupNow, child: const Text('Backup Now'))
          ]),
        ]),
      ),
    );
  }
}
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

/// Clean, single implementation of Hardware Settings page.
class HardwareSettingsPage extends StatelessWidget {
  const HardwareSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Icon(Icons.settings, size: 24.sp, color: Colors.white), SizedBox(width: 8.w), const Text('Hardware Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
        backgroundColor: AppColors.appbarGreen,
        elevation: 2,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          SizedBox(height: 8),
          _ReceiptPrinterSection(),
          SizedBox(height: 12),
          _VFDDisplaySection(),
          SizedBox(height: 12),
          _CashDrawerSection(),
          SizedBox(height: 12),
          _BackupSettingsSection(),
          SizedBox(height: 24),
          HardwareOptimizationPanel(),
        ]),
      ),
    );
  }
}

class _ReceiptPrinterSection extends StatelessWidget {
  const _ReceiptPrinterSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Receipt Printer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Row(children: [
            const Expanded(child: Text('Enable Printer')),
            AutoPersist<bool>(prefKey: PrefKeys.printerEnabled, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: (v) => onChanged(v))),
          ])
        ]),
      ),
    );
  }
}

class _VFDDisplaySection extends StatelessWidget {
  const _VFDDisplaySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('VFD Display', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Row(children: [
            const Expanded(child: Text('Enable VFD')),
            AutoPersist<bool>(prefKey: PrefKeys.vfdEnabled, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: (v) => onChanged(v))),
          ])
        ]),
      ),
    );
  }
}

class _CashDrawerSection extends StatelessWidget {
  const _CashDrawerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cash Drawer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Row(children: [
            const Expanded(child: Text('Enable Cash Drawer')),
            AutoPersist<bool>(prefKey: PrefKeys.openCashDrawer, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: (v) => onChanged(v))),
          ])
        ]),
      ),
    );
  }
}

class _BackupSettingsSection extends StatefulWidget {
  const _BackupSettingsSection({Key? key}) : super(key: key);

  @override
  State<_BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<_BackupSettingsSection> {
  final TextEditingController _folderController = TextEditingController();
  int _retentionDays = 3;
  int _runsPerDay = 1;
  TimeOfDay _firstRunTime = const TimeOfDay(hour: 2, minute: 0);
  final String _defaultFolder = r'C:\PosX\mariadb\backups';
  final String _scriptPath = r'C:\PosX\mariadb\backup_mariadb.ps1';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    _folderController.text = UserPreference.getString(PrefKeys.backupFolder) ?? _defaultFolder;
    _retentionDays = UserPreference.getInt(PrefKeys.backupRetentionDays) ?? 3;
    _runsPerDay = UserPreference.getInt(PrefKeys.backupRunsPerDay) ?? 1;
    final h = UserPreference.getInt(PrefKeys.backupFirstRunHour) ?? _firstRunTime.hour;
    final m = UserPreference.getInt(PrefKeys.backupFirstRunMinute) ?? _firstRunTime.minute;
    setState(() => _firstRunTime = TimeOfDay(hour: h, minute: m));
  }

  List<String> _computeRunTimes() {
    final list = <String>[];
    final first = '${_firstRunTime.hour.toString().padLeft(2, '0')}:${_firstRunTime.minute.toString().padLeft(2, '0')}';
    list.add(first);
    if (_runsPerDay == 2) {
      int hour = (_firstRunTime.hour + 12) % 24;
      final second = '${hour.toString().padLeft(2, '0')}:${_firstRunTime.minute.toString().padLeft(2, '0')}';
      list.add(second);
    }
    return list;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putString(PrefKeys.backupFolder, _folderController.text);
      await UserPreference.putInt(PrefKeys.backupRetentionDays, _retentionDays);
      await UserPreference.putInt(PrefKeys.backupRunsPerDay, _runsPerDay);
      await UserPreference.putInt(PrefKeys.backupFirstRunHour, _firstRunTime.hour);
      await UserPreference.putInt(PrefKeys.backupFirstRunMinute, _firstRunTime.minute);

      final dir = Directory(_folderController.text);
      if (!await dir.exists()) await dir.create(recursive: true);

      // write creds next to backups folder
      final credsPath = Directory(_folderController.text).parent.path + '\\creds.json';
      final writer = BackupCredentialWriter();
      await writer.writeCredsFile(credsPath);

      final times = _computeRunTimes();
      final scheduler = BackupScheduler();
      await scheduler.createOrUpdateTasks(times: times, retentionDays: _retentionDays, scriptPath: _scriptPath, runAsSystem: false);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup settings saved')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save backup settings: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _backupNow() async {
    setState(() => _isSaving = true);
    try {
      final writer = BackupCredentialWriter();
      final credsPath = Directory(_folderController.text).parent.path + '\\creds.json';
      await writer.writeCredsFile(credsPath);

      final result = await Process.run('powershell', ['-ExecutionPolicy', 'Bypass', '-File', _scriptPath], runInShell: true);
      if (result.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${result.stderr ?? result.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Local MariaDB Backups', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          TextField(controller: _folderController, decoration: const InputDecoration(labelText: 'Backup folder')),
          SizedBox(height: 8),
          Row(children: [
            const Text('Retention (days): '),
            const SizedBox(width: 8),
            DropdownButton<int>(value: _retentionDays, items: [3, 4, 5].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retentionDays = v ?? 3)),
            const SizedBox(width: 24),
            const Text('Runs per day:'),
            const SizedBox(width: 8),
            DropdownButton<int>(value: _runsPerDay, items: [1, 2].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _runsPerDay = v ?? 1)),
          ]),
          SizedBox(height: 8),
          Row(children: [
            const Text('First run time: '),
            const SizedBox(width: 8),
            TextButton(child: Text('${_firstRunTime.format(context)}'), onPressed: () async { final t = await showTimePicker(context: context, initialTime: _firstRunTime); if (t != null) setState(() => _firstRunTime = t); }),
          ]),
          SizedBox(height: 12),
          Row(children: [ElevatedButton(onPressed: _isSaving ? null : _save, child: const Text('Save')), const SizedBox(width: 12), OutlinedButton(onPressed: _isSaving ? null : _backupNow, child: const Text('Backup Now'))]),
        ]),
      ),
    );
  }
}
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

/// Consolidated Hardware Settings Page
class HardwareSettingsPage extends StatelessWidget {
  const HardwareSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(children: [Icon(Icons.settings, size: 24.sp, color: Colors.white), SizedBox(width: 8.w), const Text('Hardware Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
        backgroundColor: AppColors.appbarGreen,
        elevation: 2,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _headerCard(),
          SizedBox(height: 16.h),
          _databaseOptimizationCard(),
          SizedBox(height: 16.h),
          const _ReceiptPrinterSection(),
          SizedBox(height: 16.h),
          const _VFDDisplaySection(),
          SizedBox(height: 16.h),
          const _CashDrawerSection(),
          SizedBox(height: 16.h),
          const _BackupSettingsSection(),
        ]),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Configure Hardware Devices', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.appbarGreen)),
        SizedBox(height: 8.h),
        Text('Set up receipt printers, VFD displays, cash drawers, and database performance.', style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700, height: 1.4)),
      ]),
    );
  }

  Widget _databaseOptimizationCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.storage, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Database Optimization', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text('Hardware detection & MariaDB tuning', style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
          children: [
            Container(padding: EdgeInsets.all(12.w), margin: EdgeInsets.only(bottom: 16.h), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.blue.shade200)), child: Row(children: [Icon(Icons.info_outline, color: Colors.blue, size: 20.sp), SizedBox(width: 8.w), Expanded(child: Text('Automatically detects hardware and optimizes MariaDB. Applied on startup.', style: TextStyle(color: Colors.blue.shade700, fontSize: 14.sp)))])),
            const HardwareOptimizationPanel(),
          ],
        ),
      ),
    );
  }
}

// The below sections implement the UI for Receipt printer, VFD, Cash Drawer and Backups.
// They are intentionally compact and use AutoPersist where appropriate.

class _ReceiptPrinterSection extends StatefulWidget {
  const _ReceiptPrinterSection({Key? key}) : super(key: key);
  @override
  State<_ReceiptPrinterSection> createState() => _ReceiptPrinterSectionState();
}

class _ReceiptPrinterSectionState extends State<_ReceiptPrinterSection> {
  List<String> _availablePrinters = [];
  String? _selectedPrinter;
  bool _isScanning = false;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) {
      _selectedPrinter = UserPreference.getString(PrefKeys.receiptPrinterUrl);
      _phoneController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? '';
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _scanPrinters() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _availablePrinters = ['Default Printer', 'Epson TM-T20', 'Star TSP143'];
      _isScanning = false;
    });
  }

  void _testPrint() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test print sent')));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.print, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Receipt Printer', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_selectedPrinter ?? 'No printer configured', style: TextStyle(fontSize: 14.sp, color: _selectedPrinter != null ? Colors.grey.shade600 : Colors.red.shade400)),
          children: [
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _isScanning ? null : _scanPrinters, icon: _isScanning ? SizedBox(width: 16.w, height: 16.h, child: const CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.search), label: Text(_isScanning ? 'Scanning...' : 'Scan for Printers'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 12.h)))),
            SizedBox(height: 16.h),
            if (_availablePrinters.isNotEmpty) ...[
              AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) {
                return Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)), padding: EdgeInsets.symmetric(horizontal: 12.w), child: DropdownButton<String>(isExpanded: true, underline: const SizedBox.shrink(), value: val, hint: Row(children: [Icon(Icons.print, size: 20.sp, color: Colors.grey), SizedBox(width: 8.w), const Text('Select a printer')]), items: _availablePrinters.map((printer) => DropdownMenuItem(value: printer, child: Text(printer))).toList(), onChanged: (value) { onChanged(value); setState(() => _selectedPrinter = value); }));
              }),
              SizedBox(height: 16.h),
            ],
            AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: Text('Silent Print'), activeColor: AppColors.appbarGreen)),
            AutoPersist<bool>(prefKey: PrefKeys.autoPrintReceipt, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: Text('Auto-Print on Payment'), activeColor: AppColors.appbarGreen)),
            SizedBox(height: 12.h),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Phone Number', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)), SizedBox(height: 8.h), Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: TextField(controller: _phoneController, decoration: InputDecoration(hintText: 'Enter phone number for receipts', prefixIcon: Icon(Icons.phone, color: AppColors.appbarGreen), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h)), keyboardType: TextInputType.phone, onChanged: (value) async { await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.receiptPhoneNumber, value); }))]),
            SizedBox(height: 16.h),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _selectedPrinter != null ? _testPrint : null, icon: const Icon(Icons.check), label: const Text('Test Print'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.appbarGreen, side: BorderSide(color: AppColors.appbarGreen), padding: EdgeInsets.symmetric(vertical: 12.h)))),
          ],
        ),
      ),
    );
  }
}

class _VFDDisplaySection extends StatefulWidget {
  const _VFDDisplaySection({Key? key}) : super(key: key);
  @override
  State<_VFDDisplaySection> createState() => _VFDDisplaySectionState();
}

class _VFDDisplaySectionState extends State<_VFDDisplaySection> {
  bool _vfdEnabled = false;
  final List<String> _comPorts = ['COM1', 'COM2', 'COM3', 'COM4'];

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) {
      setState(() => _vfdEnabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? false);
    });
  }

  void _testDisplay() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test message sent to VFD')));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          leading: Icon(Icons.computer, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('VFD Customer Display', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_vfdEnabled ? 'Enabled' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _vfdEnabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            SwitchListTile(value: _vfdEnabled, onChanged: (v) async { setState(() => _vfdEnabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.vfdEnabled, v); }, title: Text('Enable VFD Display', style: TextStyle(fontSize: 16.sp))),
            if (_vfdEnabled) ...[
              _buildConfigRow('COM Port', DropdownButton<String>(value: _comPorts.first, items: _comPorts.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) {})),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _testDisplay, icon: const Icon(Icons.check), label: const Text('Test VFD Display'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.appbarGreen, side: BorderSide(color: AppColors.appbarGreen))))
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, Widget widget) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), SizedBox(width: 12.w), Expanded(child: widget)];
}

class _CashDrawerSection extends StatefulWidget {
  const _CashDrawerSection({Key? key}) : super(key: key);
  @override
  State<_CashDrawerSection> createState() => _CashDrawerSectionState();
}

class _CashDrawerSectionState extends State<_CashDrawerSection> {
  bool _enabled = false;
  String _connection = 'printer';

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) {
      setState(() {
        _enabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? false;
        _connection = UserPreference.getString(PrefKeys.cashDrawerConnectionType) ?? 'printer';
      });
    });
  }

  void _testDrawer() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening cash drawer...')));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          leading: Icon(Icons.point_of_sale, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Cash Drawer', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_enabled ? 'Enabled' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _enabled ? Colors.grey.shade600 : Colors.red.shade400)),
          children: [
            SwitchListTile(value: _enabled, onChanged: (v) async { setState(() => _enabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.openCashDrawer, v); }, title: Text('Enable Cash Drawer')),
            if (_enabled) ...[
              ListTile(title: const Text('Connection Method'), subtitle: Text(_connection)),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _testDrawer, icon: const Icon(Icons.open_in_new), label: const Text('Test Cash Drawer'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen)))
            ]
          ],
        ),
      ),
    );
  }
}

class _BackupSettingsSection extends StatefulWidget {
  const _BackupSettingsSection({Key? key}) : super(key: key);
  @override
  State<_BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<_BackupSettingsSection> {
  bool _enabled = false;
  int _runsPerDay = 1;
  TimeOfDay _firstTime = const TimeOfDay(hour: 2, minute: 0);
  int _retentionDays = 3;
  String _backupFolder = r'C:\PosX\\mariadb\\backups';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) async {
      final saved = await BackupScheduler.getSavedBackupSettings();
      final times = (saved['times'] as List).cast<String>();
      if (times.isNotEmpty) {
        final parts = times[0].split(':');
        final h = int.tryParse(parts[0]) ?? 2;
        final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
        _firstTime = TimeOfDay(hour: h, minute: m);
        _enabled = true;
      }
      _retentionDays = saved['retention'] as int? ?? 3;
      _backupFolder = UserPreference.getString('backup_folder') ?? _backupFolder;
      _runsPerDay = UserPreference.getInt('backup_runs_per_day') ?? 1;
      setState(() {});
    });
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _firstTime);
    if (t != null) setState(() => _firstTime = t);
  }

  Future<void> _pickFolder() async {
    if (Platform.isWindows) {
      try {
        final ps = r"Add-Type -AssemblyName System.Windows.Forms; $d = New-Object System.Windows.Forms.FolderBrowserDialog; $d.ShowNewFolderButton = $true; if($d.ShowDialog() -eq 'OK'){ Write-Output $d.SelectedPath }";
        final result = await Process.run('powershell', ['-NoProfile', '-Command', ps], runInShell: true);
        final out = (result.stdout ?? '').toString().trim();
        if (out.isNotEmpty) {
          setState(() => _backupFolder = out);
          return;
        }
      } catch (_) {}
    }
    final controller = TextEditingController(text: _backupFolder);
    final val = await showDialog<String?>(context: context, builder: (ctx) => AlertDialog(title: const Text('Backup folder'), content: TextField(controller: controller), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('OK'))]));
    if (val != null && val.trim().isNotEmpty) setState(() => _backupFolder = val.trim());
  }

  String _timeToStr(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putBool('backup_enabled', _enabled);
      await UserPreference.putInt('backup_runs_per_day', _runsPerDay);
      await UserPreference.putInt('backup_retention_days', _retentionDays);
      await UserPreference.putString('backup_folder', _backupFolder);

      final dir = Directory(_backupFolder);
      if (!await dir.exists()) await dir.create(recursive: true);

      final credsPath = r'C:\PosX\\mariadb\\creds.json';
      await BackupCredentialWriter.writeCredsFile(credsPath);

      final times = <String>[_timeToStr(_firstTime)];
      if (_runsPerDay == 2) {
        final secondHour = (_firstTime.hour + 12) % 24;
        final second = TimeOfDay(hour: secondHour, minute: _firstTime.minute);
        times.add(_timeToStr(second));
      }

      final scheduledOk = await BackupScheduler.createOrUpdateTasks(times: times, retentionDays: _retentionDays, scriptPath: r'C:\PosX\\mariadb\\backup_mariadb.ps1', runAsSystem: true);
      if (!scheduledOk) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup saved, but scheduling failed. Run the app as administrator.'), backgroundColor: Colors.orange));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving backup settings: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _backupNow() async {
    setState(() => _isSaving = true);
    try {
      final script = r'C:\PosX\\mariadb\\backup_mariadb.ps1';
      final result = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script], runInShell: true);
      if (result.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${result.stderr ?? result.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          leading: Icon(Icons.folder, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Backups', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_enabled ? 'Enabled' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _enabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            SwitchListTile(value: _enabled, onChanged: (v) => setState(() => _enabled = v), title: Text('Enable automatic backups', style: TextStyle(fontSize: 16.sp))),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('Runs per day', style: TextStyle(fontSize: 15.sp))), DropdownButton<int>(value: _runsPerDay, items: [1, 2].map((e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(), onChanged: (v) => setState(() => _runsPerDay = v ?? 1))]),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('First run time', style: TextStyle(fontSize: 15.sp))), TextButton(onPressed: _pickTime, child: Text(_timeToStr(_firstTime)))]),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('Retention (days)', style: TextStyle(fontSize: 15.sp))), DropdownButton<int>(value: _retentionDays, items: [3, 4, 5].map((d) => DropdownMenuItem<int>(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retentionDays = v ?? 3))]),
            SizedBox(height: 8.h),
            Text('Backup folder', style: TextStyle(fontSize: 15.sp)),
            SizedBox(height: 6.h),
            Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)), padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h), child: Row(children: [Expanded(child: Text(_backupFolder)), TextButton(onPressed: _pickFolder, child: const Text('Change'))])),
            SizedBox(height: 12.h),
            Row(children: [Expanded(child: ElevatedButton(onPressed: _isSaving ? null : _save, style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen), child: _isSaving ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Save'))), SizedBox(width: 12.w), SizedBox(width: 140.w, child: OutlinedButton(onPressed: _isSaving ? null : _backupNow, child: const Text('Backup Now')))]),
          ],
        ),
      ),
    );
  }
}
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

/// Consolidated Hardware Settings Page
class HardwareSettingsPage extends StatelessWidget {
  const HardwareSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(children: [Icon(Icons.settings, size: 24.sp, color: Colors.white), SizedBox(width: 8.w), const Text('Hardware Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
        backgroundColor: AppColors.appbarGreen,
        elevation: 2,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _headerCard(),
          SizedBox(height: 16.h),
          _databaseOptimizationCard(),
          SizedBox(height: 16.h),
          const ReceiptPrinterSection(),
          SizedBox(height: 16.h),
          const VFDDisplaySection(),
          SizedBox(height: 16.h),
          const CashDrawerSection(),
          SizedBox(height: 16.h),
          const BackupSettingsSection(),
        ]),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Configure Hardware Devices', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.appbarGreen)),
        SizedBox(height: 8.h),
        Text('Set up receipt printers, VFD displays, cash drawers, and database performance.', style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700, height: 1.4)),
      ]),
    );
  }

  Widget _databaseOptimizationCard() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.storage, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Database Optimization', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text('Hardware detection & MariaDB tuning', style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
          children: [
            Container(padding: EdgeInsets.all(12.w), margin: EdgeInsets.only(bottom: 16.h), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.blue.shade200)), child: Row(children: [Icon(Icons.info_outline, color: Colors.blue, size: 20.sp), SizedBox(width: 8.w), Expanded(child: Text('Automatically detects hardware and optimizes MariaDB. Applied on startup.', style: TextStyle(color: Colors.blue.shade700, fontSize: 14.sp)))])),
            const HardwareOptimizationPanel(),
          ],
        ),
      ),
    );
  }
}

/// Receipt printer section
class ReceiptPrinterSection extends StatefulWidget {
  const ReceiptPrinterSection({Key? key}) : super(key: key);
  @override
  State<ReceiptPrinterSection> createState() => _ReceiptPrinterSectionState();
}

class _ReceiptPrinterSectionState extends State<ReceiptPrinterSection> {
  List<String> _availablePrinters = [];
  String? _selectedPrinter;
  bool _isScanning = false;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    setState(() { _selectedPrinter = UserPreference.getString(PrefKeys.receiptPrinterUrl); _phoneController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? ''; });
  }

  @override
  void dispose() { _phoneController.dispose(); super.dispose(); }

  Future<void> _scanPrinters() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() { _availablePrinters = ['Default Printer', 'Epson TM-T20']; _isScanning = false; });
  }

  void _testPrint() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test print sent')));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.print, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Receipt Printer', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_selectedPrinter ?? 'No printer configured', style: TextStyle(fontSize: 14.sp, color: _selectedPrinter != null ? Colors.grey.shade600 : Colors.red.shade400)),
          children: [
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _isScanning ? null : _scanPrinters, icon: _isScanning ? SizedBox(width: 16.w, height: 16.h, child: const CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.search), label: Text(_isScanning ? 'Scanning...' : 'Scan for Printers'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 12.h)))),
            SizedBox(height: 12.h),
            if (_availablePrinters.isNotEmpty) AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) {
              return Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)), padding: EdgeInsets.symmetric(horizontal: 12.w), child: DropdownButton<String>(isExpanded: true, underline: const SizedBox.shrink(), value: val, hint: Row(children: [Icon(Icons.print, size: 20.sp, color: Colors.grey), SizedBox(width: 8.w), const Text('Select a printer')]), items: _availablePrinters.map((printer) => DropdownMenuItem(value: printer, child: Text(printer))).toList(), onChanged: (value) { onChanged(value); setState(() => _selectedPrinter = value); }));
            }),
            SizedBox(height: 12.h),
            AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: Text('Silent Print'), activeColor: AppColors.appbarGreen)),
            AutoPersist<bool>(prefKey: PrefKeys.autoPrintReceipt, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: Text('Auto-Print on Payment'), activeColor: AppColors.appbarGreen)),
            SizedBox(height: 12.h),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Phone Number', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)), SizedBox(height: 8.h), Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: TextField(controller: _phoneController, decoration: InputDecoration(hintText: 'Enter phone number for receipts', prefixIcon: Icon(Icons.phone, color: AppColors.appbarGreen), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h)), keyboardType: TextInputType.phone, onChanged: (value) async { await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.receiptPhoneNumber, value); }))]),
            SizedBox(height: 12.h),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _selectedPrinter != null ? _testPrint : null, icon: const Icon(Icons.check), label: const Text('Test Print'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.appbarGreen, side: BorderSide(color: AppColors.appbarGreen), padding: EdgeInsets.symmetric(vertical: 12.h)))),
          ],
        ),
      ),
    );
  }
}

/// VFD Display Section
class VFDDisplaySection extends StatefulWidget {
  const VFDDisplaySection({Key? key}) : super(key: key);
  @override
  State<VFDDisplaySection> createState() => _VFDDisplaySectionState();
}

class _VFDDisplaySectionState extends State<VFDDisplaySection> {
  bool _vfdEnabled = false;
  final List<String> _comPorts = ['COM1', 'COM2', 'COM3', 'COM4'];

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) { setState(() => _vfdEnabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? false); });
  }

  void _testDisplay() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test message sent to VFD')));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          leading: Icon(Icons.computer, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('VFD Customer Display', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_vfdEnabled ? 'Enabled' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _vfdEnabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            SwitchListTile(value: _vfdEnabled, onChanged: (v) async { setState(() => _vfdEnabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.vfdEnabled, v); }, title: Text('Enable VFD Display', style: TextStyle(fontSize: 16.sp))),
            if (_vfdEnabled) ...[
              SizedBox(height: 12.h),
              _buildConfigRow('COM Port', DropdownButton<String>(value: _comPorts.first, items: _comPorts.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) {})),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _testDisplay, icon: const Icon(Icons.check), label: const Text('Test VFD Display'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.appbarGreen, side: BorderSide(color: AppColors.appbarGreen))))
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, Widget widget) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), SizedBox(width: 12.w), Expanded(child: widget)];
}

/// Cash Drawer Section
class CashDrawerSection extends StatefulWidget {
  const CashDrawerSection({Key? key}) : super(key: key);
  @override
  State<CashDrawerSection> createState() => _CashDrawerSectionState();
}

class _CashDrawerSectionState extends State<CashDrawerSection> {
  bool _enabled = false;
  String _connection = 'printer';

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) { setState(() { _enabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? false; _connection = UserPreference.getString(PrefKeys.cashDrawerConnectionType) ?? 'printer'; }); });
  }

  void _testDrawer() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening cash drawer...')));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          leading: Icon(Icons.point_of_sale, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Cash Drawer', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_enabled ? 'Enabled' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _enabled ? Colors.grey.shade600 : Colors.red.shade400)),
          children: [
            SwitchListTile(value: _enabled, onChanged: (v) async { setState(() => _enabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.openCashDrawer, v); }, title: Text('Enable Cash Drawer')),
            if (_enabled) ...[
              ListTile(title: const Text('Connection Method'), subtitle: Text(_connection)),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _testDrawer, icon: const Icon(Icons.open_in_new), label: const Text('Test Cash Drawer'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen)))
            ]
          ],
        ),
      ),
    );
  }
}

/// Backup Settings
class BackupSettingsSection extends StatefulWidget {
  const BackupSettingsSection({Key? key}) : super(key: key);
  @override
  State<BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<BackupSettingsSection> {
  final TextEditingController _folderController = TextEditingController();
  int _retentionDays = 3;
  int _runsPerDay = 1;
  TimeOfDay _firstRunTime = const TimeOfDay(hour: 2, minute: 0);
  bool _isSaving = false;

  final String _defaultFolder = r'C:\PosX\\mariadb\\backups';
  final String _scriptPath = r'C:\PosX\\mariadb\\backup_mariadb.ps1';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    _folderController.text = UserPreference.getString(PrefKeys.backupFolder) ?? r'C:\PosX\\mariadb\\backups';
    _retentionDays = UserPreference.getInt(PrefKeys.backupRetentionDays) ?? 3;
    _runsPerDay = UserPreference.getInt(PrefKeys.backupRunsPerDay) ?? 1;
    final h = UserPreference.getInt(PrefKeys.backupFirstRunHour) ?? _firstRunTime.hour;
    final m = UserPreference.getInt(PrefKeys.backupFirstRunMinute) ?? _firstRunTime.minute;
    setState(() => _firstRunTime = TimeOfDay(hour: h, minute: m));
  }

  List<String> _computeRunTimes() {
    final list = <String>[];
    final first = '${_firstRunTime.hour.toString().padLeft(2, '0')}:${_firstRunTime.minute.toString().padLeft(2, '0')}';
    list.add(first);
    if (_runsPerDay == 2) {
      int hour = (_firstRunTime.hour + 12) % 24;
      final second = '${hour.toString().padLeft(2, '0')}:${_firstRunTime.minute.toString().padLeft(2, '0')}';
      list.add(second);
    }
    return list;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putString(PrefKeys.backupFolder, _folderController.text);
      await UserPreference.putInt(PrefKeys.backupRetentionDays, _retentionDays);
      await UserPreference.putInt(PrefKeys.backupRunsPerDay, _runsPerDay);
      await UserPreference.putInt(PrefKeys.backupFirstRunHour, _firstRunTime.hour);
      await UserPreference.putInt(PrefKeys.backupFirstRunMinute, _firstRunTime.minute);

      final dir = Directory(_folderController.text);
      if (!await dir.exists()) await dir.create(recursive: true);

      // write creds next to backups folder
      final credsPath = Directory(_folderController.text).parent.path + '\\creds.json';
      final writer = BackupCredentialWriter();
      await writer.writeCredsFile(credsPath);

      final times = _computeRunTimes();
      final scheduler = BackupScheduler();
      final ok = await scheduler.createOrUpdateTasks(times: times, retentionDays: _retentionDays, scriptPath: _scriptPath, runAsSystem: false);
      if (!ok) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved but scheduling failed (requires admin).'), backgroundColor: Colors.orange));
      else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup settings saved')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save backup settings: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _backupNow() async {
    setState(() => _isSaving = true);
    try {
      final writer = BackupCredentialWriter();
      final credsPath = Directory(_folderController.text).parent.path + '\\creds.json';
      await writer.writeCredsFile(credsPath);

      final result = await Process.run('powershell', ['-ExecutionPolicy', 'Bypass', '-File', _scriptPath], runInShell: true);
      if (result.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${result.stderr ?? result.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          leading: Icon(Icons.folder, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Backups', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text('Local MariaDB backups', style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
          children: [
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: TextField(controller: _folderController, decoration: const InputDecoration(labelText: 'Backup folder'))), const SizedBox(width: 12), OutlinedButton(onPressed: _isSaving ? null : () async { /* folder picker omitted */ }, child: const Text('Browse'))]),
            SizedBox(height: 8.h),
            Row(children: [const Text('Retention (days): '), const SizedBox(width: 8), DropdownButton<int>(value: _retentionDays, items: [3,4,5].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retentionDays = v ?? 3)), const SizedBox(width: 24), const Text('Runs per day:'), const SizedBox(width: 8), DropdownButton<int>(value: _runsPerDay, items: [1,2].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _runsPerDay = v ?? 1))]),
            SizedBox(height: 8.h),
            Row(children: [const Text('First run time: '), const SizedBox(width: 8), TextButton(child: Text('${_firstRunTime.format(context)}'), onPressed: () async { final t = await showTimePicker(context: context, initialTime: _firstRunTime); if (t != null) setState(() => _firstRunTime = t); })]),
            SizedBox(height: 12.h),
            Row(children: [ElevatedButton(onPressed: _isSaving ? null : _save, child: _isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Save')), const SizedBox(width: 12), OutlinedButton(onPressed: _isSaving ? null : _backupNow, child: const Text('Backup Now'))]),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
}

// Receipt printer section (compact)
class _ReceiptPrinterSection extends StatefulWidget {
  const _ReceiptPrinterSection({Key? key}) : super(key: key);
  @override
  State<_ReceiptPrinterSection> createState() => _ReceiptPrinterSectionState();
}

class _ReceiptPrinterSectionState extends State<_ReceiptPrinterSection> {
  List<String> _availablePrinters = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) {
      setState(() {});
    });
  }

  Future<void> _scanPrinters() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _availablePrinters = ['Default Printer']);
    setState(() => _isScanning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      child: ExpansionTile(
        leading: Icon(Icons.print, color: AppColors.appbarGreen),
        title: const Text('Receipt Printer'),
        children: [
          SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _isScanning ? null : _scanPrinters, icon: const Icon(Icons.search), label: Text(_isScanning ? 'Scanning...' : 'Scan for Printers'))),
          if (_availablePrinters.isNotEmpty) AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) => DropdownButton<String>(value: val, items: _availablePrinters.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => onChanged(v))),
        ],
      ),
    );
  }
}

// VFD
class _VFDDisplaySection extends StatefulWidget { const _VFDDisplaySection({Key? key}) : super(key: key); @override State<_VFDDisplaySection> createState() => _VFDDisplaySectionState(); }
class _VFDDisplaySectionState extends State<_VFDDisplaySection> {
  bool _vfdEnabled = false;
  @override
  void initState() { super.initState(); UserPreference.getInstance().then((_) { setState(() => _vfdEnabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? false); }); }
  @override
  Widget build(BuildContext context) { return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)), child: ExpansionTile(leading: Icon(Icons.computer, color: AppColors.appbarGreen), title: const Text('VFD Display'), children: [SwitchListTile(value: _vfdEnabled, onChanged: (v) async { setState(() => _vfdEnabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.vfdEnabled, v); }, title: const Text('Enable VFD Display'))])); }
}

// Cash drawer
class _CashDrawerSection extends StatefulWidget { const _CashDrawerSection({Key? key}) : super(key: key); @override State<_CashDrawerSection> createState() => _CashDrawerSectionState(); }
class _CashDrawerSectionState extends State<_CashDrawerSection> {
  bool _enabled = false;
  @override
  void initState() { super.initState(); UserPreference.getInstance().then((_) { setState(() => _enabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? false); }); }
  @override
  Widget build(BuildContext context) { return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)), child: ExpansionTile(leading: Icon(Icons.point_of_sale, color: AppColors.appbarGreen), title: const Text('Cash Drawer'), children: [SwitchListTile(value: _enabled, onChanged: (v) async { setState(() => _enabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.openCashDrawer, v); }, title: const Text('Enable Cash Drawer'))])); }
}

// Backup settings (compact)
class _BackupSettingsSection extends StatefulWidget { const _BackupSettingsSection({Key? key}) : super(key: key); @override State<_BackupSettingsSection> createState() => _BackupSettingsSectionState(); }
class _BackupSettingsSectionState extends State<_BackupSettingsSection> {
  bool _enabled = false;
  int _runsPerDay = 1;
  TimeOfDay _firstTime = const TimeOfDay(hour: 2, minute: 0);
  int _retentionDays = 3;
  String _backupFolder = r'C:\PosX\\mariadb\\backups';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) async {
      final saved = await BackupScheduler.getSavedBackupSettings();
      final times = (saved['times'] as List).cast<String>();
      if (times.isNotEmpty) {
        final parts = times[0].split(':');
        final h = int.tryParse(parts[0]) ?? 2;
        final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
        _firstTime = TimeOfDay(hour: h, minute: m);
        _enabled = true;
      }
      _retentionDays = saved['retention'] as int? ?? 3;
      _backupFolder = UserPreference.getString('backup_folder') ?? _backupFolder;
      _runsPerDay = UserPreference.getInt('backup_runs_per_day') ?? 1;
      setState(() {});
    });
  }

  String _timeToStr(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putBool('backup_enabled', _enabled);
      await UserPreference.putInt('backup_runs_per_day', _runsPerDay);
      await UserPreference.putInt('backup_retention_days', _retentionDays);
      await UserPreference.putString('backup_folder', _backupFolder);

      final dir = Directory(_backupFolder);
      if (!await dir.exists()) await dir.create(recursive: true);

      final credsPath = r'C:\PosX\\mariadb\\creds.json';
      await BackupCredentialWriter.writeCredsFile(credsPath);

      final times = <String>[_timeToStr(_firstTime)];
      if (_runsPerDay == 2) {
        final secondHour = (_firstTime.hour + 12) % 24;
        final second = TimeOfDay(hour: secondHour, minute: _firstTime.minute);
        times.add(_timeToStr(second));
      }

      final scheduledOk = await BackupScheduler.createOrUpdateTasks(times: times, retentionDays: _retentionDays, scriptPath: r'C:\PosX\\mariadb\\backup_mariadb.ps1', runAsSystem: true);
      if (!scheduledOk) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup saved, but scheduling failed. Run the app as administrator.'), backgroundColor: Colors.orange));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving backup settings: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _backupNow() async {
    setState(() => _isSaving = true);
    try {
      final script = r'C:\PosX\\mariadb\\backup_mariadb.ps1';
      final result = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script], runInShell: true);
      if (result.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${result.stderr ?? result.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
      child: ExpansionTile(
        leading: Icon(Icons.folder, color: AppColors.appbarGreen),
        title: const Text('Backups'),
        children: [
          SwitchListTile(value: _enabled, onChanged: (v) => setState(() => _enabled = v), title: const Text('Enable automatic backups')),
          Row(children: [Expanded(child: const Text('Runs per day')), DropdownButton<int>(value: _runsPerDay, items: [1, 2].map((e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(), onChanged: (v) => setState(() => _runsPerDay = v ?? 1))]),
          Row(children: [Expanded(child: const Text('First run time')), TextButton(onPressed: () async { final t = await showTimePicker(context: context, initialTime: _firstTime); if (t != null) setState(() => _firstTime = t); }, child: Text(_timeToStr(_firstTime)))]),
          Row(children: [Expanded(child: const Text('Retention (days)')), DropdownButton<int>(value: _retentionDays, items: [3, 4, 5].map((d) => DropdownMenuItem<int>(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retentionDays = v ?? 3))]),
          Container(padding: EdgeInsets.all(8.w), child: Row(children: [Expanded(child: Text(_backupFolder)), TextButton(onPressed: () async { /* folder picker omitted for brevity */ }, child: const Text('Change'))])),
          Row(children: [Expanded(child: ElevatedButton(onPressed: _isSaving ? null : _save, child: _isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator()) : const Text('Save'))), SizedBox(width: 12.w), OutlinedButton(onPressed: _isSaving ? null : _backupNow, child: const Text('Backup Now'))]),
        ],
      ),
    );
  }
}



/// Receipt Printer Section
class _ReceiptPrinterSection extends StatefulWidget {
  const _ReceiptPrinterSection({Key? key}) : super(key: key);

  @override
  State<_ReceiptPrinterSection> createState() => _ReceiptPrinterSectionState();
}

class _ReceiptPrinterSectionState extends State<_ReceiptPrinterSection> {
  List<String> _availablePrinters = [];
  String? _selectedPrinter;
  bool _isScanning = false;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await UserPreference.getInstance();
    setState(() {
      _selectedPrinter = UserPreference.getString(PrefKeys.receiptPrinterUrl);
      _phoneController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? '';
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _scanPrinters() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => _availablePrinters = ['Default Printer', 'Epson TM-T20', 'Star TSP143']);
    setState(() => _isScanning = false);
  }

  void _testPrint() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test print sent')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.print, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Receipt Printer', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_selectedPrinter ?? 'No printer configured', style: TextStyle(fontSize: 14.sp, color: _selectedPrinter != null ? Colors.grey.shade600 : Colors.red.shade400)),
          children: [
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _isScanning ? null : _scanPrinters, icon: _isScanning ? SizedBox(width: 16.w, height: 16.h, child: const CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.search), label: Text(_isScanning ? 'Scanning...' : 'Scan for Printers'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 12.h)))),
            SizedBox(height: 16.h),
            if (_availablePrinters.isNotEmpty) ...[
              AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) {
                return Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)), padding: EdgeInsets.symmetric(horizontal: 12.w), child: DropdownButton<String>(isExpanded: true, underline: const SizedBox.shrink(), value: val, hint: Row(children: [Icon(Icons.print, size: 20.sp, color: Colors.grey), SizedBox(width: 8.w), const Text('Select a printer')]), items: _availablePrinters.map((printer) => DropdownMenuItem(value: printer, child: Text(printer))).toList(), onChanged: (value) { onChanged(value); setState(() => _selectedPrinter = value); }));
              }),
              SizedBox(height: 16.h),
            ],
            AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) {
              return Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: Text('Silent Print', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)), subtitle: Text('Print without showing OS dialog', style: TextStyle(fontSize: 13.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 12.w)));
            }),
            SizedBox(height: 12.h),
            AutoPersist<bool>(prefKey: PrefKeys.autoPrintReceipt, defaultValue: false, builder: (ctx, val, onChanged) {
              return Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: Text('Auto-Print on Payment', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)), subtitle: Text('Automatically print receipt after payment', style: TextStyle(fontSize: 13.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 12.w)));
            }),
            SizedBox(height: 16.h),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Phone Number', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade800)), SizedBox(height: 8.h), Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: TextField(controller: _phoneController, decoration: InputDecoration(hintText: 'Enter phone number for receipts', prefixIcon: Icon(Icons.phone, color: AppColors.appbarGreen), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h)), keyboardType: TextInputType.phone, onChanged: (value) async { await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.receiptPhoneNumber, value); })),]),
            SizedBox(height: 16.h),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Receipt Footer', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade800)), SizedBox(height: 8.h), Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: AutoPersist<String>(prefKey: PrefKeys.receiptFooterText, defaultValue: '', builder: (ctx, val, onChanged) { final controller = TextEditingController(text: val); controller.addListener(() => onChanged(controller.text)); return TextField(controller: controller, decoration: InputDecoration(hintText: 'Enter custom footer text (e.g., "Thank you for your business!")', prefixIcon: Icon(Icons.notes, color: AppColors.appbarGreen), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h), counterText: ''), maxLines: 3, minLines: 2, maxLength: 200); })) ,
            SizedBox(height: 16.h),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _selectedPrinter != null ? _testPrint : null, icon: const Icon(Icons.check), label: const Text('Test Print (Barcode + QR)'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.appbarGreen, side: BorderSide(color: AppColors.appbarGreen), padding: EdgeInsets.symmetric(vertical: 12.h)))),
          ],
        ),
      ),
    );
  }
}

/// VFD Display Section
class _VFDDisplaySection extends StatefulWidget {
  const _VFDDisplaySection({Key? key}) : super(key: key);

  @override
  State<_VFDDisplaySection> createState() => _VFDDisplaySectionState();
}

class _VFDDisplaySectionState extends State<_VFDDisplaySection> {
  bool _vfdEnabled = false;
  String _comPort = 'COM1';
  int _baudRate = 9600;
  int _dataBits = 8;
  int _stopBits = 1;
  String _parity = 'None';

  final List<String> _comPorts = ['COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8'];
  final List<int> _baudRates = [2400, 4800, 9600, 19200, 38400, 57600, 115200];
  final List<int> _dataBitsList = [7, 8];
  final List<int> _stopBitsList = [1, 2];
  final List<String> _parityList = ['None', 'Even', 'Odd', 'Mark', 'Space'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    UserPreference.getInstance().then((_) {
      setState(() {
        _vfdEnabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? _vfdEnabled;
        _comPort = UserPreference.getString(PrefKeys.vfdComPort) ?? _comPort;
        _baudRate = UserPreference.getInt(PrefKeys.vfdBaudRate) ?? _baudRate;
        _dataBits = UserPreference.getInt(PrefKeys.vfdDataBits) ?? _dataBits;
        _stopBits = UserPreference.getInt(PrefKeys.vfdStopBits) ?? _stopBits;
        _parity = UserPreference.getString(PrefKeys.vfdParity) ?? _parity;
      });
    });
  }

  void _testDisplay() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test message sent to VFD')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.computer, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('VFD Customer Display', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_vfdEnabled ? 'Enabled on $_comPort' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _vfdEnabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: SwitchListTile(value: _vfdEnabled, onChanged: (v) async { setState(() => _vfdEnabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.vfdEnabled, v); }, title: Text('Enable VFD Display', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)), subtitle: Text('2x20 character display', style: TextStyle(fontSize: 13.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 12.w))),
            if (_vfdEnabled) ...[
              SizedBox(height: 12.h),
              _buildConfigRow('COM Port', AutoPersist<String>(prefKey: PrefKeys.vfdComPort, defaultValue: 'COM1', builder: (ctx, val, onChanged) { return DropdownButton<String>(value: val, isDense: true, items: _comPorts.map((port) => DropdownMenuItem(value: port, child: Text(port))).toList(), onChanged: (v) => onChanged(v ?? 'COM1')); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Baud Rate', AutoPersist<int>(prefKey: PrefKeys.vfdBaudRate, defaultValue: 9600, builder: (ctx, val, onChanged) { return DropdownButton<int>(value: val, isDense: true, items: _baudRates.map((rate) => DropdownMenuItem(value: rate, child: Text('$rate'))).toList(), onChanged: (v) => onChanged(v ?? 9600)); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Data Bits', AutoPersist<int>(prefKey: PrefKeys.vfdDataBits, defaultValue: 8, builder: (ctx, val, onChanged) { return DropdownButton<int>(value: val, isDense: true, items: _dataBitsList.map((bits) => DropdownMenuItem(value: bits, child: Text('$bits'))).toList(), onChanged: (v) => onChanged(v ?? 8)); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Stop Bits', AutoPersist<int>(prefKey: PrefKeys.vfdStopBits, defaultValue: 1, builder: (ctx, val, onChanged) { return DropdownButton<int>(value: val, isDense: true, items: _stopBitsList.map((bits) => DropdownMenuItem(value: bits, child: Text('$bits'))).toList(), onChanged: (v) => onChanged(v ?? 1)); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Parity', AutoPersist<String>(prefKey: PrefKeys.vfdParity, defaultValue: 'None', builder: (ctx, val, onChanged) { return DropdownButton<String>(value: val, isDense: true, items: _parityList.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => onChanged(v ?? 'None')); })),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _testDisplay, icon: const Icon(Icons.check), label: const Text('Test VFD Display'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.appbarGreen, side: BorderSide(color: AppColors.appbarGreen), padding: EdgeInsets.symmetric(vertical: 12.h)))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, Widget dropdown) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)), SizedBox(width: 12.w), Expanded(child: dropdown)]);
  }
}

/// Cash Drawer Section
class _CashDrawerSection extends StatefulWidget {
  const _CashDrawerSection({Key? key}) : super(key: key);

  @override
  State<_CashDrawerSection> createState() => _CashDrawerSectionState();
}

class _CashDrawerSectionState extends State<_CashDrawerSection> {
  bool _erpnextEnabled = false;
  String _connectionType = 'printer';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    UserPreference.getInstance().then((_) {
      setState(() {
        _erpnextEnabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? _erpnextEnabled;
        _connectionType = UserPreference.getString(PrefKeys.cashDrawerConnectionType) ?? _connectionType;
      });
    });
  }

  void _testDrawer() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening cash drawer...')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.point_of_sale, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Cash Drawer', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_erpnextEnabled ? 'Enabled - ${_connectionType == "printer" ? "Via Printer (RJ11)" : "Direct USB"}' : 'Disabled in ERPNext', style: TextStyle(fontSize: 14.sp, color: _erpnextEnabled ? Colors.grey.shade600 : Colors.red.shade400)),
          children: [
            Container(padding: EdgeInsets.all(12.w), decoration: BoxDecoration(color: _erpnextEnabled ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: _erpnextEnabled ? Colors.green.shade300 : Colors.red.shade300)), child: Row(children: [Icon(_erpnextEnabled ? Icons.check_circle : Icons.cancel, color: _erpnextEnabled ? Colors.green : Colors.red, size: 24.sp), SizedBox(width: 12.w), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ERPNext POS Profile Setting', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: _erpnextEnabled ? Colors.green.shade700 : Colors.red.shade700)), SizedBox(height: 4.h), Text(_erpnextEnabled ? 'Cash drawer is enabled. Opens automatically after payment.' : 'Cash drawer is disabled. Enable in POS Profile > Settings > Open Cash Drawer.', style: TextStyle(fontSize: 13.sp, color: _erpnextEnabled ? Colors.green.shade600 : Colors.red.shade600))]))),
            if (_erpnextEnabled) ...[
              SizedBox(height: 12.h),
              Container(padding: EdgeInsets.all(12.w), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.blue.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.cable, color: Colors.blue, size: 18.sp), SizedBox(width: 8.w), Text('Connection Method', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.blue.shade700))]), SizedBox(height: 12.h), Container(decoration: BoxDecoration(color: _connectionType == 'printer' ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(6.r), border: Border.all(color: _connectionType == 'printer' ? AppColors.appbarGreen : Colors.transparent, width: 2)), child: RadioListTile<String>(value: 'printer', groupValue: _connectionType, onChanged: (value) async { if (value == null) return; setState(() => _connectionType = value); await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.cashDrawerConnectionType, value); }, title: Row(children: [Text('Via Printer (RJ11)', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)), SizedBox(width: 8.w), Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h), decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4.r)), child: Text('Recommended', style: TextStyle(fontSize: 11.sp, color: Colors.green.shade700, fontWeight: FontWeight.bold)))]), subtitle: Text('Standard retail setup. Drawer connected to printer via RJ11 cable.', style: TextStyle(fontSize: 12.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 8.w)))), SizedBox(height: 8.h), Container(decoration: BoxDecoration(color: _connectionType == 'direct' ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(6.r), border: Border.all(color: _connectionType == 'direct' ? AppColors.appbarGreen : Colors.transparent, width: 2)), child: RadioListTile<String>(value: 'direct', groupValue: _connectionType, onChanged: (value) async { if (value == null) return; setState(() => _connectionType = value); await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.cashDrawerConnectionType, value); }, title: Text('Direct USB', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)), subtitle: Text('Legacy setup. Drawer connected directly via USB-Serial adapter.', style: TextStyle(fontSize: 12.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 8.w)))),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _testDrawer, icon: const Icon(Icons.open_in_new), label: const Text('Test Cash Drawer'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 12.h)))),
            ],
          ],
        ),
      ),
    );
  }
}

/// Backup Settings Section
class _BackupSettingsSection extends StatefulWidget {
  const _BackupSettingsSection({Key? key}) : super(key: key);

  @override
  State<_BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<_BackupSettingsSection> {
  bool _enabled = false;
  int _runsPerDay = 1;
  TimeOfDay _firstTime = const TimeOfDay(hour: 2, minute: 0);
  int _retentionDays = 3;
  String _backupFolder = r'C:\PosX\\mariadb\\backups';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    final saved = await BackupScheduler.getSavedBackupSettings();
    final times = (saved['times'] as List).cast<String>();
    if (times.isNotEmpty) {
      final parts = times[0].split(':');
      final h = int.tryParse(parts[0]) ?? 2;
      final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
      setState(() => _firstTime = TimeOfDay(hour: h, minute: m));
      setState(() => _enabled = true);
    }
    final retention = saved['retention'] as int? ?? 3;
    setState(() => _retentionDays = retention);
    final folder = UserPreference.getString('backup_folder') ?? r'C:\PosX\\mariadb\\backups';
    setState(() => _backupFolder = folder);
    final runs = UserPreference.getInt('backup_runs_per_day') ?? 1;
    setState(() => _runsPerDay = runs);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _firstTime);
    if (t != null) setState(() => _firstTime = t);
  }

  Future<void> _pickFolder() async {
    if (Platform.isWindows) {
      try {
        final ps = r"Add-Type -AssemblyName System.Windows.Forms; $d = New-Object System.Windows.Forms.FolderBrowserDialog; $d.ShowNewFolderButton = $true; if($d.ShowDialog() -eq 'OK'){ Write-Output $d.SelectedPath }";
        final result = await Process.run('powershell', ['-NoProfile', '-Command', ps], runInShell: true);
        final out = (result.stdout ?? '').toString().trim();
        if (out.isNotEmpty) {
          setState(() => _backupFolder = out);
          return;
        }
      } catch (_) {}
    }

    final controller = TextEditingController(text: _backupFolder);
    final val = await showDialog<String?>(context: context, builder: (ctx) {
      return AlertDialog(title: const Text('Backup folder'), content: TextField(controller: controller, decoration: const InputDecoration(hintText: r'C:\PosX\\mariadb\\backups')), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('OK'))]);
    });

    if (val != null && val.trim().isNotEmpty) setState(() => _backupFolder = val.trim());
  }

  String _timeToStr(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putBool('backup_enabled', _enabled);
      await UserPreference.putInt('backup_runs_per_day', _runsPerDay);
      await UserPreference.putInt('backup_retention_days', _retentionDays);
      await UserPreference.putString('backup_folder', _backupFolder);

      final dir = Directory(_backupFolder);
      if (!await dir.exists()) await dir.create(recursive: true);

      final credsPath = r'C:\PosX\\mariadb\\creds.json';
      await BackupCredentialWriter.writeCredsFile(credsPath);

      final times = <String>[_timeToStr(_firstTime)];
      if (_runsPerDay == 2) {
        final secondHour = (_firstTime.hour + 12) % 24;
        final second = TimeOfDay(hour: secondHour, minute: _firstTime.minute);
        times.add(_timeToStr(second));
      }

      final scheduledOk = await BackupScheduler.createOrUpdateTasks(times: times, retentionDays: _retentionDays, scriptPath: r'C:\PosX\\mariadb\\backup_mariadb.ps1', runAsSystem: true);

      if (!scheduledOk) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup saved, but scheduling failed. Run the app as administrator or create the scheduled task manually.'), backgroundColor: Colors.orange));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving backup settings: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _backupNow() async {
    setState(() => _isSaving = true);
    try {
      final script = r'C:\PosX\\mariadb\\backup_mariadb.ps1';
      final result = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script], runInShell: true);
      if (result.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${result.stderr ?? result.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.folder, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Backups', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_enabled ? 'Enabled' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _enabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            SwitchListTile(value: _enabled, onChanged: (v) => setState(() => _enabled = v), title: Text('Enable automatic backups', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)), activeColor: AppColors.appbarGreen),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('Runs per day', style: TextStyle(fontSize: 15.sp))), DropdownButton<int>(value: _runsPerDay, items: [1, 2].map((e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(), onChanged: (v) => setState(() => _runsPerDay = v ?? 1))]),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('First run time', style: TextStyle(fontSize: 15.sp))), TextButton(onPressed: _pickTime, child: Text(_timeToStr(_firstTime)))]),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('Retention (days)', style: TextStyle(fontSize: 15.sp))), DropdownButton<int>(value: _retentionDays, items: [3, 4, 5].map((d) => DropdownMenuItem<int>(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retentionDays = v ?? 3))]),
            SizedBox(height: 8.h),
            Text('Backup folder', style: TextStyle(fontSize: 15.sp)),
            SizedBox(height: 6.h),
            Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)), padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h), child: Row(children: [Expanded(child: Text(_backupFolder)), TextButton(onPressed: _pickFolder, child: const Text('Change'))])),
            SizedBox(height: 12.h),
            Row(children: [Expanded(child: ElevatedButton(onPressed: _isSaving ? null : _save, style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen), child: _isSaving ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Save'))), SizedBox(width: 12.w), SizedBox(width: 140.w, child: OutlinedButton(onPressed: _isSaving ? null : _backupNow, child: const Text('Backup Now')))]),
          ],
        ),
      ),
    );
  }
}




/// Receipt Printer Section
class _ReceiptPrinterSection extends StatefulWidget {
  const _ReceiptPrinterSection({Key? key}) : super(key: key);

  @override
  State<_ReceiptPrinterSection> createState() => _ReceiptPrinterSectionState();
}

class _ReceiptPrinterSectionState extends State<_ReceiptPrinterSection> {
  List<String> _availablePrinters = [];
  String? _selectedPrinter;
  bool _isScanning = false;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await UserPreference.getInstance();
    setState(() {
      _selectedPrinter = UserPreference.getString(PrefKeys.receiptPrinterUrl);
      _phoneController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? '';
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _scanPrinters() async {
    setState(() => _isScanning = true);
    await Future.delayed(const Duration(milliseconds: 400));
    setState(() => _availablePrinters = ['Default Printer', 'Epson TM-T20', 'Star TSP143']);
    setState(() => _isScanning = false);
  }

  void _testPrint() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test print sent')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.print, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Receipt Printer', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_selectedPrinter ?? 'No printer configured', style: TextStyle(fontSize: 14.sp, color: _selectedPrinter != null ? Colors.grey.shade600 : Colors.red.shade400)),
          children: [
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _isScanning ? null : _scanPrinters, icon: _isScanning ? SizedBox(width: 16.w, height: 16.h, child: const CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.search), label: Text(_isScanning ? 'Scanning...' : 'Scan for Printers'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 12.h)))),
            SizedBox(height: 16.h),
            if (_availablePrinters.isNotEmpty) ...[
              AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) {
                return Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)), padding: EdgeInsets.symmetric(horizontal: 12.w), child: DropdownButton<String>(isExpanded: true, underline: const SizedBox.shrink(), value: val, hint: Row(children: [Icon(Icons.print, size: 20.sp, color: Colors.grey), SizedBox(width: 8.w), const Text('Select a printer')]), items: _availablePrinters.map((printer) => DropdownMenuItem(value: printer, child: Text(printer))).toList(), onChanged: (value) { onChanged(value); setState(() => _selectedPrinter = value); }));
              }),
              SizedBox(height: 16.h),
            ],
            AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) {
              return Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: Text('Silent Print', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)), subtitle: Text('Print without showing OS dialog', style: TextStyle(fontSize: 13.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 12.w)));
            }),
            SizedBox(height: 12.h),
            AutoPersist<bool>(prefKey: PrefKeys.autoPrintReceipt, defaultValue: false, builder: (ctx, val, onChanged) {
              return Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: Text('Auto-Print on Payment', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)), subtitle: Text('Automatically print receipt after payment', style: TextStyle(fontSize: 13.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 12.w)));
            }),
            SizedBox(height: 16.h),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Phone Number', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade800)), SizedBox(height: 8.h), Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: TextField(controller: _phoneController, decoration: InputDecoration(hintText: 'Enter phone number for receipts', prefixIcon: Icon(Icons.phone, color: AppColors.appbarGreen), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h)), keyboardType: TextInputType.phone, onChanged: (value) async { await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.receiptPhoneNumber, value); })),]),
            SizedBox(height: 16.h),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Receipt Footer', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.grey.shade800)), SizedBox(height: 8.h), Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: AutoPersist<String>(prefKey: PrefKeys.receiptFooterText, defaultValue: '', builder: (ctx, val, onChanged) { final controller = TextEditingController(text: val); controller.addListener(() => onChanged(controller.text)); return TextField(controller: controller, decoration: InputDecoration(hintText: 'Enter custom footer text (e.g., "Thank you for your business!")', prefixIcon: Icon(Icons.notes, color: AppColors.appbarGreen), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h), counterText: ''), maxLines: 3, minLines: 2, maxLength: 200); }))),
            SizedBox(height: 16.h),
            SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _selectedPrinter != null ? _testPrint : null, icon: const Icon(Icons.check), label: const Text('Test Print (Barcode + QR)'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.appbarGreen, side: BorderSide(color: AppColors.appbarGreen), padding: EdgeInsets.symmetric(vertical: 12.h)))),
          ],
        ),
      ),
    );
  }
}

/// VFD Display Section
class _VFDDisplaySection extends StatefulWidget {
  const _VFDDisplaySection({Key? key}) : super(key: key);

  @override
  State<_VFDDisplaySection> createState() => _VFDDisplaySectionState();
}

class _VFDDisplaySectionState extends State<_VFDDisplaySection> {
  bool _vfdEnabled = false;
  String _comPort = 'COM1';
  int _baudRate = 9600;
  int _dataBits = 8;
  int _stopBits = 1;
  String _parity = 'None';

  final List<String> _comPorts = ['COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8'];
  final List<int> _baudRates = [2400, 4800, 9600, 19200, 38400, 57600, 115200];
  final List<int> _dataBitsList = [7, 8];
  final List<int> _stopBitsList = [1, 2];
  final List<String> _parityList = ['None', 'Even', 'Odd', 'Mark', 'Space'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    UserPreference.getInstance().then((_) {
      setState(() {
        _vfdEnabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? _vfdEnabled;
        _comPort = UserPreference.getString(PrefKeys.vfdComPort) ?? _comPort;
        _baudRate = UserPreference.getInt(PrefKeys.vfdBaudRate) ?? _baudRate;
        _dataBits = UserPreference.getInt(PrefKeys.vfdDataBits) ?? _dataBits;
        _stopBits = UserPreference.getInt(PrefKeys.vfdStopBits) ?? _stopBits;
        _parity = UserPreference.getString(PrefKeys.vfdParity) ?? _parity;
      });
    });
  }

  void _testDisplay() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test message sent to VFD')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.computer, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('VFD Customer Display', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_vfdEnabled ? 'Enabled on $_comPort' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _vfdEnabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: SwitchListTile(value: _vfdEnabled, onChanged: (v) async { setState(() => _vfdEnabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.vfdEnabled, v); }, title: Text('Enable VFD Display', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)), subtitle: Text('2x20 character display', style: TextStyle(fontSize: 13.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 12.w))),
            if (_vfdEnabled) ...[
              SizedBox(height: 12.h),
              _buildConfigRow('COM Port', AutoPersist<String>(prefKey: PrefKeys.vfdComPort, defaultValue: 'COM1', builder: (ctx, val, onChanged) { return DropdownButton<String>(value: val, isDense: true, items: _comPorts.map((port) => DropdownMenuItem(value: port, child: Text(port))).toList(), onChanged: (v) => onChanged(v ?? 'COM1')); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Baud Rate', AutoPersist<int>(prefKey: PrefKeys.vfdBaudRate, defaultValue: 9600, builder: (ctx, val, onChanged) { return DropdownButton<int>(value: val, isDense: true, items: _baudRates.map((rate) => DropdownMenuItem(value: rate, child: Text('$rate'))).toList(), onChanged: (v) => onChanged(v ?? 9600)); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Data Bits', AutoPersist<int>(prefKey: PrefKeys.vfdDataBits, defaultValue: 8, builder: (ctx, val, onChanged) { return DropdownButton<int>(value: val, isDense: true, items: _dataBitsList.map((bits) => DropdownMenuItem(value: bits, child: Text('$bits'))).toList(), onChanged: (v) => onChanged(v ?? 8)); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Stop Bits', AutoPersist<int>(prefKey: PrefKeys.vfdStopBits, defaultValue: 1, builder: (ctx, val, onChanged) { return DropdownButton<int>(value: val, isDense: true, items: _stopBitsList.map((bits) => DropdownMenuItem(value: bits, child: Text('$bits'))).toList(), onChanged: (v) => onChanged(v ?? 1)); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Parity', AutoPersist<String>(prefKey: PrefKeys.vfdParity, defaultValue: 'None', builder: (ctx, val, onChanged) { return DropdownButton<String>(value: val, isDense: true, items: _parityList.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => onChanged(v ?? 'None')); })),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _testDisplay, icon: const Icon(Icons.check), label: const Text('Test VFD Display'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.appbarGreen, side: BorderSide(color: AppColors.appbarGreen), padding: EdgeInsets.symmetric(vertical: 12.h)))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, Widget dropdown) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)), dropdown]);
  }
}

/// Cash Drawer Section
class _CashDrawerSection extends StatefulWidget {
  const _CashDrawerSection({Key? key}) : super(key: key);

  @override
  State<_CashDrawerSection> createState() => _CashDrawerSectionState();
}

class _CashDrawerSectionState extends State<_CashDrawerSection> {
  bool _erpnextEnabled = false;
  String _connectionType = 'printer';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    UserPreference.getInstance().then((_) {
      setState(() {
        _erpnextEnabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? _erpnextEnabled;
        _connectionType = UserPreference.getString(PrefKeys.cashDrawerConnectionType) ?? _connectionType;
      });
    });
  }

  void _testDrawer() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening cash drawer...')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.point_of_sale, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Cash Drawer', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_erpnextEnabled ? 'Enabled - ${_connectionType == "printer" ? "Via Printer (RJ11)" : "Direct USB"}' : 'Disabled in ERPNext', style: TextStyle(fontSize: 14.sp, color: _erpnextEnabled ? Colors.grey.shade600 : Colors.red.shade400)),
          children: [
            Container(padding: EdgeInsets.all(12.w), decoration: BoxDecoration(color: _erpnextEnabled ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: _erpnextEnabled ? Colors.green.shade300 : Colors.red.shade300)), child: Row(children: [Icon(_erpnextEnabled ? Icons.check_circle : Icons.cancel, color: _erpnextEnabled ? Colors.green : Colors.red, size: 24.sp), SizedBox(width: 12.w), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ERPNext POS Profile Setting', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: _erpnextEnabled ? Colors.green.shade700 : Colors.red.shade700)), SizedBox(height: 4.h), Text(_erpnextEnabled ? 'Cash drawer is enabled. Opens automatically after payment.' : 'Cash drawer is disabled. Enable in POS Profile > Settings > Open Cash Drawer.', style: TextStyle(fontSize: 13.sp, color: _erpnextEnabled ? Colors.green.shade600 : Colors.red.shade600))]))),
            if (_erpnextEnabled) ...[
              SizedBox(height: 12.h),
              Container(padding: EdgeInsets.all(12.w), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.blue.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.cable, color: Colors.blue, size: 18.sp), SizedBox(width: 8.w), Text('Connection Method', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.blue.shade700))]), SizedBox(height: 12.h), Container(decoration: BoxDecoration(color: _connectionType == 'printer' ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(6.r), border: Border.all(color: _connectionType == 'printer' ? AppColors.appbarGreen : Colors.transparent, width: 2)), child: RadioListTile<String>(value: 'printer', groupValue: _connectionType, onChanged: (value) async { if (value == null) return; setState(() => _connectionType = value); await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.cashDrawerConnectionType, value); }, title: Row(children: [Text('Via Printer (RJ11)', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)), SizedBox(width: 8.w), Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h), decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4.r)), child: Text('Recommended', style: TextStyle(fontSize: 11.sp, color: Colors.green.shade700, fontWeight: FontWeight.bold)))]), subtitle: Text('Standard retail setup. Drawer connected to printer via RJ11 cable.', style: TextStyle(fontSize: 12.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 8.w)))), SizedBox(height: 8.h), Container(decoration: BoxDecoration(color: _connectionType == 'direct' ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(6.r), border: Border.all(color: _connectionType == 'direct' ? AppColors.appbarGreen : Colors.transparent, width: 2)), child: RadioListTile<String>(value: 'direct', groupValue: _connectionType, onChanged: (value) async { if (value == null) return; setState(() => _connectionType = value); await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.cashDrawerConnectionType, value); }, title: Text('Direct USB', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)), subtitle: Text('Legacy setup. Drawer connected directly via USB-Serial adapter.', style: TextStyle(fontSize: 12.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 8.w)))),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _testDrawer, icon: const Icon(Icons.open_in_new), label: const Text('Test Cash Drawer'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 12.h)))),
              SizedBox(height: 8.h),
              Container(padding: EdgeInsets.all(8.w), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6.r)), child: Row(children: [Icon(Icons.info_outline, size: 16.sp, color: Colors.grey.shade600), SizedBox(width: 8.w), Expanded(child: Text('Drawer opens automatically after successful payment when enabled.', style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600)))])),
            ],
          ],
        ),
      ),
    );
  }
}

/// Backup Settings Section
class _BackupSettingsSection extends StatefulWidget {
  const _BackupSettingsSection({Key? key}) : super(key: key);

  @override
  State<_BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<_BackupSettingsSection> {
  bool _enabled = false;
  int _runsPerDay = 1;
  TimeOfDay _firstTime = const TimeOfDay(hour: 2, minute: 0);
  int _retentionDays = 3;
  String _backupFolder = r'C:\PosX\mariadb\backups';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    final saved = await BackupScheduler.getSavedBackupSettings();
    final times = (saved['times'] as List).cast<String>();
    if (times.isNotEmpty) {
      final parts = times[0].split(':');
      final h = int.tryParse(parts[0]) ?? 2;
      final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
      setState(() => _firstTime = TimeOfDay(hour: h, minute: m));
      setState(() => _enabled = true);
    }
    final retention = saved['retention'] as int? ?? 3;
    setState(() => _retentionDays = retention);
    final folder = UserPreference.getString('backup_folder') ?? r'C:\PosX\mariadb\backups';
    setState(() => _backupFolder = folder);
    final runs = UserPreference.getInt('backup_runs_per_day') ?? 1;
    setState(() => _runsPerDay = runs);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _firstTime);
    if (t != null) setState(() => _firstTime = t);
  }

  Future<void> _pickFolder() async {
    if (Platform.isWindows) {
      try {
        final ps = r"Add-Type -AssemblyName System.Windows.Forms; $d = New-Object System.Windows.Forms.FolderBrowserDialog; $d.ShowNewFolderButton = $true; if($d.ShowDialog() -eq 'OK'){ Write-Output $d.SelectedPath }";
        final result = await Process.run('powershell', ['-NoProfile', '-Command', ps], runInShell: true);
        final out = (result.stdout ?? '').toString().trim();
        if (out.isNotEmpty) {
          setState(() => _backupFolder = out);
          return;
        }
      } catch (_) {}
    }

    final controller = TextEditingController(text: _backupFolder);
    final val = await showDialog<String?>(context: context, builder: (ctx) {
      return AlertDialog(title: const Text('Backup folder'), content: TextField(controller: controller, decoration: const InputDecoration(hintText: r'C:\PosX\mariadb\backups')), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('OK'))]);
    });

    if (val != null && val.trim().isNotEmpty) setState(() => _backupFolder = val.trim());
  }

  String _timeToStr(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putBool('backup_enabled', _enabled);
      await UserPreference.putInt('backup_runs_per_day', _runsPerDay);
      await UserPreference.putInt('backup_retention_days', _retentionDays);
      await UserPreference.putString('backup_folder', _backupFolder);

      final dir = Directory(_backupFolder);
      if (!await dir.exists()) await dir.create(recursive: true);

      final credsPath = r'C:\PosX\mariadb\creds.json';
      await BackupCredentialWriter.writeCredsFile(credsPath);

      final times = <String>[_timeToStr(_firstTime)];
      if (_runsPerDay == 2) {
        final secondHour = (_firstTime.hour + 12) % 24;
        final second = TimeOfDay(hour: secondHour, minute: _firstTime.minute);
        times.add(_timeToStr(second));
      }

      final scheduledOk = await BackupScheduler.createOrUpdateTasks(times: times, retentionDays: _retentionDays, scriptPath: r'C:\PosX\mariadb\backup_mariadb.ps1', runAsSystem: true);

      if (!scheduledOk) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup saved, but scheduling failed. Run the app as administrator or create the scheduled task manually.'), backgroundColor: Colors.orange));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving backup settings: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _backupNow() async {
    setState(() => _isSaving = true);
    try {
      final script = r'C:\PosX\mariadb\backup_mariadb.ps1';
      final result = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script], runInShell: true);
      if (result.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${result.stderr ?? result.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.folder, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Backups', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_enabled ? 'Enabled' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _enabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            SwitchListTile(value: _enabled, onChanged: (v) => setState(() => _enabled = v), title: Text('Enable automatic backups', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)), activeColor: AppColors.appbarGreen),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('Runs per day', style: TextStyle(fontSize: 15.sp))), DropdownButton<int>(value: _runsPerDay, items: [1, 2].map((e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(), onChanged: (v) => setState(() => _runsPerDay = v ?? 1))]),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('First run time', style: TextStyle(fontSize: 15.sp))), TextButton(onPressed: _pickTime, child: Text(_timeToStr(_firstTime)))]),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('Retention (days)', style: TextStyle(fontSize: 15.sp))), DropdownButton<int>(value: _retentionDays, items: [3, 4, 5].map((d) => DropdownMenuItem<int>(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retentionDays = v ?? 3))]),
            SizedBox(height: 8.h),
            Text('Backup folder', style: TextStyle(fontSize: 15.sp)),
            SizedBox(height: 6.h),
            Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)), padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h), child: Row(children: [Expanded(child: Text(_backupFolder)), TextButton(onPressed: _pickFolder, child: const Text('Change'))])),
            SizedBox(height: 12.h),
            Row(children: [Expanded(child: ElevatedButton(onPressed: _isSaving ? null : _save, style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen), child: _isSaving ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Save'))), SizedBox(width: 12.w), SizedBox(width: 140.w, child: OutlinedButton(onPressed: _isSaving ? null : _backupNow, child: const Text('Backup Now')))])
          ],
        ),
      ),
    );
  }
}


/// Backup Settings Section
class _BackupSettingsSection extends StatefulWidget {
  const _BackupSettingsSection();

  @override
  State<_BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<_BackupSettingsSection> {
  bool _enabled = false;
  int _runsPerDay = 1;
  TimeOfDay _firstTime = const TimeOfDay(hour: 2, minute: 0);
  int _retentionDays = 3;
  String _backupFolder = r'C:\PosX\mariadb\backups';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    final saved = await BackupScheduler.getSavedBackupSettings();
    final times = (saved['times'] as List).cast<String>();
    if (times.isNotEmpty) {
      final parts = times[0].split(':');
      final h = int.tryParse(parts[0]) ?? 2;
      final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
      setState(() => _firstTime = TimeOfDay(hour: h, minute: m));
      setState(() => _enabled = true);
    }
    final retention = saved['retention'] as int? ?? 3;
    setState(() => _retentionDays = retention);
    final folder = UserPreference.getString('backup_folder') ?? r'C:\PosX\mariadb\backups';
    setState(() => _backupFolder = folder);
    final runs = UserPreference.getInt('backup_runs_per_day') ?? 1;
    setState(() => _runsPerDay = runs);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _firstTime);
    if (t != null) setState(() => _firstTime = t);
  }

  Future<void> _pickFolder() async {
    if (Platform.isWindows) {
      try {
        final ps = r"Add-Type -AssemblyName System.Windows.Forms; $d = New-Object System.Windows.Forms.FolderBrowserDialog; $d.ShowNewFolderButton = $true; if($d.ShowDialog() -eq 'OK'){ Write-Output $d.SelectedPath }";
        final result = await Process.run('powershell', ['-NoProfile', '-Command', ps], runInShell: true);
        final out = (result.stdout ?? '').toString().trim();
        if (out.isNotEmpty) {
          setState(() => _backupFolder = out);
          return;
        }
      } catch (_) {}
    }

    final controller = TextEditingController(text: _backupFolder);
    final val = await showDialog<String?>(context: context, builder: (ctx) {
      return AlertDialog(title: const Text('Backup folder'), content: TextField(controller: controller, decoration: const InputDecoration(hintText: r'C:\PosX\mariadb\backups')), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('OK'))]);
    });

    if (val != null && val.trim().isNotEmpty) setState(() => _backupFolder = val.trim());
  }

  String _timeToStr(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putBool('backup_enabled', _enabled);
      await UserPreference.putInt('backup_runs_per_day', _runsPerDay);
      await UserPreference.putInt('backup_retention_days', _retentionDays);
      await UserPreference.putString('backup_folder', _backupFolder);

      final dir = Directory(_backupFolder);
      if (!await dir.exists()) await dir.create(recursive: true);

      final credsPath = r'C:\PosX\mariadb\creds.json';
      await BackupCredentialWriter.writeCredsFile(credsPath);

      final times = <String>[_timeToStr(_firstTime)];
      if (_runsPerDay == 2) {
        final secondHour = (_firstTime.hour + 12) % 24;
        final second = TimeOfDay(hour: secondHour, minute: _firstTime.minute);
        times.add(_timeToStr(second));
      }

      final scheduledOk = await BackupScheduler.createOrUpdateTasks(times: times, retentionDays: _retentionDays, scriptPath: r'C:\PosX\mariadb\backup_mariadb.ps1', runAsSystem: true);

      if (!scheduledOk) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup saved, but scheduling failed. Run the app as administrator or create the scheduled task manually.'), backgroundColor: Colors.orange));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving backup settings: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _backupNow() async {
    setState(() => _isSaving = true);
    try {
      final script = r'C:\PosX\mariadb\backup_mariadb.ps1';
      final result = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script], runInShell: true);
      if (result.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${result.stderr ?? result.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.folder, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Backups', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_enabled ? 'Enabled' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _enabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            SwitchListTile(value: _enabled, onChanged: (v) => setState(() => _enabled = v), title: Text('Enable automatic backups', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)), activeColor: AppColors.appbarGreen),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('Runs per day', style: TextStyle(fontSize: 15.sp))), DropdownButton<int>(value: _runsPerDay, items: [1, 2].map((e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(), onChanged: (v) => setState(() => _runsPerDay = v ?? 1))]),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('First run time', style: TextStyle(fontSize: 15.sp))), TextButton(onPressed: _pickTime, child: Text(_timeToStr(_firstTime)))]),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('Retention (days)', style: TextStyle(fontSize: 15.sp))), DropdownButton<int>(value: _retentionDays, items: [3, 4, 5].map((d) => DropdownMenuItem<int>(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retentionDays = v ?? 3))]),
            SizedBox(height: 8.h),
            Text('Backup folder', style: TextStyle(fontSize: 15.sp)), SizedBox(height: 6.h),
            Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)), padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h), child: Row(children: [Expanded(child: Text(_backupFolder)), TextButton(onPressed: _pickFolder, child: const Text('Change'))])),
            SizedBox(height: 12.h),
            Row(children: [Expanded(child: ElevatedButton(onPressed: _isSaving ? null : _save, style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen), child: _isSaving ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Save'))), SizedBox(width: 12.w), SizedBox(width: 140.w, child: OutlinedButton(onPressed: _isSaving ? null : _backupNow, child: const Text('Backup Now')))]),
          ],
        ),
      ),
    );
  }
}

/// VFD Display Configuration Section
class _VFDDisplaySection extends StatefulWidget {
  const _VFDDisplaySection();

  @override
  State<_VFDDisplaySection> createState() => _VFDDisplaySectionState();
}

class _VFDDisplaySectionState extends State<_VFDDisplaySection> {
  bool _vfdEnabled = false;
  String _comPort = 'COM1';
  int _baudRate = 9600;
  int _dataBits = 8;
  int _stopBits = 1;
  String _parity = 'None';

  final List<String> _comPorts = ['COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8'];
  final List<int> _baudRates = [2400, 4800, 9600, 19200, 38400, 57600, 115200];
  final List<int> _dataBitsList = [7, 8];
  final List<int> _stopBitsList = [1, 2];
  final List<String> _parityList = ['None', 'Even', 'Odd', 'Mark', 'Space'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    UserPreference.getInstance().then((_) {
      setState(() {
        _vfdEnabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? _vfdEnabled;
        _comPort = UserPreference.getString(PrefKeys.vfdComPort) ?? _comPort;
        _baudRate = UserPreference.getInt(PrefKeys.vfdBaudRate) ?? _baudRate;
        _dataBits = UserPreference.getInt(PrefKeys.vfdDataBits) ?? _dataBits;
        _stopBits = UserPreference.getInt(PrefKeys.vfdStopBits) ?? _stopBits;
        _parity = UserPreference.getString(PrefKeys.vfdParity) ?? _parity;
      });
    });
  }

  void _testDisplay() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test message sent to VFD')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.computer, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('VFD Customer Display', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_vfdEnabled ? 'Enabled on $_comPort' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _vfdEnabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: SwitchListTile(value: _vfdEnabled, onChanged: (v) async { setState(() => _vfdEnabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.vfdEnabled, v); }, title: Text('Enable VFD Display', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)), subtitle: Text('2x20 character display', style: TextStyle(fontSize: 13.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 12.w))),
            if (_vfdEnabled) ...[
              SizedBox(height: 12.h),
              _buildConfigRow('COM Port', AutoPersist<String>(prefKey: PrefKeys.vfdComPort, defaultValue: 'COM1', builder: (ctx, val, onChanged) { return DropdownButton<String>(value: val, isDense: true, items: _comPorts.map((port) => DropdownMenuItem(value: port, child: Text(port))).toList(), onChanged: (v) => onChanged(v ?? 'COM1')); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Baud Rate', AutoPersist<int>(prefKey: PrefKeys.vfdBaudRate, defaultValue: 9600, builder: (ctx, val, onChanged) { return DropdownButton<int>(value: val, isDense: true, items: _baudRates.map((rate) => DropdownMenuItem(value: rate, child: Text('$rate'))).toList(), onChanged: (v) => onChanged(v ?? 9600)); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Data Bits', AutoPersist<int>(prefKey: PrefKeys.vfdDataBits, defaultValue: 8, builder: (ctx, val, onChanged) { return DropdownButton<int>(value: val, isDense: true, items: _dataBitsList.map((bits) => DropdownMenuItem(value: bits, child: Text('$bits'))).toList(), onChanged: (v) => onChanged(v ?? 8)); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Stop Bits', AutoPersist<int>(prefKey: PrefKeys.vfdStopBits, defaultValue: 1, builder: (ctx, val, onChanged) { return DropdownButton<int>(value: val, isDense: true, items: _stopBitsList.map((bits) => DropdownMenuItem(value: bits, child: Text('$bits'))).toList(), onChanged: (v) => onChanged(v ?? 1)); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Parity', AutoPersist<String>(prefKey: PrefKeys.vfdParity, defaultValue: 'None', builder: (ctx, val, onChanged) { return DropdownButton<String>(value: val, isDense: true, items: _parityList.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => onChanged(v ?? 'None')); })),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _testDisplay, icon: const Icon(Icons.check), label: const Text('Test VFD Display'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.appbarGreen, side: BorderSide(color: AppColors.appbarGreen), padding: EdgeInsets.symmetric(vertical: 12.h)))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, Widget dropdown) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)), dropdown]);
  }
}

/// Cash Drawer Configuration Section
class _CashDrawerSection extends StatefulWidget {
  const _CashDrawerSection();

  @override
  State<_CashDrawerSection> createState() => _CashDrawerSectionState();
}

class _CashDrawerSectionState extends State<_CashDrawerSection> {
  bool _erpnextEnabled = false;
  String _connectionType = 'printer';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    UserPreference.getInstance().then((_) {
      setState(() {
        _erpnextEnabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? _erpnextEnabled;
        _connectionType = UserPreference.getString(PrefKeys.cashDrawerConnectionType) ?? _connectionType;
      });
    });
  }

  void _testDrawer() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening cash drawer...')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.point_of_sale, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Cash Drawer', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_erpnextEnabled ? 'Enabled - ${_connectionType == "printer" ? "Via Printer (RJ11)" : "Direct USB"}' : 'Disabled in ERPNext', style: TextStyle(fontSize: 14.sp, color: _erpnextEnabled ? Colors.grey.shade600 : Colors.red.shade400)),
          children: [
            Container(padding: EdgeInsets.all(12.w), decoration: BoxDecoration(color: _erpnextEnabled ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: _erpnextEnabled ? Colors.green.shade300 : Colors.red.shade300)), child: Row(children: [Icon(_erpnextEnabled ? Icons.check_circle : Icons.cancel, color: _erpnextEnabled ? Colors.green : Colors.red, size: 24.sp), SizedBox(width: 12.w), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ERPNext POS Profile Setting', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: _erpnextEnabled ? Colors.green.shade700 : Colors.red.shade700)), SizedBox(height: 4.h), Text(_erpnextEnabled ? 'Cash drawer is enabled. Opens automatically after payment.' : 'Cash drawer is disabled. Enable in POS Profile > Settings > Open Cash Drawer.', style: TextStyle(fontSize: 13.sp, color: _erpnextEnabled ? Colors.green.shade600 : Colors.red.shade600))]))),
            if (_erpnextEnabled) ...[
              SizedBox(height: 12.h),
              Container(padding: EdgeInsets.all(12.w), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.blue.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.cable, color: Colors.blue, size: 18.sp), SizedBox(width: 8.w), Text('Connection Method', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.blue.shade700))]), SizedBox(height: 12.h), Container(decoration: BoxDecoration(color: _connectionType == 'printer' ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(6.r), border: Border.all(color: _connectionType == 'printer' ? AppColors.appbarGreen : Colors.transparent, width: 2)), child: RadioListTile<String>(value: 'printer', groupValue: _connectionType, onChanged: (value) async { if (value == null) return; setState(() => _connectionType = value); await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.cashDrawerConnectionType, value); }, title: Row(children: [Text('Via Printer (RJ11)', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)), SizedBox(width: 8.w), Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h), decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4.r)), child: Text('Recommended', style: TextStyle(fontSize: 11.sp, color: Colors.green.shade700, fontWeight: FontWeight.bold)))]), subtitle: Text('Standard retail setup. Drawer connected to printer via RJ11 cable.', style: TextStyle(fontSize: 12.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 8.w)))), SizedBox(height: 8.h), Container(decoration: BoxDecoration(color: _connectionType == 'direct' ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(6.r), border: Border.all(color: _connectionType == 'direct' ? AppColors.appbarGreen : Colors.transparent, width: 2)), child: RadioListTile<String>(value: 'direct', groupValue: _connectionType, onChanged: (value) async { if (value == null) return; setState(() => _connectionType = value); await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.cashDrawerConnectionType, value); }, title: Text('Direct USB', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)), subtitle: Text('Legacy setup. Drawer connected directly via USB-Serial adapter.', style: TextStyle(fontSize: 12.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 8.w)))),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _testDrawer, icon: const Icon(Icons.open_in_new), label: const Text('Test Cash Drawer'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 12.h)))),
            ],
          ],
        ),
      ),
    );
  }
}

/// Backup Settings Section
class _BackupSettingsSection extends StatefulWidget {
  const _BackupSettingsSection();

  @override
  State<_BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<_BackupSettingsSection> {
  bool _enabled = false;
  int _runsPerDay = 1;
  TimeOfDay _firstTime = const TimeOfDay(hour: 2, minute: 0);
  int _retentionDays = 3;
  String _backupFolder = r'C:\PosX\mariadb\backups';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    final saved = await BackupScheduler.getSavedBackupSettings();
    final times = (saved['times'] as List).cast<String>();
    if (times.isNotEmpty) {
      final parts = times[0].split(':');
      final h = int.tryParse(parts[0]) ?? 2;
      final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
      setState(() => _firstTime = TimeOfDay(hour: h, minute: m));
      setState(() => _enabled = true);
    }
    final retention = saved['retention'] as int? ?? 3;
    setState(() => _retentionDays = retention);
    final folder = UserPreference.getString('backup_folder') ?? r'C:\PosX\mariadb\backups';
    setState(() => _backupFolder = folder);
    final runs = UserPreference.getInt('backup_runs_per_day') ?? 1;
    setState(() => _runsPerDay = runs);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _firstTime);
    if (t != null) setState(() => _firstTime = t);
  }

  Future<void> _pickFolder() async {
    if (Platform.isWindows) {
      try {
        final ps = r"Add-Type -AssemblyName System.Windows.Forms; $d = New-Object System.Windows.Forms.FolderBrowserDialog; $d.ShowNewFolderButton = $true; if($d.ShowDialog() -eq 'OK'){ Write-Output $d.SelectedPath }";
        final result = await Process.run('powershell', ['-NoProfile', '-Command', ps], runInShell: true);
        final out = (result.stdout ?? '').toString().trim();
        if (out.isNotEmpty) {
          setState(() => _backupFolder = out);
          return;
        }
      } catch (_) {}
    }

    final controller = TextEditingController(text: _backupFolder);
    final val = await showDialog<String?>(context: context, builder: (ctx) {
      return AlertDialog(title: const Text('Backup folder'), content: TextField(controller: controller, decoration: const InputDecoration(hintText: r'C:\PosX\mariadb\backups')), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('OK'))]);
    });

    if (val != null && val.trim().isNotEmpty) setState(() => _backupFolder = val.trim());
  }

  String _timeToStr(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putBool('backup_enabled', _enabled);
      await UserPreference.putInt('backup_runs_per_day', _runsPerDay);
      await UserPreference.putInt('backup_retention_days', _retentionDays);
      await UserPreference.putString('backup_folder', _backupFolder);

      final dir = Directory(_backupFolder);
      if (!await dir.exists()) await dir.create(recursive: true);

      final credsPath = r'C:\PosX\mariadb\creds.json';
      await BackupCredentialWriter.writeCredsFile(credsPath);

      final times = <String>[_timeToStr(_firstTime)];
      if (_runsPerDay == 2) {
        final secondHour = (_firstTime.hour + 12) % 24;
        final second = TimeOfDay(hour: secondHour, minute: _firstTime.minute);
        times.add(_timeToStr(second));
      }

      final scheduledOk = await BackupScheduler.createOrUpdateTasks(times: times, retentionDays: _retentionDays, scriptPath: r'C:\PosX\mariadb\backup_mariadb.ps1', runAsSystem: true);

      if (!scheduledOk) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup saved, but scheduling failed. Run the app as administrator or create the scheduled task manually.'), backgroundColor: Colors.orange));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving backup settings: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _backupNow() async {
    setState(() => _isSaving = true);
    try {
      final script = r'C:\PosX\mariadb\backup_mariadb.ps1';
      final result = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script], runInShell: true);
      if (result.exitCode == 0) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${result.stderr ?? result.stdout}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.folder, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Backups', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_enabled ? 'Enabled' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _enabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            SwitchListTile(value: _enabled, onChanged: (v) => setState(() => _enabled = v), title: Text('Enable automatic backups', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)), activeColor: AppColors.appbarGreen),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('Runs per day', style: TextStyle(fontSize: 15.sp))), DropdownButton<int>(value: _runsPerDay, items: [1, 2].map((e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(), onChanged: (v) => setState(() => _runsPerDay = v ?? 1))]),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('First run time', style: TextStyle(fontSize: 15.sp))), TextButton(onPressed: _pickTime, child: Text(_timeToStr(_firstTime)))]),
            SizedBox(height: 8.h),
            Row(children: [Expanded(child: Text('Retention (days)', style: TextStyle(fontSize: 15.sp))), DropdownButton<int>(value: _retentionDays, items: [3, 4, 5].map((d) => DropdownMenuItem<int>(value: d, child: Text('$d'))).toList(), onChanged: (v) => setState(() => _retentionDays = v ?? 3))]),
            SizedBox(height: 8.h),
            Text('Backup folder', style: TextStyle(fontSize: 15.sp)), SizedBox(height: 6.h),
            Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)), padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h), child: Row(children: [Expanded(child: Text(_backupFolder)), TextButton(onPressed: _pickFolder, child: const Text('Change'))])),
            SizedBox(height: 12.h),
            Row(children: [Expanded(child: ElevatedButton(onPressed: _isSaving ? null : _save, style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen), child: _isSaving ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Save'))), SizedBox(width: 12.w), SizedBox(width: 140.w, child: OutlinedButton(onPressed: _isSaving ? null : _backupNow, child: const Text('Backup Now')))]),
          ],
        ),
      ),
    );
  }
}

/// VFD Display Configuration Section
class _VFDDisplaySection extends StatefulWidget {
  const _VFDDisplaySection();

  @override
  State<_VFDDisplaySection> createState() => _VFDDisplaySectionState();
}

class _VFDDisplaySectionState extends State<_VFDDisplaySection> {
  bool _vfdEnabled = false;
  String _comPort = 'COM1';
  int _baudRate = 9600;
  int _dataBits = 8;
  int _stopBits = 1;
  String _parity = 'None';

  final List<String> _comPorts = ['COM1', 'COM2', 'COM3', 'COM4'];
  final List<int> _baudRates = [2400, 4800, 9600, 19200];
  final List<int> _dataBitsList = [7, 8];
  final List<int> _stopBitsList = [1, 2];
  final List<String> _parityList = ['None', 'Even', 'Odd'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    UserPreference.getInstance().then((_) {
      setState(() {
        _vfdEnabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? _vfdEnabled;
        _comPort = UserPreference.getString(PrefKeys.vfdComPort) ?? _comPort;
        _baudRate = UserPreference.getInt(PrefKeys.vfdBaudRate) ?? _baudRate;
        _dataBits = UserPreference.getInt(PrefKeys.vfdDataBits) ?? _dataBits;
        _stopBits = UserPreference.getInt(PrefKeys.vfdStopBits) ?? _stopBits;
        _parity = UserPreference.getString(PrefKeys.vfdParity) ?? _parity;
      });
    });
  }

  void _testDisplay() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test message sent to VFD')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.computer, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('VFD Customer Display', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_vfdEnabled ? 'Enabled on $_comPort' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _vfdEnabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            Container(decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.grey.shade300)), child: SwitchListTile(value: _vfdEnabled, onChanged: (v) async { setState(() => _vfdEnabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.vfdEnabled, v); }, title: Text('Enable VFD Display', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)), subtitle: Text('2x20 character display', style: TextStyle(fontSize: 13.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 12.w))),
            if (_vfdEnabled) ...[
              SizedBox(height: 12.h),
              _buildConfigRow('COM Port', DropdownButton<String>(value: _comPort, items: _comPorts.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) async { if (v == null) return; setState(() => _comPort = v); await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.vfdComPort, v); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Baud Rate', DropdownButton<int>(value: _baudRate, items: _baudRates.map((r) => DropdownMenuItem(value: r, child: Text('$r'))).toList(), onChanged: (v) async { if (v == null) return; setState(() => _baudRate = v); await UserPreference.getInstance(); await UserPreference.putInt(PrefKeys.vfdBaudRate, v); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Data Bits', DropdownButton<int>(value: _dataBits, items: _dataBitsList.map((b) => DropdownMenuItem(value: b, child: Text('$b'))).toList(), onChanged: (v) async { if (v == null) return; setState(() => _dataBits = v); await UserPreference.getInstance(); await UserPreference.putInt(PrefKeys.vfdDataBits, v); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Stop Bits', DropdownButton<int>(value: _stopBits, items: _stopBitsList.map((b) => DropdownMenuItem(value: b, child: Text('$b'))).toList(), onChanged: (v) async { if (v == null) return; setState(() => _stopBits = v); await UserPreference.getInstance(); await UserPreference.putInt(PrefKeys.vfdStopBits, v); })),
              SizedBox(height: 8.h),
              _buildConfigRow('Parity', DropdownButton<String>(value: _parity, items: _parityList.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) async { if (v == null) return; setState(() => _parity = v); await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.vfdParity, v); })),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _testDisplay, icon: const Icon(Icons.check), label: const Text('Test VFD Display'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.appbarGreen, side: BorderSide(color: AppColors.appbarGreen), padding: EdgeInsets.symmetric(vertical: 12.h)))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, Widget dropdown) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)), dropdown]);
  }
}

/// Cash Drawer Configuration Section
class _CashDrawerSection extends StatefulWidget {
  const _CashDrawerSection();

  @override
  State<_CashDrawerSection> createState() => _CashDrawerSectionState();
}

class _CashDrawerSectionState extends State<_CashDrawerSection> {
  bool _erpnextEnabled = false;
  String _connectionType = 'printer';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    UserPreference.getInstance().then((_) {
      setState(() {
        _erpnextEnabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? _erpnextEnabled;
        _connectionType = UserPreference.getString(PrefKeys.cashDrawerConnectionType) ?? _connectionType;
      });
    });
  }

  void _testDrawer() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Opening cash drawer...')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.point_of_sale, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Cash Drawer', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_erpnextEnabled ? 'Enabled - ${_connectionType == "printer" ? "Via Printer (RJ11)" : "Direct USB"}' : 'Disabled in ERPNext', style: TextStyle(fontSize: 14.sp, color: _erpnextEnabled ? Colors.grey.shade600 : Colors.red.shade400)),
          children: [
            Container(padding: EdgeInsets.all(12.w), decoration: BoxDecoration(color: _erpnextEnabled ? Colors.green.shade50 : Colors.red.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: _erpnextEnabled ? Colors.green.shade300 : Colors.red.shade300)), child: Row(children: [Icon(_erpnextEnabled ? Icons.check_circle : Icons.cancel, color: _erpnextEnabled ? Colors.green : Colors.red, size: 24.sp), SizedBox(width: 12.w), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ERPNext POS Profile Setting', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: _erpnextEnabled ? Colors.green.shade700 : Colors.red.shade700)), SizedBox(height: 4.h), Text(_erpnextEnabled ? 'Cash drawer is enabled. Opens automatically after payment.' : 'Cash drawer is disabled. Enable in POS Profile > Settings > Open Cash Drawer.', style: TextStyle(fontSize: 13.sp, color: _erpnextEnabled ? Colors.green.shade600 : Colors.red.shade600))]))),
            if (_erpnextEnabled) ...[
              SizedBox(height: 12.h),
              Container(padding: EdgeInsets.all(12.w), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.blue.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(Icons.cable, color: Colors.blue, size: 18.sp), SizedBox(width: 8.w), Text('Connection Method', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.blue.shade700))]), SizedBox(height: 12.h), Container(decoration: BoxDecoration(color: _connectionType == 'printer' ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(6.r), border: Border.all(color: _connectionType == 'printer' ? AppColors.appbarGreen : Colors.transparent, width: 2)), child: RadioListTile<String>(value: 'printer', groupValue: _connectionType, onChanged: (value) async { if (value == null) return; setState(() => _connectionType = value); await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.cashDrawerConnectionType, value); }, title: Row(children: [Text('Via Printer (RJ11)', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)), SizedBox(width: 8.w), Container(padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h), decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4.r)), child: Text('Recommended', style: TextStyle(fontSize: 11.sp, color: Colors.green.shade700, fontWeight: FontWeight.bold)))]), subtitle: Text('Standard retail setup. Drawer connected to printer via RJ11 cable.', style: TextStyle(fontSize: 12.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 8.w)))), SizedBox(height: 8.h), Container(decoration: BoxDecoration(color: _connectionType == 'direct' ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(6.r), border: Border.all(color: _connectionType == 'direct' ? AppColors.appbarGreen : Colors.transparent, width: 2)), child: RadioListTile<String>(value: 'direct', groupValue: _connectionType, onChanged: (value) async { if (value == null) return; setState(() => _connectionType = value); await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.cashDrawerConnectionType, value); }, title: Text('Direct USB', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)), subtitle: Text('Legacy setup. Drawer connected directly via USB-Serial adapter.', style: TextStyle(fontSize: 12.sp)), activeColor: AppColors.appbarGreen, contentPadding: EdgeInsets.symmetric(horizontal: 8.w)))),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _testDrawer, icon: const Icon(Icons.open_in_new), label: const Text('Test Cash Drawer'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen, foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 12.h)))),
            ],
          ],
        ),
      ),
    );
  }
}

/// Backup Settings Section
class _BackupSettingsSection extends StatefulWidget {
  const _BackupSettingsSection();

  @override
  State<_BackupSettingsSection> createState() => _BackupSettingsSectionState();
}

class _BackupSettingsSectionState extends State<_BackupSettingsSection> {
  bool _enabled = false;
  int _runsPerDay = 1;
  TimeOfDay _firstTime = const TimeOfDay(hour: 2, minute: 0);
  int _retentionDays = 3;
  String _backupFolder = r'C:\PosX\mariadb\backups';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await UserPreference.getInstance();
    final saved = await BackupScheduler.getSavedBackupSettings();
    final times = (saved['times'] as List).cast<String>();
    if (times.isNotEmpty) {
      final parts = times[0].split(':');
      final h = int.tryParse(parts[0]) ?? 2;
      final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
      setState(() => _firstTime = TimeOfDay(hour: h, minute: m));
      setState(() => _enabled = true);
    }
    final retention = saved['retention'] as int? ?? 3;
    setState(() => _retentionDays = retention);
    final folder = UserPreference.getString('backup_folder') ?? r'C:\PosX\mariadb\backups';
    setState(() => _backupFolder = folder);
    final runs = UserPreference.getInt('backup_runs_per_day') ?? 1;
    setState(() => _runsPerDay = runs);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _firstTime);
    if (t != null) setState(() => _firstTime = t);
  }

  Future<void> _pickFolder() async {
    // On Windows: use a PowerShell dialog to pick a folder (requires PowerShell present).
    if (Platform.isWindows) {
      try {
        // PowerShell command to show a folder browser and print the selected path
        final ps = r"Add-Type -AssemblyName System.Windows.Forms; $d = New-Object System.Windows.Forms.FolderBrowserDialog; $d.ShowNewFolderButton = $true; if($d.ShowDialog() -eq 'OK'){ Write-Output $d.SelectedPath }";
        final result = await Process.run('powershell', ['-NoProfile', '-Command', ps], runInShell: true);
        final out = (result.stdout ?? '').toString().trim();
        if (out.isNotEmpty) {
          setState(() => _backupFolder = out);
          return;
        }
      } catch (_) {
        // fall through to manual input
      }
    }

    // Fallback: prompt for manual folder path
    final controller = TextEditingController(text: _backupFolder);
    final val = await showDialog<String?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Backup folder'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: r'C:\PosX\mariadb\backups'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('OK')),
          ],
        );
      },
    );

    if (val != null && val.trim().isNotEmpty) setState(() => _backupFolder = val.trim());
  }

  String _timeToStr(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await UserPreference.getInstance();
      await UserPreference.putBool('backup_enabled', _enabled);
      await UserPreference.putInt('backup_runs_per_day', _runsPerDay);
      await UserPreference.putInt('backup_retention_days', _retentionDays);
      await UserPreference.putString('backup_folder', _backupFolder);

      // Ensure folder exists
      final dir = Directory(_backupFolder);
      if (!await dir.exists()) await dir.create(recursive: true);

      // write credential file for script
      final credsPath = r'C:\PosX\mariadb\creds.json';
      await BackupCredentialWriter.writeCredsFile(credsPath);

      // build times list
      final times = <String>[_timeToStr(_firstTime)];
      if (_runsPerDay == 2) {
        // add +12h
        final secondHour = (_firstTime.hour + 12) % 24;
        final second = TimeOfDay(hour: secondHour, minute: _firstTime.minute);
        times.add(_timeToStr(second));
      }

      // schedule tasks (try to create SYSTEM tasks)
      final scheduledOk = await BackupScheduler.createOrUpdateTasks(
        times: times,
        retentionDays: _retentionDays,
        scriptPath: r'C:\PosX\mariadb\backup_mariadb.ps1',
        runAsSystem: true,
      );

      // Provide feedback: silent on success, show warning on failure
      if (!scheduledOk) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Backup saved, but scheduling failed. Run the app as administrator or create the scheduled task manually.'),
          backgroundColor: Colors.orange,
        ));
      } else {
        // success: no snackbar to keep scheduled runs silent
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving backup settings: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _backupNow() async {
    setState(() => _isSaving = true);
    try {
      // Run the script directly
      final script = r'C:\PosX\mariadb\backup_mariadb.ps1';
      final result = await Process.run('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script], runInShell: true);
      if (result.exitCode == 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup completed')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup failed: ${result.stderr ?? result.stdout}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(Icons.folder, color: AppColors.appbarGreen, size: 28.sp),
          title: Text('Backups', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
          subtitle: Text(_enabled ? 'Enabled' : 'Disabled', style: TextStyle(fontSize: 14.sp, color: _enabled ? Colors.grey.shade600 : Colors.orange.shade400)),
          children: [
            SwitchListTile(
              value: _enabled,
              onChanged: (v) => setState(() => _enabled = v),
              title: Text('Enable automatic backups', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              activeColor: AppColors.appbarGreen,
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(child: Text('Runs per day', style: TextStyle(fontSize: 15.sp))),
                DropdownButton<int>(
                  value: _runsPerDay,
                  items: [1, 2].map((e) => DropdownMenuItem<int>(value: e, child: Text('$e'))).toList(),
                  onChanged: (v) => setState(() => _runsPerDay = v ?? 1),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(child: Text('First run time', style: TextStyle(fontSize: 15.sp))),
                TextButton(onPressed: _pickTime, child: Text(_timeToStr(_firstTime))),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(child: Text('Retention (days)', style: TextStyle(fontSize: 15.sp))),
                DropdownButton<int>(
                  value: _retentionDays,
                  items: [3, 4, 5].map((d) => DropdownMenuItem<int>(value: d, child: Text('$d'))).toList(),
                  onChanged: (v) => setState(() => _retentionDays = v ?? 3),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text('Backup folder', style: TextStyle(fontSize: 15.sp)),
            SizedBox(height: 6.h),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8.r)),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                children: [
                  Expanded(child: Text(_backupFolder)),
                  TextButton(onPressed: _pickFolder, child: const Text('Change'))
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.appbarGreen),
                    child: _isSaving ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Save'),
                  ),
                ),
                SizedBox(width: 12.w),
                SizedBox(
                  width: 140.w,
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : _backupNow,
                    child: const Text('Backup Now'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// VFD Display Configuration Section
class _VFDDisplaySection extends StatefulWidget {
  const _VFDDisplaySection();

  @override
  State<_VFDDisplaySection> createState() => _VFDDisplaySectionState();
}

class _VFDDisplaySectionState extends State<_VFDDisplaySection> {
  bool _vfdEnabled = false;
  String _comPort = 'COM1';
  int _baudRate = 9600;
  int _dataBits = 8;
  int _stopBits = 1;
  String _parity = 'None';

  final List<String> _comPorts = ['COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8'];
  final List<int> _baudRates = [2400, 4800, 9600, 19200, 38400, 57600, 115200];
  final List<int> _dataBitsList = [7, 8];
  final List<int> _stopBitsList = [1, 2];
  final List<String> _parityList = ['None', 'Even', 'Odd', 'Mark', 'Space'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    UserPreference.getInstance().then((_) {
      setState(() {
        _vfdEnabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? _vfdEnabled;
        _comPort = UserPreference.getString(PrefKeys.vfdComPort) ?? _comPort;
        _baudRate = UserPreference.getInt(PrefKeys.vfdBaudRate) ?? _baudRate;
        _dataBits = UserPreference.getInt(PrefKeys.vfdDataBits) ?? _dataBits;
        _stopBits = UserPreference.getInt(PrefKeys.vfdStopBits) ?? _stopBits;
        _parity = UserPreference.getString(PrefKeys.vfdParity) ?? _parity;
      });
    });
  }

  void _testDisplay() {
    // TODO: Implement VFD test
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test message sent to VFD')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: Colors.grey.shade100,
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(
            Icons.computer,
            color: AppColors.appbarGreen,
            size: 28.sp,
          ),
          title: Text(
            'VFD Customer Display',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.appbarGreen,
            ),
          ),
          subtitle: Text(
            _vfdEnabled ? 'Enabled on $_comPort' : 'Disabled',
            style: TextStyle(
              fontSize: 14.sp,
              color: _vfdEnabled ? Colors.grey.shade600 : Colors.orange.shade400,
            ),
          ),
          children: [
            // Enable Toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SwitchListTile(
                value: _vfdEnabled,
                  onChanged: (value) async {
                  setState(() => _vfdEnabled = value);
                  await UserPreference.getInstance();
                  await UserPreference.putBool(PrefKeys.vfdEnabled, value);
                },
                title: Text(
                  'Enable VFD Display',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '2x20 character display',
                  style: TextStyle(fontSize: 13.sp),
                ),
                activeColor: AppColors.appbarGreen,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
            ),

            if (_vfdEnabled) ...[
              SizedBox(height: 16.h),

              // Serial Port Configuration Section
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.settings_input_component, color: Colors.blue, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Serial Port Configuration',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // COM Port Dropdown
                    _buildConfigRow(
                      'COM Port',
                      DropdownButton<String>(
                        value: _comPort,
                        isDense: true,
                        items: _comPorts.map((port) {
                          return DropdownMenuItem(value: port, child: Text(port));
                        }).toList(),
                        onChanged: (value) async {
                          if (value == null) return;
                          setState(() => _comPort = value);
                          await UserPreference.getInstance();
                          await UserPreference.putString(PrefKeys.vfdComPort, value);
                        },
                      ),
                    ),
                      _buildConfigRow(
                        'COM Port',
                        AutoPersist<String>(
                          prefKey: PrefKeys.vfdComPort,
                          defaultValue: 'COM1',
                          builder: (ctx, val, onChanged) {
                            return DropdownButton<String>(
                              value: val,
                              isDense: true,
                              items: _comPorts.map((port) => DropdownMenuItem(value: port, child: Text(port))).toList(),
                              onChanged: (v) => onChanged(v ?? 'COM1'),
                            );
                          },
                        ),
                      ),

                    SizedBox(height: 8.h),

                    // Baud Rate Dropdown
                    _buildConfigRow(
                      'Baud Rate',
                      DropdownButton<int>(
                        value: _baudRate,
                        isDense: true,
                        items: _baudRates.map((rate) {
                          return DropdownMenuItem(value: rate, child: Text('$rate'));
                        }).toList(),
                        onChanged: (value) async {
                          if (value == null) return;
                          setState(() => _baudRate = value);
                          await UserPreference.getInstance();
                          await UserPreference.putInt(PrefKeys.vfdBaudRate, value);
                        },
                      ),
                    ),
                      _buildConfigRow(
                        'Baud Rate',
                        AutoPersist<int>(
                          prefKey: PrefKeys.vfdBaudRate,
                          defaultValue: 9600,
                          builder: (ctx, val, onChanged) {
                            return DropdownButton<int>(
                              value: val,
                              isDense: true,
                              items: _baudRates.map((rate) => DropdownMenuItem(value: rate, child: Text('$rate'))).toList(),
                              onChanged: (v) => onChanged(v ?? 9600),
                            );
                          },
                        ),
                      ),

                    SizedBox(height: 8.h),

                    // Data Bits Dropdown
                    _buildConfigRow(
                      'Data Bits',
                      DropdownButton<int>(
                        value: _dataBits,
                        isDense: true,
                        items: _dataBitsList.map((bits) {
                          return DropdownMenuItem(value: bits, child: Text('$bits'));
                        }).toList(),
                        onChanged: (value) async {
                          if (value == null) return;
                          setState(() => _dataBits = value);
                          await UserPreference.getInstance();
                          await UserPreference.putInt(PrefKeys.vfdDataBits, value);
                        },
                      ),
                    ),
                      _buildConfigRow(
                        'Data Bits',
                        AutoPersist<int>(
                          prefKey: PrefKeys.vfdDataBits,
                          defaultValue: 8,
                          builder: (ctx, val, onChanged) {
                            return DropdownButton<int>(
                              value: val,
                              isDense: true,
                              items: _dataBitsList.map((bits) => DropdownMenuItem(value: bits, child: Text('$bits'))).toList(),
                              onChanged: (v) => onChanged(v ?? 8),
                            );
                          },
                        ),
                      ),

                    SizedBox(height: 8.h),

                    // Stop Bits Dropdown
                    _buildConfigRow(
                      'Stop Bits',
                      DropdownButton<int>(
                        value: _stopBits,
                        isDense: true,
                        items: _stopBitsList.map((bits) {
                          return DropdownMenuItem(value: bits, child: Text('$bits'));
                        }).toList(),
                        onChanged: (value) async {
                          if (value == null) return;
                          setState(() => _stopBits = value);
                          await UserPreference.getInstance();
                          await UserPreference.putInt(PrefKeys.vfdStopBits, value);
                        },
                      ),
                    ),
                      _buildConfigRow(
                        'Stop Bits',
                        AutoPersist<int>(
                          prefKey: PrefKeys.vfdStopBits,
                          defaultValue: 1,
                          builder: (ctx, val, onChanged) {
                            return DropdownButton<int>(
                              value: val,
                              isDense: true,
                              items: _stopBitsList.map((bits) => DropdownMenuItem(value: bits, child: Text('$bits'))).toList(),
                              onChanged: (v) => onChanged(v ?? 1),
                            );
                          },
                        ),
                      ),

                    SizedBox(height: 8.h),

                    // Parity Dropdown
                    _buildConfigRow(
                      'Parity',
                      DropdownButton<String>(
                        value: _parity,
                        isDense: true,
                        items: _parityList.map((p) {
                          return DropdownMenuItem(value: p, child: Text(p));
                        }).toList(),
                        onChanged: (value) async {
                          if (value == null) return;
                          setState(() => _parity = value);
                          await UserPreference.getInstance();
                          await UserPreference.putString(PrefKeys.vfdParity, value);
                        },
                      ),
                    ),
                      _buildConfigRow(
                        'Parity',
                        AutoPersist<String>(
                          prefKey: PrefKeys.vfdParity,
                          defaultValue: 'None',
                          builder: (ctx, val, onChanged) {
                            return DropdownButton<String>(
                              value: val,
                              isDense: true,
                              items: _parityList.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                              onChanged: (v) => onChanged(v ?? 'None'),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // VFD Preview (2x20 character grid)
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company Name Here   ',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 14.sp,
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'POS Profile / \$0.00 ',
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 14.sp,
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8.h),

              // Preview Info
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16.sp, color: Colors.grey.shade600),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Preview shows 2x20 character display. Content from ERPNext POS Profile.',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Test Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _testDisplay,
                  icon: const Icon(Icons.check),
                  label: const Text('Test VFD Display'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.appbarGreen,
                    side: BorderSide(color: AppColors.appbarGreen),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, Widget dropdown) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        dropdown,
      ],
    );
  }
}

/// Cash Drawer Configuration Section
class _CashDrawerSection extends StatefulWidget {
  const _CashDrawerSection();

  @override
  State<_CashDrawerSection> createState() => _CashDrawerSectionState();
}

class _CashDrawerSectionState extends State<_CashDrawerSection> {
  bool _erpnextEnabled = false;
  String _connectionType = 'printer'; // 'printer' or 'direct'

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // TODO: Load from UserPreference
    // _erpnextEnabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? false;
    // _connectionType = UserPreference.getString(PrefKeys.cashDrawerConnectionType) ?? 'printer';
  }

  void _testDrawer() {
    // TODO: Use openCashDrawer() from cash_drawer_logic.dart
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening cash drawer...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: Colors.grey.shade100,
        ),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          childrenPadding: EdgeInsets.all(16.w),
          leading: Icon(
            Icons.point_of_sale,
            color: AppColors.appbarGreen,
            size: 28.sp,
          ),
          title: Text(
            'Cash Drawer',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.appbarGreen,
            ),
          ),
          subtitle: Text(
            _erpnextEnabled 
                ? 'Enabled - ${_connectionType == "printer" ? "Via Printer (RJ11)" : "Direct USB"}'
                : 'Disabled in ERPNext',
            style: TextStyle(
              fontSize: 14.sp,
              color: _erpnextEnabled ? Colors.grey.shade600 : Colors.red.shade400,
            ),
          ),
          children: [
            // ERPNext Status Box
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: _erpnextEnabled ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: _erpnextEnabled ? Colors.green.shade300 : Colors.red.shade300,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _erpnextEnabled ? Icons.check_circle : Icons.cancel,
                    color: _erpnextEnabled ? Colors.green : Colors.red,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ERPNext POS Profile Setting',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: _erpnextEnabled ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _erpnextEnabled
                              ? 'Cash drawer is enabled. Opens automatically after payment.'
                              : 'Cash drawer is disabled. Enable in POS Profile > Settings > Open Cash Drawer.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: _erpnextEnabled ? Colors.green.shade600 : Colors.red.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (_erpnextEnabled) ...[
              SizedBox(height: 16.h),

              // Connection Type Radio Buttons
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cable, color: Colors.blue, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Connection Method',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Via Printer (RJ11) - Recommended
                    Container(
                      decoration: BoxDecoration(
                        color: _connectionType == 'printer' ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: _connectionType == 'printer' 
                              ? AppColors.appbarGreen 
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: RadioListTile<String>(
                        value: 'printer',
                        groupValue: _connectionType,
                        onChanged: (value) async {
                          if (value == null) return;
                          setState(() => _connectionType = value);
                          await UserPreference.getInstance();
                          await UserPreference.putString(PrefKeys.cashDrawerConnectionType, value);
                        },
                        title: Row(
                          children: [
                            Text(
                              'Via Printer (RJ11)',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'Recommended',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          'Standard retail setup. Drawer connected to printer via RJ11 cable.',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        activeColor: AppColors.appbarGreen,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Direct USB
                    Container(
                      decoration: BoxDecoration(
                        color: _connectionType == 'direct' ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: _connectionType == 'direct' 
                              ? AppColors.appbarGreen 
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: RadioListTile<String>(
                        value: 'direct',
                        groupValue: _connectionType,
                        onChanged: (value) async {
                          if (value == null) return;
                          setState(() => _connectionType = value);
                          await UserPreference.getInstance();
                          await UserPreference.putString(PrefKeys.cashDrawerConnectionType, value);
                        },
                        title: Text(
                          'Direct USB',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          'Legacy setup. Drawer connected directly via USB-Serial adapter.',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        activeColor: AppColors.appbarGreen,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Test Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _testDrawer,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Test Cash Drawer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.appbarGreen,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // Info Note
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16.sp, color: Colors.grey.shade600),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Drawer opens automatically after successful payment when enabled.',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
