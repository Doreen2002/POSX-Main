import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/simple_hardware_optimizer.dart';
import '../services/mariadb_config_manager.dart';
import '../common_utils/app_colors.dart';

/// Professional Hardware Optimization Status Widget
/// Shows current hardware info, optimization status, and management options
class HardwareOptimizationPanel extends StatefulWidget {
  const HardwareOptimizationPanel({super.key});

  @override
  State<HardwareOptimizationPanel> createState() => _HardwareOptimizationPanelState();
}

class _HardwareOptimizationPanelState extends State<HardwareOptimizationPanel> {
  HardwareInfo? _hardwareInfo;
  MariaDBConfig? _mariadbConfig;
  bool _isLoading = true;
  bool _isOptimizing = false;
  String? _errorMessage;
  ConfigApplyResult? _lastOptimizationResult;

  @override
  void initState() {
    super.initState();
    _loadHardwareInfo();
  }

  Future<void> _loadHardwareInfo() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final hardware = await SimpleHardwareOptimizer.detectHardware();
      final config = await SimpleHardwareOptimizer.generateMariaDBConfig(hardware);

      setState(() {
        _hardwareInfo = hardware;
        _mariadbConfig = config;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load hardware information: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _applyOptimizations() async {
    if (_isOptimizing) return;

    setState(() {
      _isOptimizing = true;
      _errorMessage = null;
    });

    try {
      final result = await SimpleHardwareOptimizer.applyOptimizations();
      
      setState(() {
        _lastOptimizationResult = result;
        _isOptimizing = false;
      });

      // Show result dialog
      _showOptimizationResultDialog(result);
      
    } catch (e) {
      setState(() {
        _errorMessage = 'Optimization failed: $e';
        _isOptimizing = false;
      });
    }
  }

  void _showOptimizationResultDialog(ConfigApplyResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              result.success ? Icons.check_circle : Icons.error,
              color: result.success ? Colors.green : Colors.red,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              result.success ? 'Optimization Complete' : 'Optimization Failed',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.message),
            if (result.configPath != null) ...[
              SizedBox(height: 12.h),
              Text('Config File: ${result.configPath}', style: TextStyle(fontSize: 12.sp)),
            ],
            if (result.backupPath != null) ...[
              SizedBox(height: 4.h),
              Text('Backup Created: ${result.backupPath}', style: TextStyle(fontSize: 12.sp)),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.tune, size: 24.sp, color: Color(0xFF033D20)),
                SizedBox(width: 8.w),
                Text(
                  'Hardware Optimization',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF033D20),
                  ),
                ),
                const Spacer(),
                if (_isLoading || _isOptimizing)
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            if (_errorMessage != null) ...[
              _buildErrorCard(),
              SizedBox(height: 16.h),
            ],
            
            if (_isLoading) ...[
              _buildLoadingCard(),
            ] else if (_hardwareInfo != null) ...[
              // Hardware Information
              _buildHardwareInfoCard(),
              SizedBox(height: 16.h),
              
              // MariaDB Configuration
              _buildMariaDBConfigCard(),
              SizedBox(height: 16.h),
              
              // Optimization Status
              _buildOptimizationStatusCard(),
              SizedBox(height: 16.h),
              
              // Action Buttons
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade700, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Detecting hardware configuration...'),
          ],
        ),
      ),
    );
  }

  Widget _buildHardwareInfoCard() {
    final hardware = _hardwareInfo!;
    return _buildInfoSection(
      'Hardware Information',
      Icons.memory,
      [
        _buildInfoRow('CPU', hardware.cpu.name),
        _buildInfoRow('Cores/Threads', '${hardware.cpu.cores}/${hardware.cpu.threads}'),
        _buildInfoRow('RAM', '${hardware.ram.totalGB}GB (${hardware.ram.availableGB}GB available)'),
        _buildInfoRow('Storage', '${hardware.storage.totalGB}GB ${hardware.storage.isSSD ? 'SSD' : 'HDD'}'),
        _buildInfoRow('Platform', '${hardware.platform.os} ${hardware.platform.architecture}'),
        _buildInfoRow('Hardware Tier', _getTierDisplayName(hardware.tier)),
      ],
    );
  }

  Widget _buildMariaDBConfigCard() {
    final config = _mariadbConfig!;
    return _buildInfoSection(
      'MariaDB Configuration',
      Icons.storage,
      [
        _buildInfoRow('Buffer Pool Size', config.settings['innodb_buffer_pool_size']?.toString() ?? 'N/A'),
        _buildInfoRow('Max Connections', config.settings['max_connections']?.toString() ?? 'N/A'),
        _buildInfoRow('Buffer Pool Instances', config.settings['innodb_buffer_pool_instances']?.toString() ?? 'N/A'),
        _buildInfoRow('Log File Size', config.settings['innodb_log_file_size']?.toString() ?? 'N/A'),
        _buildInfoRow('Query Cache Size', config.settings['query_cache_size']?.toString() ?? 'N/A'),
      ],
    );
  }

  Widget _buildOptimizationStatusCard() {
    return _buildInfoSection(
      'Optimization Status',
      Icons.speed,
      [
        if (_lastOptimizationResult != null) ...[
          _buildInfoRow(
            'Last Optimization',
            _lastOptimizationResult!.success ? 'Successful' : 'Failed',
            valueColor: _lastOptimizationResult!.success ? Colors.green : Colors.red,
          ),
          _buildInfoRow('Result', _lastOptimizationResult!.message),
          if (_lastOptimizationResult!.backupPath != null)
            _buildInfoRow('Backup Created', 'Yes'),
        ] else ...[
          _buildInfoRow('Status', 'Not optimized yet', valueColor: Colors.orange),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isOptimizing ? null : _applyOptimizations,
            icon: _isOptimizing 
              ? SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(Icons.rocket_launch, size: 18.sp),
            label: Text(
              _isOptimizing ? 'Optimizing...' : 'Apply Optimizations',
              style: TextStyle(fontSize: 16.sp),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2B3691),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        OutlinedButton.icon(
          onPressed: _isLoading ? null : _loadHardwareInfo,
          icon: Icon(Icons.refresh, size: 18.sp, color: Color(0xFF2B3691),),
          label: Text('Refresh', style: TextStyle(fontSize: 16.sp, color: Color(0xFF2B3691),)),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: Color(0xFF033D20)),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF033D20),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: valueColor ?? Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTierDisplayName(HardwareTier tier) {
    switch (tier) {
      case HardwareTier.budget:
        return 'Budget (2-4GB Buffer)';
      case HardwareTier.standard:
        return 'Standard (4-8GB Buffer)';
      case HardwareTier.enterprise:
        return 'Enterprise (12GB+ Buffer)';
    }
  }
}