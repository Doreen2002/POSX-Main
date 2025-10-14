import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<File> _getErrorFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/code_error.log');
}

Future<void> logErrorToFile(String error) async {
  try {
    final file = await _getErrorFile();
    final prefs = await SharedPreferences.getInstance();

    // Check last cleanup
    final lastCleanup = prefs.getString("lastCleanup");
    final now = DateTime.now();

    if (lastCleanup != null) {
      final lastDate = DateTime.parse(lastCleanup);
      if (now.difference(lastDate).inDays >= 10) {
        
        await file.writeAsString("", mode: FileMode.write);
        await prefs.setString("lastCleanup", now.toIso8601String());
      }
    } else {
      
      await prefs.setString("lastCleanup", now.toIso8601String());
    }

    // Append error
    final timestamp = now.toIso8601String();
    await file.writeAsString('[$timestamp] $error\n', mode: FileMode.append);
  } catch (e) {
    debugPrint("Failed to write error: $e");
  }
}


