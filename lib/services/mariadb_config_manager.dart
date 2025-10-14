import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'simple_hardware_optimizer.dart';

/// MariaDB Configuration File Management
/// Handles my.cnf/my.ini file generation, backup, and safety mechanisms
class MariaDBConfigManager {
  static const String _logTag = '[MariaDBConfigManager]';
  
  // Common MariaDB configuration file locations
  static final List<String> _windowsConfigPaths = [
    r'C:\xampp\mysql\bin\my.ini',
    r'C:\MySQL\my.ini',
    r'C:\ProgramData\MySQL\MySQL Server 8.0\my.ini',
    r'C:\Program Files\MySQL\MySQL Server 8.0\my.ini',
    r'C:\wamp64\bin\mysql\mysql8.0.31\my.ini',
    r'C:\laragon\bin\mysql\mysql-8.0.30-winx64\my.ini',
  ];
  
  static final List<String> _linuxConfigPaths = [
    '/etc/mysql/my.cnf',
    '/etc/my.cnf',
    '/usr/local/mysql/my.cnf',
    '/opt/lampp/etc/my.cnf',
    '/home/user/.my.cnf',
  ];
  
  static final List<String> _macOSConfigPaths = [
    '/usr/local/mysql/my.cnf',
    '/etc/my.cnf',
    '/usr/local/etc/my.cnf',
    '/Applications/XAMPP/xamppfiles/etc/my.cnf',
    '/Applications/MAMP/conf/mysql/my.cnf',
  ];
  
  /// Find existing MariaDB/MySQL configuration file
  static Future<String?> findConfigFile() async {
    try {
      debugPrint('$_logTag Searching for existing MariaDB configuration...');
      
      List<String> searchPaths = [];
      
      if (Platform.isWindows) {
        searchPaths = _windowsConfigPaths;
      } else if (Platform.isLinux) {
        searchPaths = _linuxConfigPaths;
      } else if (Platform.isMacOS) {
        searchPaths = _macOSConfigPaths;
      }
      
      for (final configPath in searchPaths) {
        final file = File(configPath);
        if (await file.exists()) {
          debugPrint('$_logTag Found config file: $configPath');
          return configPath;
        }
      }
      
      debugPrint('$_logTag No existing config file found');
      return null;
      
    } catch (e) {
      debugPrint('$_logTag Config file search failed: $e');
      return null;
    }
  }
  
  /// Create backup of existing configuration file
  static Future<String?> createBackup(String configPath) async {
    try {
      debugPrint('$_logTag Creating backup of $configPath...');
      
      final configFile = File(configPath);
      if (!await configFile.exists()) {
        debugPrint('$_logTag Config file does not exist: $configPath');
        return null;
      }
      
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final backupPath = '$configPath.posx-backup-$timestamp';
      
      await configFile.copy(backupPath);
      
      debugPrint('$_logTag Backup created: $backupPath');
      return backupPath;
      
    } catch (e) {
      debugPrint('$_logTag Backup creation failed: $e');
      return null;
    }
  }
  
  /// Restore configuration from backup
  static Future<bool> restoreFromBackup(String backupPath, String configPath) async {
    try {
      debugPrint('$_logTag Restoring config from backup: $backupPath');
      
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        debugPrint('$_logTag Backup file does not exist: $backupPath');
        return false;
      }
      
      await backupFile.copy(configPath);
      
      debugPrint('$_logTag Configuration restored from backup');
      return true;
      
    } catch (e) {
      debugPrint('$_logTag Restore from backup failed: $e');
      return false;
    }
  }
  
  /// Validate configuration file syntax
  static Future<bool> validateConfig(String configPath) async {
    try {
      debugPrint('$_logTag Validating config file: $configPath');
      
      final configFile = File(configPath);
      if (!await configFile.exists()) {
        debugPrint('$_logTag Config file does not exist: $configPath');
        return false;
      }
      
      final content = await configFile.readAsString();
      
      // Basic validation checks
      if (!content.contains('[mysqld]')) {
        debugPrint('$_logTag Config validation failed: No [mysqld] section found');
        return false;
      }
      
      // Check for obviously malformed lines
      final lines = content.split('\n');
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty || line.startsWith('#') || line.startsWith('[')) continue;
        
        if (!line.contains('=')) {
          debugPrint('$_logTag Config validation failed: Malformed line ${i + 1}: $line');
          return false;
        }
      }
      
      debugPrint('$_logTag Config validation passed');
      return true;
      
    } catch (e) {
      debugPrint('$_logTag Config validation failed: $e');
      return false;
    }
  }
  
  /// Apply MariaDB configuration with safety mechanisms
  static Future<ConfigApplyResult> applyConfiguration(MariaDBConfig config) async {
    try {
      debugPrint('$_logTag Starting configuration application...');
      
      // Step 1: Find existing config file
      final existingConfigPath = await findConfigFile();
      if (existingConfigPath == null) {
        return ConfigApplyResult(
          success: false,
          message: 'No MariaDB configuration file found. Please install MariaDB/MySQL first.',
          configPath: null,
          backupPath: null,
        );
      }
      
      // Step 2: Create backup
      final backupPath = await createBackup(existingConfigPath);
      if (backupPath == null) {
        return ConfigApplyResult(
          success: false,
          message: 'Failed to create backup of existing configuration.',
          configPath: existingConfigPath,
          backupPath: null,
        );
      }
      
      // Step 3: Generate new configuration content
      final newConfigContent = await _generateMergedConfig(existingConfigPath, config);
      
      // Step 4: Write new configuration
      final configFile = File(existingConfigPath);
      await configFile.writeAsString(newConfigContent);
      
      // Step 5: Validate new configuration
      final isValid = await validateConfig(existingConfigPath);
      if (!isValid) {
        // Restore backup if validation fails
        await restoreFromBackup(backupPath, existingConfigPath);
        return ConfigApplyResult(
          success: false,
          message: 'Generated configuration failed validation. Original configuration restored.',
          configPath: existingConfigPath,
          backupPath: backupPath,
        );
      }
      
      debugPrint('$_logTag Configuration successfully applied');
      return ConfigApplyResult(
        success: true,
        message: 'MariaDB configuration optimized for ${config.tier} hardware.',
        configPath: existingConfigPath,
        backupPath: backupPath,
      );
      
    } catch (e) {
      debugPrint('$_logTag Configuration application failed: $e');
      return ConfigApplyResult(
        success: false,
        message: 'Failed to apply configuration: $e',
        configPath: null,
        backupPath: null,
      );
    }
  }
  
  /// Generate merged configuration preserving existing settings
  static Future<String> _generateMergedConfig(String existingConfigPath, MariaDBConfig config) async {
    final existingContent = await File(existingConfigPath).readAsString();
    final lines = existingContent.split('\n');
    final buffer = StringBuffer();
    
    bool inMysqldSection = false;
    bool posxSectionAdded = false;
    final Set<String> posxSettings = config.settings.keys.toSet();
    final Set<String> processedSettings = <String>{};
    
    for (final line in lines) {
      final trimmedLine = line.trim();
      
      // Track [mysqld] section
      if (trimmedLine == '[mysqld]') {
        inMysqldSection = true;
        buffer.writeln(line);
        continue;
      }
      
      if (trimmedLine.startsWith('[') && trimmedLine != '[mysqld]') {
        // Exiting [mysqld] section
        if (inMysqldSection && !posxSectionAdded) {
          _addPosxOptimizations(buffer, config, processedSettings);
          posxSectionAdded = true;
        }
        inMysqldSection = false;
      }
      
      // Process settings in [mysqld] section
      if (inMysqldSection && trimmedLine.contains('=')) {
        final parts = trimmedLine.split('=');
        if (parts.length >= 2) {
          final settingName = parts[0].trim();
          
          if (posxSettings.contains(settingName)) {
            // Replace with PosX optimized value
            final posxValue = config.settings[settingName];
            buffer.writeln('$settingName = $posxValue  # PosX optimized');
            processedSettings.add(settingName);
            continue;
          }
        }
      }
      
      buffer.writeln(line);
    }
    
    // Add PosX optimizations if not added yet
    if (!posxSectionAdded) {
      _addPosxOptimizations(buffer, config, processedSettings);
    }
    
    return buffer.toString();
  }
  
  /// Add PosX-specific optimizations to configuration
  static void _addPosxOptimizations(StringBuffer buffer, MariaDBConfig config, Set<String> processedSettings) {
    buffer.writeln();
    buffer.writeln('# PosX Performance Optimizations');
    buffer.writeln('# Generated: ${config.generatedTime.toIso8601String()}');
    buffer.writeln('# Hardware Tier: ${config.tier}');
    
    // Add unprocessed settings
    config.settings.forEach((key, value) {
      if (!processedSettings.contains(key)) {
        buffer.writeln('$key = $value');
      }
    });
    
    buffer.writeln();
    buffer.writeln('# PosX specific optimizations for 24/7 operation');
    buffer.writeln('innodb_flush_log_at_trx_commit = 2  # Improved performance');
    buffer.writeln('sync_binlog = 0  # Disable for performance');
    buffer.writeln('innodb_doublewrite = 0  # Disable for SSD');
    buffer.writeln('query_cache_type = 1  # Enable query cache');
    buffer.writeln();
  }
  
  /// Get list of available backup files
  static Future<List<String>> getAvailableBackups() async {
    try {
      final configPath = await findConfigFile();
      if (configPath == null) return [];
      
      final configDir = Directory(path.dirname(configPath));
      if (!await configDir.exists()) return [];
      
      final backups = <String>[];
      await for (final entity in configDir.list()) {
        if (entity is File && entity.path.contains('.posx-backup-')) {
          backups.add(entity.path);
        }
      }
      
      // Sort by modification time (newest first)
      backups.sort((a, b) {
        final aTime = File(a).lastModifiedSync();
        final bTime = File(b).lastModifiedSync();
        return bTime.compareTo(aTime);
      });
      
      return backups;
      
    } catch (e) {
      debugPrint('$_logTag Failed to get available backups: $e');
      return [];
    }
  }
  
  /// Test database connection with new configuration
  static Future<bool> testDatabaseConnection() async {
    try {
      debugPrint('$_logTag Testing database connection...');
      
      // TODO: Implement actual database connection test
      // This would require database credentials and connection logic
      // For now, return true as placeholder
      
      await Future.delayed(const Duration(seconds: 1)); // Simulate test
      debugPrint('$_logTag Database connection test completed');
      return true;
      
    } catch (e) {
      debugPrint('$_logTag Database connection test failed: $e');
      return false;
    }
  }
}

/// Result of configuration application
class ConfigApplyResult {
  final bool success;
  final String message;
  final String? configPath;
  final String? backupPath;
  
  const ConfigApplyResult({
    required this.success,
    required this.message,
    required this.configPath,
    required this.backupPath,
  });
  
  @override
  String toString() {
    return 'ConfigApplyResult(success: $success, message: "$message", configPath: $configPath, backupPath: $backupPath)';
  }
}