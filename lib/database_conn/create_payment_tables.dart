import 'dart:async';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

Future<bool> createModeOfPaymentTable() async {
 bool isCreatedDB = false;
  try {
    final db = await getDatabase();
    await db.query("CREATE TABLE IF NOT EXISTS ModeOfPayment (name varchar(255) PRIMARY KEY)");
    isCreatedDB = true;
    await db.close();
  } catch (e) {
    logErrorToFile("Error creating mode of payment  table $e");
    isCreatedDB = false;
  }
  
  return isCreatedDB;
}

Future<bool> deleteAllModeOfPayment(ids) async {
  bool isDeleted = false;
  try {
    if(ids.isNotEmpty)
    {
    final db = await getDatabase();
    final placeholders = List.filled(ids.length, '?').join(', ');

    
    await db.query(
        "DELETE FROM ModeOfPayment WHERE name NOT IN ($placeholders)",
        ids,
      );

    isDeleted = true;
    await db.close();
    }
  } catch (e) {
    logErrorToFile("Error deleting ModeOfPayment records: $e");
    isDeleted = false;
  }

  return isDeleted;
}

Future<bool> deleteAllUser() async {
  bool isDeleted = false;
  try {
    final db = await getDatabase();

    
    await db.query("DELETE FROM User;");

    isDeleted = true;
    await db.close();
  } catch (e) {
    logErrorToFile("Error deleting User records: $e");
    isDeleted = false;
  }

  return isDeleted;
}
Future<bool> deleteAllPOSProfile() async {
  bool isDeleted = false;
  try {
    final db = await getDatabase();

    
    await db.query("DELETE FROM POSProfile;");

    isDeleted = true;
    await db.close();
  } catch (e) {
    logErrorToFile("Error deleting POSProfile records: $e");
    isDeleted = false;
  }

  return isDeleted;
}


Future<bool> deleteAllHoldCart() async {
  bool isDeleted = false;
  try {
    final db = await getDatabase();

    
    await db.query("DELETE FROM HoldCart;");
    await db.query("DELETE FROM HoldCartItem;");
    isDeleted = true;
    await db.close();
  } catch (e) {
   logErrorToFile ("Error deleting User records: $e");
    isDeleted = false;
  }

  return isDeleted;
}