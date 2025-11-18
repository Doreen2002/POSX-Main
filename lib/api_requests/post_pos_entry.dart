import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/database_conn/insert_pos.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/globals/global_values.dart';
Future<bool> openPosRequest(String httpType, String frappeInstance, bool insertIndb, dynamic posOpeningEntry) async {


  try {
    final openingAmount = posOpeningEntry['balance_details'][0]["opening_amount"];
    if(insertIndb)
    {
      await insertTablePosOpening(posOpeningEntry['naming_series'], posOpeningEntry['user'], posOpeningEntry['period_start_date'], posOpeningEntry['period_start_date'], "Open", posOpeningEntry['period_start_date'], posOpeningEntry['company'], posOpeningEntry['pos_profile'], "", "Cash", double.tryParse(openingAmount));
    }
    
    final posSessionResponse = await http.post(
      Uri.parse('$transferProtocol://$frappeInstance/api/resource/POS Opening Entry'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
      body: jsonEncode({
        'pos_profile': posOpeningEntry['pos_profile'],
        'company': posOpeningEntry['company'],
        'user':posOpeningEntry['user'],
        'naming_series': posOpeningEntry['naming_series'],
        'period_start_date': posOpeningEntry['period_start_date'],
        'balance_details':posOpeningEntry['balance_details'],
        "docstatus":1,
        "custom_created_from_posx":1
      }),
    );

    if (posSessionResponse.statusCode == 200) {
     
      final posSessionBody = jsonDecode(posSessionResponse.body);
     
      if (posSessionBody['data'] != {}) {
        await updatePosOpeningSync(posOpeningEntry['naming_series'], "Synced",posSessionBody['data']['name'] );

        
      }
      await fetchFromPosOpening();
      return false;
    } else {
      logErrorToFile("❌ Failed to open POS session: ${posSessionResponse.statusCode}, body: ${posSessionResponse.body}");
      return false;
    }
    
  } catch (e) {
    // Handle any exceptions that occur
    logErrorToFile("❌ Error occurred open pos request: $e");
    return false;
  }
}


Future<bool> closePosRequest( dynamic posClosing) async {

  final frappeInstance = UserPreference.getString(PrefKeys.baseUrl) ?? "";

  try {
    
    final posSessionResponse = await http.post(
      Uri.parse('$transferProtocol://$frappeInstance/api/method/offline_pos_erpnext.API.sales.create_pos_closing_entry'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
      body: jsonEncode({
       'data':{
         'pos_profile': posClosing['pos_profile'],
        'company': posClosing['company'],
        'user':posClosing['user'],
        'period_end_date': posClosing['period_end_date'],
        "naming_series": posClosing['naming_series'],
        'period_start_date': posClosing['period_start_date'],
        'pos_opening_entry':  posClosing['pos_opening_entry'],
        'pos_opening_amount':posClosing['pos_opening_amount'],
        'payment_reconciliation':posClosing['payment_reconciliation'],
        'denomination_entries': posClosing['denomination_entries'],
        'total_denomination_value': posClosing['total_denomination_value'],
        'comment':posClosing['comment']
        
       }
      }),
    );

    if (posSessionResponse.statusCode == 200) {
     
      final posSessionBody = jsonDecode(posSessionResponse.body);
      if (posSessionBody['message'] != {}) {
        await updatePosClosingSync(posClosing['naming_series'], "Synced",posSessionBody['message']['name'] );

        // final conn =  await dbqueryRequestOpen(); 
        // await  UserPreference.getInstance();
        // await UserPreference.putString(PrefKeys.paymentMode, posSessionBody['data']['balance_details'][0]['mode_of_payment']);
        // await UserPreference.putString(PrefKeys.openingAmount, posSessionBody['data']['balance_details'][0]['opening_amount']);
        // await  insertTablePosOpening(conn, posSessionBody['data']['name'], posSessionBody['data']['user'], posSessionBody['data']['period_start_date'], posSessionBody['data']['period_end_date'], posSessionBody['data']['status'], posSessionBody['data']['posting_date'], posSessionBody['data']['company'], posSessionBody['data']['pos_profile'], posSessionBody['data']['pos_closing_entry'],posSessionBody['data']['balance_details'][0]['mode_of_payment'],posSessionBody['data']['balance_details'][0]['opening_amount'] );
        // await dbqueryRequestClose(conn);
        // return true;
      }
      return false;
    } else {
      logErrorToFile("❌ Failed to open POS session: ${posSessionResponse.statusCode}, body: ${posSessionResponse.body}");
      return false;
    }
    
  } catch (e) {
    // Handle any exceptions that occur
    logErrorToFile("❌ Error occurred open pos request: $e");
    return false;
  }
}