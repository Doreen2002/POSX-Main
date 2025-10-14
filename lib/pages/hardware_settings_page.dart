import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common_utils/app_colors.dart';
import '../widgets_components/hardware_optimization_panel.dart';

/// Hardware Settings Page
/// Provides access to hardware optimization and system configuration
class HardwareSettingsPage extends StatelessWidget {
  const HardwareSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.settings, size: 24.sp, color: Colors.white),
            SizedBox(width: 8.w),
            const Text(
              'Hardware Settings',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: AppColors.appbarGreen,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Container(
              padding: EdgeInsets.all(16.w),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Configure Hardware Devices',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.appbarGreen,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Set up receipt printers, VFD displays, cash drawers, and database performance.',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Database Optimization Section (Collapsible)
            Container(
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
                    Icons.storage,
                    color: AppColors.appbarGreen,
                    size: 28.sp,
                  ),
                  title: Text(
                    'Database Optimization',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.appbarGreen,
                    ),
                  ),
                  subtitle: Text(
                    'Hardware detection & MariaDB tuning',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  children: [
                    // Info box
                    Container(
                      padding: EdgeInsets.all(12.w),
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue, size: 20.sp),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Automatically detects hardware and optimizes MariaDB. Applied on startup.',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Hardware Optimization Panel
                    const HardwareOptimizationPanel(),
                    
                    SizedBox(height: 16.h),
                    
                    // Optimization Guide
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.help_outline, size: 18.sp, color: AppColors.appbarGreen),
                              SizedBox(width: 8.w),
                              Text(
                                'Tier Guide',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.appbarGreen,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          _buildGuideItem(
                            'Budget Tier (2-4GB RAM)',
                            'Basic POS operations',
                          ),
                          _buildGuideItem(
                            'Standard Tier (8GB+ RAM)',
                            'Medium-scale operations',
                          ),
                          _buildGuideItem(
                            'Enterprise Tier (12GB+ RAM)',
                            'Large-scale operations',
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.warning_amber, color: Colors.orange, size: 18.sp),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'Backups are created automatically before optimization.',
                                    style: TextStyle(
                                      color: Colors.orange.shade700,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Receipt Printer Section
            _ReceiptPrinterSection(),
            
            SizedBox(height: 16.h),
            
            // VFD Display Section
            _VFDDisplaySection(),
            
            SizedBox(height: 16.h),
            
            // Cash Drawer Section
            _CashDrawerSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            margin: EdgeInsets.only(top: 6.h, right: 12.w),
            decoration: BoxDecoration(
              color: AppColors.appbarGreen,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/// Receipt Printer Configuration Section
class _ReceiptPrinterSection extends StatefulWidget {
  const _ReceiptPrinterSection();

  @override
  State<_ReceiptPrinterSection> createState() => _ReceiptPrinterSectionState();
}

class _ReceiptPrinterSectionState extends State<_ReceiptPrinterSection> {
  List<String> _availablePrinters = [];
  String? _selectedPrinter;
  bool _silentPrintEnabled = false;
  bool _autoPrintEnabled = false;
  bool _isScanning = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _footerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // TODO: Load from UserPreference
    // _selectedPrinter = UserPreference.getString(PrefKeys.receiptPrinterUrl);
    // _silentPrintEnabled = UserPreference.getBool(PrefKeys.silentPrintEnabled) ?? false;
    // _autoPrintEnabled = UserPreference.getBool(PrefKeys.autoPrintReceipt) ?? false;
    // _phoneController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? '';
    // _footerController.text = UserPreference.getString(PrefKeys.receiptFooterText) ?? '';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _footerController.dispose();
    super.dispose();
  }

  Future<void> _scanPrinters() async {
    setState(() => _isScanning = true);
    
    try {
      // TODO: Implement printer scanning using printing package
      // final printers = await Printing.listPrinters();
      // setState(() {
      //   _availablePrinters = printers.map((p) => p.name).toList();
      // });
      
      // Temporary mock data for UI testing
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _availablePrinters = ['Default Printer', 'Epson TM-T20', 'Star TSP143'];
      });
    } catch (e) {
      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scanning printers: $e')),
        );
      }
    } finally {
      setState(() => _isScanning = false);
    }
  }

  void _testPrint() {
    // TODO: Implement test print with barcode+QR
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test print sent')),
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
            Icons.print,
            color: AppColors.appbarGreen,
            size: 28.sp,
          ),
          title: Text(
            'Receipt Printer',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.appbarGreen,
            ),
          ),
          subtitle: Text(
            _selectedPrinter ?? 'No printer configured',
            style: TextStyle(
              fontSize: 14.sp,
              color: _selectedPrinter != null ? Colors.grey.shade600 : Colors.red.shade400,
            ),
          ),
          children: [
            // Scan Printers Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isScanning ? null : _scanPrinters,
                icon: _isScanning
                    ? SizedBox(
                        width: 16.w,
                        height: 16.h,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search),
                label: Text(_isScanning ? 'Scanning...' : 'Scan for Printers'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appbarGreen,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Printer Dropdown
            if (_availablePrinters.isNotEmpty) ...[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  value: _selectedPrinter,
                  hint: Row(
                    children: [
                      Icon(Icons.print, size: 20.sp, color: Colors.grey),
                      SizedBox(width: 8.w),
                      const Text('Select a printer'),
                    ],
                  ),
                  items: _availablePrinters.map((printer) {
                    return DropdownMenuItem<String>(
                      value: printer,
                      child: Row(
                        children: [
                          Icon(
                            Icons.print,
                            size: 20.sp,
                            color: _selectedPrinter == printer
                                ? AppColors.appbarGreen
                                : Colors.grey,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(child: Text(printer)),
                          if (_selectedPrinter == printer)
                            Icon(
                              Icons.check_circle,
                              size: 20.sp,
                              color: AppColors.appbarGreen,
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedPrinter = value);
                    // TODO: Save to UserPreference
                    // UserPreference.putString(PrefKeys.receiptPrinterUrl, value ?? '');
                  },
                ),
              ),
              
              SizedBox(height: 16.h),
            ],
            
            // Silent Print Toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SwitchListTile(
                value: _silentPrintEnabled,
                onChanged: (value) {
                  setState(() => _silentPrintEnabled = value);
                  // TODO: Save to UserPreference
                  // UserPreference.putBool(PrefKeys.silentPrintEnabled, value);
                },
                title: Text(
                  'Silent Print',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Print without showing OS dialog',
                  style: TextStyle(fontSize: 13.sp),
                ),
                activeColor: AppColors.appbarGreen,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // Auto-Print Toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SwitchListTile(
                value: _autoPrintEnabled,
                onChanged: (value) {
                  setState(() => _autoPrintEnabled = value);
                  // TODO: Save to UserPreference
                  // UserPreference.putBool(PrefKeys.autoPrintReceipt, value);
                },
                title: Text(
                  'Auto-Print on Payment',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Automatically print receipt after payment',
                  style: TextStyle(fontSize: 13.sp),
                ),
                activeColor: AppColors.appbarGreen,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Phone Number Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone Number',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Enter phone number for receipts',
                      prefixIcon: Icon(Icons.phone, color: AppColors.appbarGreen),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      // TODO: Save to UserPreference
                      // UserPreference.putString(PrefKeys.receiptPhoneNumber, value);
                    },
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Footer Text Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receipt Footer',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _footerController,
                    decoration: InputDecoration(
                      hintText: 'Enter custom footer text (e.g., "Thank you for your business!")',
                      prefixIcon: Icon(Icons.notes, color: AppColors.appbarGreen),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      counterText: '', // Hide character counter
                    ),
                    maxLines: 3,
                    minLines: 2,
                    maxLength: 200,
                    onChanged: (value) {
                      // TODO: Save to UserPreference
                      // UserPreference.putString(PrefKeys.receiptFooterText, value);
                    },
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Test Print Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _selectedPrinter != null ? _testPrint : null,
                icon: const Icon(Icons.check),
                label: const Text('Test Print (Barcode + QR)'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.appbarGreen,
                  side: BorderSide(color: AppColors.appbarGreen),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
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
    // TODO: Load from UserPreference
    // _vfdEnabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? false;
    // _comPort = UserPreference.getString(PrefKeys.vfdComPort) ?? 'COM1';
    // _baudRate = UserPreference.getInt(PrefKeys.vfdBaudRate) ?? 9600;
    // _dataBits = UserPreference.getInt(PrefKeys.vfdDataBits) ?? 8;
    // _stopBits = UserPreference.getInt(PrefKeys.vfdStopBits) ?? 1;
    // _parity = UserPreference.getString(PrefKeys.vfdParity) ?? 'None';
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
                onChanged: (value) {
                  setState(() => _vfdEnabled = value);
                  // TODO: Save to UserPreference
                  // UserPreference.putBool(PrefKeys.vfdEnabled, value);
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
                        onChanged: (value) {
                          setState(() => _comPort = value!);
                          // TODO: Save to UserPreference
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
                        onChanged: (value) {
                          setState(() => _baudRate = value!);
                          // TODO: Save to UserPreference
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
                        onChanged: (value) {
                          setState(() => _dataBits = value!);
                          // TODO: Save to UserPreference
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
                        onChanged: (value) {
                          setState(() => _stopBits = value!);
                          // TODO: Save to UserPreference
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
                        onChanged: (value) {
                          setState(() => _parity = value!);
                          // TODO: Save to UserPreference
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
                        onChanged: (value) {
                          setState(() => _connectionType = value!);
                          // TODO: Save to UserPreference
                          // UserPreference.putString(PrefKeys.cashDrawerConnectionType, value!);
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
                        onChanged: (value) {
                          setState(() => _connectionType = value!);
                          // TODO: Save to UserPreference
                          // UserPreference.putString(PrefKeys.cashDrawerConnectionType, value!);
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
