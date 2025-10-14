import 'dart:async';
import 'dart:typed_data';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/widgets_components/cash_drawer_log.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:printing/printing.dart';

/// Smart cash drawer opener - automatically uses correct connection method
/// based on configuration in UserPreference
Future<void> openCashDrawer() async {
  try {
    await UserPreference.getInstance();
    
    // Get connection type from settings (default: printer)
    String connectionType = UserPreference.getString(PrefKeys.cashDrawerConnectionType) ?? 'printer';
    
    if (connectionType == 'printer') {
      await _openViaPrinter();
    } else if (connectionType == 'direct') {
      await _openViaDirect();
    } else {
      logErrorToFile('Invalid cash drawer connection type: $connectionType');
    }
    
  } catch (e) {
    logErrorToFile('Failed to open cash drawer: $e');
  }
}

/// Method 1: Open via Receipt Printer (RJ11 connection)
/// Standard retail setup: PC -> Printer -> Cash Drawer
Future<void> _openViaPrinter() async {
  try {
    // Get selected printer from settings
    String? printerUrl = UserPreference.getString(PrefKeys.receiptPrinterUrl);
    if (printerUrl == null || printerUrl.isEmpty) {
      logErrorToFile('No printer configured, cannot open cash drawer');
      return;
    }

    // Find the printer
    List<Printer> printers = await Printing.listPrinters();
    Printer? selectedPrinter;
    
    for (var printer in printers) {
      if (printer.url == printerUrl) {
        selectedPrinter = printer;
        break;
      }
    }
    
    if (selectedPrinter == null) {
      logErrorToFile('Configured printer not found: $printerUrl');
      return;
    }

    // ESC/POS cash drawer kick command
    // 1B 70 00 19 FA = ESC p 0 25 250
    List<int> escPosCommand = [0x1B, 0x70, 0x00, 0x19, 0xFA];
    
    // Send raw bytes to printer (which triggers drawer via RJ11)
    await Printing.directPrintPdf(
      printer: selectedPrinter,
      onLayout: (format) async => Uint8List.fromList(escPosCommand),
    );

    // Log the event
    final user = UserPreference.getString(PrefKeys.fullName) ?? 'Unknown User';
    logCashDrawerOpen('Cash drawer opened via printer by $user');
    
  } catch (e) {
    logErrorToFile('Failed to open drawer via printer: $e');
  }
}

/// Method 2: Open via Direct USB-Serial Connection
/// Less common setup: PC -> USB -> Cash Drawer
/// This is the old implementation (kept for compatibility)
Future<void> _openViaDirect() async {
  try {
    final user = UserPreference.getString(PrefKeys.fullName) ?? 'Unknown User';
    
    // Find USB devices
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      logErrorToFile('No USB devices found for direct cash drawer connection');
      return;
    }

    // Use first USB device (could be enhanced to filter by vendor ID)
    final UsbDevice device = devices.first;
    final UsbPort? port = await device.create();
    
    if (port == null) {
      logErrorToFile('Failed to create USB port for cash drawer');
      return;
    }

    final bool opened = await port.open();
    if (!opened) {
      logErrorToFile('Failed to open USB port for cash drawer');
      return;
    }

    // Send DTR/RTS signals to trigger drawer
    await port.setDTR(true); 
    await port.setRTS(false);
    await port.setRTS(true);
    await Future.delayed(Duration(milliseconds: 120)); 
    await port.setRTS(false);
    
    logCashDrawerOpen('Cash drawer opened via direct USB by $user');
    
    await port.close();
  } catch (e) {
    logErrorToFile('Failed to open drawer via direct USB: $e');
  }
}

/// Legacy function name for backward compatibility
/// @deprecated Use openCashDrawer() instead
@Deprecated('Use openCashDrawer() instead')
Future<void> openDrawerViaUsbSerial() async {
  await openCashDrawer();
}
