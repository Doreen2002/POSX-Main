// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../common_utils/app_colors.dart';
// import '../widgets_components/hardware_optimization_panel.dart';
// import '../widgets_components/auto_persist.dart';
// import '../data_source/local/user_preference.dart';
// import '../data_source/local/pref_keys.dart';
// import '../services/backup_credential_writer.dart';
// import '../services/backup_scheduler.dart';

// /// Clean, consolidated Hardware Settings Page (temporary new file)
// class HardwareSettingsPageNew extends StatelessWidget {
//   const HardwareSettingsPageNew({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: Row(children: [Icon(Icons.settings, size: 24.sp, color: Colors.white), SizedBox(width: 8.w), const Text('Hardware Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
//         backgroundColor: AppColors.appbarGreen,
//         elevation: 2,
//         leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.w),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           _headerCard(),
//           SizedBox(height: 16.h),
//           _databaseOptimizationCard(),
//           SizedBox(height: 16.h),
//           _ReceiptPrinterSection(),
//           SizedBox(height: 16.h),
//           _VFDDisplaySection(),
//           SizedBox(height: 16.h),
//           _CashDrawerSection(),
//           SizedBox(height: 16.h),
//           _BackupSettingsSection(),
//         ]),
//       ),
//     );
//   }

//   Widget _headerCard() {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Text('Configure Hardware Devices', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.appbarGreen)),
//         SizedBox(height: 8.h),
//         Text('Set up receipt printers, VFD displays, cash drawers, and database performance.', style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700, height: 1.4)),
//       ]),
//     );
//   }

//   Widget _databaseOptimizationCard() {
//     return Container(
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 2))]),
//       child: Theme(
//         data: ThemeData(dividerColor: Colors.transparent, splashColor: Colors.grey.shade100),
//         child: ExpansionTile(
//           initiallyExpanded: false,
//           tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//           childrenPadding: EdgeInsets.all(16.w),
//           leading: Icon(Icons.storage, color: AppColors.appbarGreen, size: 28.sp),
//           title: Text('Database Optimization', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: AppColors.appbarGreen)),
//           subtitle: Text('Hardware detection & MariaDB tuning', style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
//           children: [
//             Container(padding: EdgeInsets.all(12.w), margin: EdgeInsets.only(bottom: 16.h), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: Colors.blue.shade200)), child: Row(children: [Icon(Icons.info_outline, color: Colors.blue, size: 20.sp), SizedBox(width: 8.w), Expanded(child: Text('Automatically detects hardware and optimizes MariaDB. Applied on startup.', style: TextStyle(color: Colors.blue.shade700, fontSize: 14.sp)))])),
//             const HardwareOptimizationPanel(),
//           ],
//         ),
//       ),
//     );
//   }
// }
