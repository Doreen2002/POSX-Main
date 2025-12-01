import 'dart:async';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

Future<bool> createModeOfPaymentTable() async {
 bool isCreatedDB = false;
  final db = await getDatabase();
  try {
   
    await db.query("CREATE TABLE IF NOT EXISTS ModeOfPayment (name varchar(255) PRIMARY KEY)");
    isCreatedDB = true;
    
  } catch (e) {
    logErrorToFile("Error creating mode of payment  table $e");
    isCreatedDB = false;
  }
  finally
  {
    await db.close();
  }
  
  return isCreatedDB;
}

Future<bool> deleteAllModeOfPayment(ids) async {
  bool isDeleted = false;
  final db = await getDatabase();
  try {
    if(ids.isNotEmpty)
    {
   
    final placeholders = List.filled(ids.length, '?').join(', ');

    
    await db.query(
        "DELETE FROM ModeOfPayment WHERE name NOT IN ($placeholders)",
        ids,
      );

    isDeleted = true;
 
    }
  } catch (e) {
    logErrorToFile("Error deleting ModeOfPayment records: $e");
    isDeleted = false;
  }
   finally
  {
    await db.close();
  }

  return isDeleted;
}

Future<bool> deleteAllUser() async {
  bool isDeleted = false;
    final db = await getDatabase();
  try {
  

    
    await db.query("DELETE FROM User;");

    isDeleted = true;
  
  } catch (e) {
    logErrorToFile("Error deleting User records: $e");
    isDeleted = false;
  }
  finally
  {
    await db.close();
  }

  return isDeleted;
}
Future<bool> deleteAllPOSProfile() async {
  bool isDeleted = false;
  final db = await getDatabase();
  try {
    

    
    await db.query("DELETE FROM POSProfile;");

    isDeleted = true;
   
  } catch (e) {
    logErrorToFile("Error deleting POSProfile records: $e");
    isDeleted = false;
  }
  finally
  {
     await db.close();
  }

  return isDeleted;
}


Future<bool> deleteAllHoldCart() async {
  bool isDeleted = false;
     final db = await getDatabase();
  try {
 

    
    await db.query("DELETE FROM HoldCart;");
    await db.query("DELETE FROM HoldCartItem;");
    isDeleted = true;
    
  } catch (e) {
   logErrorToFile ("Error deleting User records: $e");
    isDeleted = false;
  }
  finally{
  await db.close();
  }

  return isDeleted;
}