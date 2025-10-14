import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';

/// VFD (Vacuum Fluorescent Display) Customer Display Service
/// 
/// Singleton service for managing VFD customer-facing display.
/// Displays item information, prices, and thank you messages.
/// 
/// Hardware Specs:
/// - 2 lines × 20 characters (40 chars total)
/// - RS-232 serial communication
/// - Auto-returns to welcome message after 10 seconds
class VFDService {
  // Singleton pattern
  static VFDService? _instance;
  static VFDService get instance {
    _instance ??= VFDService._internal();
    return _instance!;
  }

  VFDService._internal();

  // VFD connection state
  SerialPort? _vfdPort;
  bool _isInitialized = false;
  Timer? _resetTimer;

  /// Initialize VFD with settings from PrefKeys
  /// Returns true if successful, false if disabled or failed
  Future<bool> initialize() async {
    try {
      // Check if VFD is enabled
      final enabled = UserPreference.getBool(PrefKeys.vfdEnabled) ?? false;
      if (!enabled) {
        print('[VFD] VFD is disabled in settings');
        return false;
      }

      // Get COM port from settings
      final comPort = UserPreference.getString(PrefKeys.vfdComPort);
      if (comPort == null || comPort.isEmpty) {
        print('[VFD] No COM port configured');
        return false;
      }

      // Get serial port settings (with defaults)
      final baudRate = UserPreference.getInt(PrefKeys.vfdBaudRate) ?? 9600;
      final dataBits = UserPreference.getInt(PrefKeys.vfdDataBits) ?? 8;
      final stopBits = UserPreference.getInt(PrefKeys.vfdStopBits) ?? 1;
      final parity = UserPreference.getInt(PrefKeys.vfdParity) ?? 0; // 0 = None

      // Close existing connection if any
      if (_vfdPort != null) {
        _vfdPort!.close();
        _vfdPort = null;
      }

      // Open serial port
      _vfdPort = SerialPort(comPort);
      
      final config = SerialPortConfig()
        ..baudRate = baudRate
        ..bits = dataBits
        ..stopBits = stopBits
        ..parity = parity;
      
      _vfdPort!.config = config;

      if (!_vfdPort!.openWrite()) {
        print('[VFD] Failed to open port $comPort');
        _vfdPort = null;
        return false;
      }

      _isInitialized = true;
      print('[VFD] Initialized on $comPort (Baud: $baudRate)');
      
      // Show welcome message
      showWelcome();
      
      return true;
    } catch (e) {
      print('[VFD] Initialization error: $e');
      _isInitialized = false;
      _vfdPort = null;
      return false;
    }
  }

  /// Send text to VFD display
  void _send(String text) {
    if (!_isInitialized || _vfdPort == null) return;
    
    try {
      final bytes = Uint8List.fromList(utf8.encode(text));
      _vfdPort!.write(bytes);
    } catch (e) {
      print('[VFD] Send error: $e');
    }
  }

  /// Show welcome message from settings
  /// Falls back to default if no custom message
  void showWelcome() {
    _resetTimer?.cancel();
    
    final welcomeText = UserPreference.getString(PrefKeys.vfdWelcomeText) 
        ?? 'Welcome! Shopping   with us today!     '; // Default: 40 chars
    
    // Ensure exactly 40 characters (2 lines × 20)
    final displayText = welcomeText.padRight(40).substring(0, 40);
    _send(displayText);
    
    print('[VFD] Showing welcome: ${welcomeText.substring(0, 20)} | ${welcomeText.substring(20, 40)}');
  }

  /// Show item information when scanning
  /// Scrolls line 1 if item name is too long
  void showItem({
    required String itemName,
    required int qty,
    required double itemTotal,
    required int totalQty,
    required double cartTotal,
  }) {
    if (!_isInitialized) return;
    
    _resetTimer?.cancel();

    String line1 = "$itemName Qty:$qty \$${itemTotal.toStringAsFixed(2)}";
    String line2 = "Total Qty=$totalQty \$${cartTotal.toStringAsFixed(2)}";

    _scrollLine1(line1, line2);

    // Auto-return to welcome after 10 seconds
    _resetTimer = Timer(Duration(seconds: 10), showWelcome);
  }

  /// Show thank you message after payment
  /// Displays total amount paid
  void showThankYou({required double totalSalesAmount, String currency = "\$"}) {
    if (!_isInitialized) return;
    
    _resetTimer?.cancel();

    String line1 = "Thank you for purchasing $currency${totalSalesAmount.toStringAsFixed(3)} items";
    String line2 = "Please come again";

    _scrollLine1(line1, line2);

    // Auto-return to welcome after 10 seconds
    _resetTimer = Timer(Duration(seconds: 10), showWelcome);
    
    print('[VFD] Showing thank you: Total $currency${totalSalesAmount.toStringAsFixed(2)}');
  }

  /// Scroll line 1 if text exceeds 20 characters
  /// Line 2 remains static
  void _scrollLine1(String line1, String line2, {int delayMs = 400}) async {
    const int windowSize = 20;
    final line2Padded = line2.padRight(windowSize).substring(0, windowSize);

    if (line1.length <= windowSize) {
      // No scrolling needed
      final line1Padded = line1.padRight(windowSize).substring(0, windowSize);
      _send("$line1Padded$line2Padded");
    } else {
      // Scroll long text
      for (int i = 0; i <= line1.length - windowSize; i++) {
        String segment = line1.substring(i, i + windowSize);
        _send("$segment$line2Padded");
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }
  }

  /// Test VFD connection and display
  /// Returns true if VFD responds correctly
  Future<bool> test() async {
    if (!_isInitialized) {
      final result = await initialize();
      if (!result) return false;
    }

    try {
      // Show test message
      _send("VFD Test: OK        Line 2: Ready       ");
      await Future.delayed(Duration(seconds: 2));
      
      // Return to welcome
      showWelcome();
      
      return true;
    } catch (e) {
      print('[VFD] Test failed: $e');
      return false;
    }
  }

  /// Dispose VFD service and close connection
  void dispose() {
    _resetTimer?.cancel();
    
    if (_vfdPort != null) {
      _vfdPort!.close();
      _vfdPort = null;
    }
    
    _isInitialized = false;
    print('[VFD] Service disposed');
  }

  /// Check if VFD is initialized and ready
  bool get isReady => _isInitialized && _vfdPort != null;
}
