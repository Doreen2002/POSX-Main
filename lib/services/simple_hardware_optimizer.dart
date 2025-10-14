import 'dart:io';
import 'package:flutter/foundation.dart';
import 'mariadb_config_manager.dart';

/// Simple Hardware Optimizer for PosX
/// Detects system hardware and generates optimal MariaDB configurations
/// Supports Budget (2-4GB buffer), Standard (4-8GB), Enterprise (12GB+) tiers
class SimpleHardwareOptimizer {
  static const String _logTag = '[HardwareOptimizer]';
  
  // Hardware detection results
  static HardwareInfo? _cachedHardwareInfo;
  static MariaDBConfig? _cachedMariaDBConfig;
  
  /// Comprehensive hardware detection
  static Future<HardwareInfo> detectHardware() async {
    if (_cachedHardwareInfo != null) return _cachedHardwareInfo!;
    
    try {
      debugPrint('$_logTag Starting hardware detection...');
      
      final cpuInfo = await _detectCPU();
      final ramInfo = await _detectRAM();
      final storageInfo = await _detectStorage();
      final platformInfo = _detectPlatform();
      
      _cachedHardwareInfo = HardwareInfo(
        cpu: cpuInfo,
        ram: ramInfo,
        storage: storageInfo,
        platform: platformInfo,
        detectionTime: DateTime.now(),
      );
      
      debugPrint('$_logTag Hardware detection complete: ${_cachedHardwareInfo!.summary}');
      return _cachedHardwareInfo!;
      
    } catch (e) {
      debugPrint('$_logTag Hardware detection failed: $e');
      // Return safe defaults for unknown hardware
      _cachedHardwareInfo = HardwareInfo.createDefault();
      return _cachedHardwareInfo!;
    }
  }
  
  /// Generate optimal MariaDB configuration based on hardware
  static Future<MariaDBConfig> generateMariaDBConfig([HardwareInfo? hardware]) async {
    hardware ??= await detectHardware();
    
    if (_cachedMariaDBConfig != null) return _cachedMariaDBConfig!;
    
    try {
      debugPrint('$_logTag Generating MariaDB config for ${hardware.tier} tier...');
      
      final config = MariaDBConfig.fromHardware(hardware);
      _cachedMariaDBConfig = config;
      
      debugPrint('$_logTag MariaDB config generated: ${config.summary}');
      return config;
      
    } catch (e) {
      debugPrint('$_logTag MariaDB config generation failed: $e');
      _cachedMariaDBConfig = MariaDBConfig.createSafe();
      return _cachedMariaDBConfig!;
    }
  }
  
  /// Apply optimization with full configuration management
  static Future<ConfigApplyResult> applyOptimizations() async {
    try {
      debugPrint('$_logTag Applying optimizations...');
      
      final hardware = await detectHardware();
      final mariadbConfig = await generateMariaDBConfig(hardware);
      
      // Apply MariaDB configuration with safety mechanisms
      final result = await MariaDBConfigManager.applyConfiguration(mariadbConfig);
      
      debugPrint('$_logTag Optimization result: ${result.message}');
      return result;
      
    } catch (e) {
      debugPrint('$_logTag Optimization application failed: $e');
      return ConfigApplyResult(
        success: false,
        message: 'Failed to apply optimizations: $e',
        configPath: null,
        backupPath: null,
      );
    }
  }
  
  /// CPU Detection
  static Future<CPUInfo> _detectCPU() async {
    try {
      if (Platform.isWindows) {
        final result = await Process.run('wmic', [
          'cpu', 'get', 'Name,NumberOfCores,NumberOfLogicalProcessors', '/format:csv'
        ]);
        return _parseWindowsCPU(result.stdout.toString());
      }
      
      if (Platform.isLinux) {
        final result = await Process.run('cat', ['/proc/cpuinfo']);
        return _parseLinuxCPU(result.stdout.toString());
      }
      
      if (Platform.isMacOS) {
        final result = await Process.run('sysctl', ['-n', 'machdep.cpu.brand_string']);
        return _parseMacOSCPU(result.stdout.toString());
      }
      
      return CPUInfo.createDefault();
      
    } catch (e) {
      debugPrint('$_logTag CPU detection failed: $e');
      return CPUInfo.createDefault();
    }
  }
  
  /// RAM Detection  
  static Future<RAMInfo> _detectRAM() async {
    try {
      if (Platform.isWindows) {
        final result = await Process.run('wmic', [
          'computersystem', 'get', 'TotalPhysicalMemory', '/format:csv'
        ]);
        return _parseWindowsRAM(result.stdout.toString());
      }
      
      if (Platform.isLinux) {
        final result = await Process.run('cat', ['/proc/meminfo']);
        return _parseLinuxRAM(result.stdout.toString());
      }
      
      if (Platform.isMacOS) {
        final result = await Process.run('sysctl', ['-n', 'hw.memsize']);
        return _parseMacOSRAM(result.stdout.toString());
      }
      
      return RAMInfo.createDefault();
      
    } catch (e) {
      debugPrint('$_logTag RAM detection failed: $e');
      return RAMInfo.createDefault();
    }
  }
  
  /// Storage Detection
  static Future<StorageInfo> _detectStorage() async {
    try {
      if (Platform.isWindows) {
        final result = await Process.run('wmic', [
          'logicaldisk', 'get', 'Size,FreeSpace,MediaType', '/format:csv'
        ]);
        return _parseWindowsStorage(result.stdout.toString());
      }
      
      if (Platform.isLinux || Platform.isMacOS) {
        final result = await Process.run('df', ['-h']);
        return _parseUnixStorage(result.stdout.toString());
      }
      
      return StorageInfo.createDefault();
      
    } catch (e) {
      debugPrint('$_logTag Storage detection failed: $e');
      return StorageInfo.createDefault();
    }
  }
  
  /// Platform Detection
  static PlatformInfo _detectPlatform() {
    return PlatformInfo(
      os: Platform.operatingSystem,
      version: Platform.operatingSystemVersion,
      architecture: _detectArchitecture(),
    );
  }
  
  static String _detectArchitecture() {
    // Check for ARM vs x86/x64
    final env = Platform.environment;
    final arch = env['PROCESSOR_ARCHITECTURE'] ?? env['HOSTTYPE'] ?? 'unknown';
    
    if (arch.toLowerCase().contains('arm') || arch.toLowerCase().contains('aarch')) {
      return 'ARM';
    } else if (arch.toLowerCase().contains('x64') || arch.toLowerCase().contains('amd64')) {
      return 'x64';
    } else if (arch.toLowerCase().contains('x86')) {
      return 'x86';
    }
    
    return 'unknown';
  }
  
  // Platform-specific parsing methods
  static CPUInfo _parseWindowsCPU(String output) {
    final lines = output.split('\n');
    String name = 'Unknown CPU';
    int cores = 2;
    int threads = 2;
    
    for (final line in lines) {
      final parts = line.split(',');
      if (parts.length >= 4 && parts[1].trim().isNotEmpty) {
        name = parts[1].trim();
        cores = int.tryParse(parts[2].trim()) ?? 2;
        threads = int.tryParse(parts[3].trim()) ?? 2;
        break;
      }
    }
    
    return CPUInfo(name: name, cores: cores, threads: threads);
  }
  
  static CPUInfo _parseLinuxCPU(String output) {
    final lines = output.split('\n');
    String name = 'Unknown CPU';
    int cores = 2;
    
    for (final line in lines) {
      if (line.startsWith('model name')) {
        name = line.split(':').last.trim();
      } else if (line.startsWith('cpu cores')) {
        cores = int.tryParse(line.split(':').last.trim()) ?? 2;
      }
    }
    
    return CPUInfo(name: name, cores: cores, threads: cores);
  }
  
  static CPUInfo _parseMacOSCPU(String output) {
    return CPUInfo(name: output.trim(), cores: 4, threads: 4); // macOS default
  }
  
  static RAMInfo _parseWindowsRAM(String output) {
    final lines = output.split('\n');
    
    for (final line in lines) {
      final parts = line.split(',');
      if (parts.length >= 2 && parts[1].trim().isNotEmpty) {
        final bytesStr = parts[1].trim();
        final bytes = int.tryParse(bytesStr);
        if (bytes != null) {
          final gb = (bytes / (1024 * 1024 * 1024)).round();
          return RAMInfo(totalGB: gb, availableGB: (gb * 0.8).round());
        }
      }
    }
    
    return RAMInfo.createDefault();
  }
  
  static RAMInfo _parseLinuxRAM(String output) {
    final lines = output.split('\n');
    int totalKB = 8 * 1024 * 1024; // 8GB default
    
    for (final line in lines) {
      if (line.startsWith('MemTotal:')) {
        final parts = line.split(RegExp(r'\s+'));
        totalKB = int.tryParse(parts[1]) ?? totalKB;
        break;
      }
    }
    
    final totalGB = (totalKB / (1024 * 1024)).round();
    return RAMInfo(totalGB: totalGB, availableGB: (totalGB * 0.8).round());
  }
  
  static RAMInfo _parseMacOSRAM(String output) {
    final bytes = int.tryParse(output.trim()) ?? (8 * 1024 * 1024 * 1024);
    final gb = (bytes / (1024 * 1024 * 1024)).round();
    return RAMInfo(totalGB: gb, availableGB: (gb * 0.8).round());
  }
  
  static StorageInfo _parseWindowsStorage(String output) {
    final lines = output.split('\n');
    
    for (final line in lines) {
      final parts = line.split(',');
      if (parts.length >= 4 && parts[1].trim().isNotEmpty) {
        final sizeBytes = int.tryParse(parts[1].trim());
        final freeBytes = int.tryParse(parts[2].trim());
        final mediaType = parts[3].trim();
        
        if (sizeBytes != null) {
          final sizeGB = (sizeBytes / (1024 * 1024 * 1024)).round();
          final freeGB = freeBytes != null ? (freeBytes / (1024 * 1024 * 1024)).round() : 0;
          final isSSD = mediaType.contains('SSD') || mediaType == '11';
          
          return StorageInfo(totalGB: sizeGB, freeGB: freeGB, isSSD: isSSD);
        }
      }
    }
    
    return StorageInfo.createDefault();
  }
  
  static StorageInfo _parseUnixStorage(String output) {
    final lines = output.split('\n');
    if (lines.length > 1) {
      final parts = lines[1].split(RegExp(r'\s+'));
      if (parts.length >= 4) {
        final sizeStr = parts[1].replaceAll(RegExp(r'[^\d]'), '');
        final size = int.tryParse(sizeStr) ?? 256;
        return StorageInfo(totalGB: size, freeGB: (size * 0.7).round(), isSSD: true);
      }
    }
    
    return StorageInfo.createDefault();
  }
}

/// Hardware Information Classes
class HardwareInfo {
  final CPUInfo cpu;
  final RAMInfo ram;
  final StorageInfo storage;
  final PlatformInfo platform;
  final DateTime detectionTime;
  
  const HardwareInfo({
    required this.cpu,
    required this.ram,
    required this.storage,
    required this.platform,
    required this.detectionTime,
  });
  
  /// Hardware tier classification
  HardwareTier get tier {
    if (ram.totalGB >= 12 && cpu.cores >= 4) {
      return HardwareTier.enterprise;
    } else if (ram.totalGB >= 8 && cpu.cores >= 2) {
      return HardwareTier.standard;
    } else {
      return HardwareTier.budget;
    }
  }
  
  String get summary => '${cpu.name} | ${ram.totalGB}GB RAM | ${storage.totalGB}GB ${storage.isSSD ? 'SSD' : 'HDD'} | ${platform.os} ${platform.architecture}';
  
  factory HardwareInfo.createDefault() {
    return HardwareInfo(
      cpu: CPUInfo.createDefault(),
      ram: RAMInfo.createDefault(),
      storage: StorageInfo.createDefault(),
      platform: PlatformInfo(os: Platform.operatingSystem, version: 'unknown', architecture: 'unknown'),
      detectionTime: DateTime.now(),
    );
  }
}

class CPUInfo {
  final String name;
  final int cores;
  final int threads;
  
  const CPUInfo({required this.name, required this.cores, required this.threads});
  
  factory CPUInfo.createDefault() => const CPUInfo(name: 'Unknown CPU', cores: 2, threads: 2);
}

class RAMInfo {
  final int totalGB;
  final int availableGB;
  
  const RAMInfo({required this.totalGB, required this.availableGB});
  
  factory RAMInfo.createDefault() => const RAMInfo(totalGB: 8, availableGB: 6);
}

class StorageInfo {
  final int totalGB;
  final int freeGB;
  final bool isSSD;
  
  const StorageInfo({required this.totalGB, required this.freeGB, required this.isSSD});
  
  factory StorageInfo.createDefault() => const StorageInfo(totalGB: 256, freeGB: 128, isSSD: true);
}

class PlatformInfo {
  final String os;
  final String version;
  final String architecture;
  
  const PlatformInfo({required this.os, required this.version, required this.architecture});
}

enum HardwareTier { budget, standard, enterprise }

/// MariaDB Configuration Generator
class MariaDBConfig {
  final HardwareTier tier;
  final Map<String, dynamic> settings;
  final DateTime generatedTime;
  
  const MariaDBConfig({
    required this.tier,
    required this.settings,
    required this.generatedTime,
  });
  
  factory MariaDBConfig.fromHardware(HardwareInfo hardware) {
    final tier = hardware.tier;
    final settings = <String, dynamic>{};
    
    // Buffer pool size based on available RAM (conservative approach)
    final ramGB = hardware.ram.totalGB;
    String bufferPoolSize;
    
    switch (tier) {
      case HardwareTier.budget:
        bufferPoolSize = '${(ramGB * 0.25).round()}G'; // 25% of RAM
        settings.addAll(_getBudgetSettings());
        break;
      case HardwareTier.standard:
        bufferPoolSize = '${(ramGB * 0.5).round()}G'; // 50% of RAM
        settings.addAll(_getStandardSettings());
        break;
      case HardwareTier.enterprise:
        bufferPoolSize = '${(ramGB * 0.75).round()}G'; // 75% of RAM
        settings.addAll(_getEnterpriseSettings());
        break;
    }
    
    settings['innodb_buffer_pool_size'] = bufferPoolSize;
    settings['max_connections'] = tier == HardwareTier.budget ? 50 : (tier == HardwareTier.standard ? 100 : 200);
    
    return MariaDBConfig(
      tier: tier,
      settings: settings,
      generatedTime: DateTime.now(),
    );
  }
  
  static Map<String, dynamic> _getBudgetSettings() => {
    'innodb_buffer_pool_instances': 1,
    'innodb_log_file_size': '256M',
    'query_cache_size': '64M',
    'tmp_table_size': '64M',
    'max_heap_table_size': '64M',
  };
  
  static Map<String, dynamic> _getStandardSettings() => {
    'innodb_buffer_pool_instances': 2,
    'innodb_log_file_size': '512M',
    'query_cache_size': '128M',
    'tmp_table_size': '128M',
    'max_heap_table_size': '128M',
  };
  
  static Map<String, dynamic> _getEnterpriseSettings() => {
    'innodb_buffer_pool_instances': 4,
    'innodb_log_file_size': '1G',
    'query_cache_size': '256M',
    'tmp_table_size': '256M',
    'max_heap_table_size': '256M',
  };
  
  String get summary => 'Tier: $tier | Buffer: ${settings['innodb_buffer_pool_size']} | Connections: ${settings['max_connections']}';
  
  factory MariaDBConfig.createSafe() {
    return MariaDBConfig(
      tier: HardwareTier.budget,
      settings: {
        'innodb_buffer_pool_size': '2G',
        'max_connections': 50,
        ..._getBudgetSettings(),
      },
      generatedTime: DateTime.now(),
    );
  }
  
  /// Generate my.cnf/my.ini configuration file content
  String generateConfigFile() {
    final buffer = StringBuffer();
    buffer.writeln('# PosX Optimized MariaDB Configuration');
    buffer.writeln('# Generated: ${generatedTime.toIso8601String()}');
    buffer.writeln('# Tier: $tier');
    buffer.writeln();
    buffer.writeln('[mysqld]');
    
    settings.forEach((key, value) {
      buffer.writeln('$key = $value');
    });
    
    buffer.writeln();
    buffer.writeln('# PosX specific optimizations');
    buffer.writeln('innodb_flush_log_at_trx_commit = 2');
    buffer.writeln('sync_binlog = 0');
    buffer.writeln('innodb_doublewrite = 0');
    
    return buffer.toString();
  }
}