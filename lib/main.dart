import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'services/simple_hardware_optimizer.dart';
import 'services/vfd_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();
  await initializeDateFormatting();

  // Initialize hardware optimization in background
  _initializeHardwareOptimization();
  
  // Initialize VFD in background
  _initializeVFD();

  // WindowOptions windowOptions = const WindowOptions(
  //   size: Size(1280, 720),
  //   center: true,
  //   skipTaskbar: false,
  //   titleBarStyle: TitleBarStyle.hidden,
  // );

  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.maximize();
  //   await windowManager.setFullScreen(true);
  //   await windowManager.show();
  // });

  runApp(
    RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      // onKey: (event) async {
      //   if (event is RawKeyDownEvent &&
      //       event.logicalKey == LogicalKeyboardKey.f11) {
      //     bool isFullScreen = await windowManager.isFullScreen();
      //     if (isFullScreen) {
      //       // Exit fullscreen and show title bar
      //       await windowManager.setFullScreen(false);
      //       await windowManager.setTitleBarStyle(TitleBarStyle.normal);
      //       await windowManager.setSize(const Size(1280, 720));
      //       await windowManager.center();
      //     } else {
      //       // Enter fullscreen and hide title bar
      //       await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      //       await windowManager.setFullScreen(true);
      //     }
      //   }
      // },
      child: MyApp(),
    ),
  );
}

/// Initialize hardware optimization in background
/// This runs asynchronously to avoid blocking app startup
void _initializeHardwareOptimization() {
  // Run in background - don't await to avoid blocking startup
  () async {
    try {
      debugPrint('[PosX] Starting background hardware optimization...');
      
      // Detect hardware
      final hardware = await SimpleHardwareOptimizer.detectHardware();
      debugPrint('[PosX] Hardware detected: ${hardware.summary}');
      
      // Generate MariaDB configuration 
      final mariadbConfig = await SimpleHardwareOptimizer.generateMariaDBConfig(hardware);
      debugPrint('[PosX] MariaDB config generated: ${mariadbConfig.summary}');
      
      // Apply optimizations with safety mechanisms
      final result = await SimpleHardwareOptimizer.applyOptimizations();
      if (result.success) {
        debugPrint('[PosX] Background hardware optimization complete: ${result.message}');
      } else {
        debugPrint('[PosX] Background hardware optimization failed: ${result.message}');
      }
      
    } catch (e) {
      debugPrint('[PosX] Background hardware optimization failed: $e');
    }
  }();
}

/// Initialize VFD customer display in background
/// This runs asynchronously to avoid blocking app startup
void _initializeVFD() {
  // Run in background - don't await to avoid blocking startup
  () async {
    try {
      debugPrint('[VFD] Starting VFD initialization...');
      
      final result = await VFDService.instance.initialize();
      
      if (result) {
        debugPrint('[VFD] VFD initialized successfully');
      } else {
        debugPrint('[VFD] VFD initialization skipped (disabled or no hardware)');
      }
      
    } catch (e) {
      debugPrint('[VFD] VFD initialization failed: $e');
    }
  }();
}
