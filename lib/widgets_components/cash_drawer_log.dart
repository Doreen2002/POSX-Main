import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<File> _getCashDrawerLog() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/cash_drawer_log');
}

Future<void> logCashDrawerOpen(String val) async {
  try {
    final file = await _getCashDrawerLog();
    final now = DateTime.now();
    final timestamp = now.toIso8601String();
    await file.writeAsString('[$timestamp] $val\n', mode: FileMode.append);
  } catch (e) {
    debugPrint("Failed to write error: $e");
  }
}


