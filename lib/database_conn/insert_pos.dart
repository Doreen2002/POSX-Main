import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:offline_pos/models/pos_profile_model.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

Future<dynamic> insertTablePosProfile({List<TempPOSProfileModel>? d}) async {
  int disabledValue = 0;
  try {
    
    dynamic res;
    final conn = await getDatabase();
    for (var element in d!) {
      disabledValue = element.disabled == null ? 0 : 1;
      final updateStock = element.updateStock == null ? 0 : 1;
      var insertItemQuery = 'INSERT INTO POSProfile (name,company,customer,country,disabled,warehouse,update_stock,currency)';
      res = await conn.query('''$insertItemQuery VALUES('${element.name}','${element.company}','${element.customer}','${element.country}','${disabledValue}','${element.warehouse}','${updateStock}','${element.currency}')''');
      
    }
    await conn.close();
    return res;
  } catch (e) {
   logErrorToFile("Error inserting data into Pos Profile Table $e $disabledValue");
  }
}

Future<dynamic> insertTablePosOpening( String? name,String? user,String? periodStartDate,String? periodEndDate,String? status,String? postingDate,String? company,String? posProfile,String? posClosingEntry,String? paymentMode,double? amount) async {
  try {
    final conn = await getDatabase();
    dynamic res;

      var insertItemQuery = 'INSERT  INTO PosOpening (name,user,period_start_date,period_end_date,status,posting_date,company,pos_profile,pos_closing_entry,paymentMode,amount) ';
      res = await conn.query('''$insertItemQuery VALUES('$name','$user','$periodStartDate','$periodEndDate','$status','$postingDate','$company','$posProfile','$posClosingEntry','$paymentMode','$amount')''');
    
    await conn.close();
    return res;
  } catch (e) {
    logErrorToFile("Error inserting data into Pos opening Table $e");
  }
}

Future<bool> insertPosClosingCurrencyDenomination({
  required String posClosing,
  required double denominationValue,
  required double totalDenominationValue,
  required int count,
}) async {
  try {
    final conn = await getDatabase();
    await conn.query(
      "INSERT INTO PosClosingCurrencyDenomination ( pos_closing, denomination_value, total_denomination_value, count) VALUES ( ?, ?, ?, ?)",
      [ posClosing, denominationValue, totalDenominationValue, count],
    );
    await conn.close();
    return true;
  } catch (e) {
    logErrorToFile("Error inserting into PosClosingCurrencyDenomination: $e");
    return false;
  }
}

Future<bool> insertCashDrawer({
  required String username,
  required String datetime
}) async {
  try {
    final conn = await getDatabase();
    await conn.query(
      "INSERT INTO CashDrawer ( username, datetime) VALUES (?, ?)",
      [username, datetime],
    );
    await conn.close();
    return true;
  } catch (e) {
    logErrorToFile("Error inserting into CashDrawer: $e");
    return false;
  }
}


Future<dynamic> insertTablePosClosing( String? name,String? user,String? periodStartDate,String? periodEndDate,String? postingDate,String? company,String? posProfile,String? posOpeningEntry,String? paymentMode,double? amount, double? closinginAmount, String syncStatus, double totalDenomination, String? comment) async {
  try {
    final conn = await getDatabase();
    dynamic res;

      var insertItemQuery = 'INSERT  INTO PosClosing (name,user,period_start_date,period_end_date,posting_date,company,pos_profile,pos_opening_entry,opening_entry_amount,closing_amount, sync_status, total_denomination_value, comment) ';
      res = await conn.query('''$insertItemQuery VALUES('$name','$user','$periodStartDate','$periodEndDate','$postingDate','$company','$posProfile','$posOpeningEntry','$amount','$closinginAmount', '$syncStatus', '$totalDenomination', '$comment' )''');
   
    await conn.close();
    return true;
  } catch (e) {
    logErrorToFile("Error inserting data into Pos closing Table $e");
  }
}

Future<dynamic> updatePosOpeningStatus( String? name, String closingID,  context, date ) async {
  try {
    final conn = await getDatabase();
    dynamic res;

      var insertItemQuery = "UPDATE PosOpening  SET status = 'Closed', period_end_date = '$date', pos_closing_entry = '$closingID'  WHERE name = '$name' ";
      res = await conn.query('''$insertItemQuery''');
     
    await conn.close();
    return res;
  } catch (e) {
    logErrorToFile("Error updating data into Pos opening Table $e $name");
  }
}

Future<dynamic> updatePosOpening( String? name,double? amount, context) async {
  try {
    final conn = await getDatabase();
    dynamic res;

      var insertItemQuery = "UPDATE PosOpening  SET amount = $amount WHERE name = '$name' ";
      res = await conn.query('''$insertItemQuery''');
     
    await conn.close();
    Navigator.pop(context);
    return res;
  } catch (e) {
    logErrorToFile("Error updating data into Pos opening Table $e $name $amount");
  }
}


Future<dynamic> updatePosOpeningSync( String? name,String? status, String id) async {
  try {
    final conn = await getDatabase();
    dynamic res;

      var insertItemQuery = "UPDATE PosOpening  SET sync_status = '$status', erpnext_id = '$id' WHERE name = '$name' ";
      res = await conn.query('''$insertItemQuery''');
     
    await conn.close();
    return res;
  } catch (e) {
    logErrorToFile("Error updating data into Pos opening Table $e $name $status");
  }
}

Future<dynamic> updatePosClosingSync( String? name,String? status, String erpnext) async {
  try {
    final conn = await getDatabase();
    dynamic res;

      var insertItemQuery = "UPDATE PosClosing  SET sync_status = '$status', erpnext_id='$erpnext' WHERE name = '$name' ";
      res = await conn.query('''$insertItemQuery''');
      
    await conn.close();
    return res;
  } catch (e) {
    logErrorToFile("Error updating data into Pos opening Table $e $name $status");
  }
}