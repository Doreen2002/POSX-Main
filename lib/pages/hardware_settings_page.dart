import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/pages/items_cart.dart';
import 'package:offline_pos/widgets_components/backup_settings_section.dart';
import '../common_utils/app_colors.dart';
import '../widgets_components/cash_drawer_section.dart';
import '../widgets_components/receipt_printer_section.dart';
import '../widgets_components/vfd_display_section.dart';
import '../widgets_components/hardware_optimization_panel.dart';

class HardwareSettingsPage extends StatelessWidget {
  const HardwareSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
         bool isHomePage =
                      ModalRoute.of(context)?.settings.name == 'CartItemScreen';

                  if (!isHomePage) {
                    Navigator.push(
                      context,
                      _noAnimationRoute(
                        CartItemScreen(runInit: false),
                        name: 'CartItemScreen',
                      ),
                    );
                  }
         
        },
      ),


        title: 
            Container(
              decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF018644), Color(0xFF033D20)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
          children: [
            
            Icon(Icons.settings, size: 20.sp, color: Colors.white),
            SizedBox(width: 8.w),
            const Text('Hardware Settings', style: TextStyle(color: Colors.white),),
        
          ]
          
        ),
            )
            
         
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 16.h),
            const HardwareOptimizationPanel(),
            SizedBox(height: 16.h),
            const ReceiptPrinterSection(),
            SizedBox(height: 16.h), 
            const VFDDisplaySection(),
            SizedBox(height: 16.h),
            const CashDrawerSection(),
            SizedBox(height: 16.h),
            const BackupSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: 600.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configure Hardware & Backups',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF033D20)
            )
          ),
          SizedBox(height: 6.h),
          Text(
            'Receipt printers, VFD, cash drawer and local MariaDB backup settings.',
            style: TextStyle(
              fontSize: 8.sp,
              color: Colors.grey.shade700
            )
          ),
        ],
      ),
    );
  }
}

Route _noAnimationRoute(Widget page, {String? name}) {
  return PageRouteBuilder(
    settings: name != null ? RouteSettings(name: name) : null,
    pageBuilder: (_, __, ___) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}