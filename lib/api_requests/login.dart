import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:offline_pos/api_requests/customer.dart';
import 'package:offline_pos/api_requests/items.dart';
import 'package:offline_pos/api_requests/pos.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offline_pos/database_conn/create_customer_table.dart';
import 'package:offline_pos/database_conn/create_item_tables.dart';
import 'package:offline_pos/database_conn/create_payment_tables.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/database_conn/dbsync.dart' as modeOfPaymentList;
import 'package:offline_pos/database_conn/get_payment.dart';
import 'package:offline_pos/database_conn/holdcart.dart';
import 'package:offline_pos/database_conn/licence_db.dart';
import 'package:offline_pos/database_conn/sales.dart';
import 'package:offline_pos/database_conn/users.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/globals/global_values.dart';
Future<bool> loginRequest(
  String httpType,
  String frappeInstance,
  String usr,
  String pwd,
) async {
 try{
    UserPreference.getInstance();

  UserPreference.putString(PrefKeys.baseUrl, frappeInstance);
  UserPreference.putString(PrefKeys.httpType, httpType);
   final encodedUsername = Uri.encodeQueryComponent(usr);
  final encodedPassword = Uri.encodeQueryComponent(pwd);
  bool hasInternet = await InternetConnection().hasInternetAccess;
 
  if (!hasInternet) {
    final List users = await fetchFromUser();
    if (users.isNotEmpty)
    {
      for (var savedUser in users)
      {
        if(savedUser.username == usr && savedUser.password == pwd)
        {
          
          return true;

        }
        else{
          return false;
        }
      }
    }
  }
  final response = await http.post(
    Uri.parse('$transferProtocol://${frappeInstance}/api/method/login'),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: 'usr=$encodedUsername&pwd=$encodedPassword',
  );
  if (response.statusCode == 200) {
    String _baseUsername = UserPreference.getString(PrefKeys.baseUrl) ?? "";
    String  _username =   UserPreference.getString(PrefKeys.userName) ?? "";
    final body = jsonDecode(response.body);
    if (body is Map && body['message'] == 'Logged In') {
      await UserPreference.getInstance();
      UserPreference.putString(
        PrefKeys.cookies,
        response.headers['set-cookie'] ?? '',
      );
      UserPreference.putString(PrefKeys.userName, usr);
      UserPreference.putString(PrefKeys.password, pwd);
      UserPreference.putString(PrefKeys.baseUrl, frappeInstance);
      UserPreference.putString(PrefKeys.httpType, httpType);

      await createMissingTables();
      
      final newDB = await  isNewDatabase();
      if ( newDB == true)
      {
        await UserPreference.getInstance();
        UserPreference.putBool('isOfflinePOSSetup', false);
      }
      else  if ( newDB == false)
      {
        await UserPreference.getInstance();
        UserPreference.putBool('isOfflinePOSSetup', true);
      }
      

      await posProfileRequest(
        "$transferProtocol",
        _baseUsername,
        _username
        
      );
      modeOfPaymentList.modeOfPaymentList = await fetchFromModeofPayment();
      
      return true;
    } else {
      logErrorToFile("⚠️ Login response was not 'Logged In': $body");
      return false;
    }
  } else {
    logErrorToFile(
      "❌ Failed with status: ${response.statusCode}, body: ${response.body}",
    );
    return false;
  }
 }
 catch(e){
    logErrorToFile("Error in login request: $e");
    return false;
  }

}


Future<void> createMissingTables()
async{
  await createModeOfPaymentTable();
      await createTablePosProfile();
      await createTableUser();
      await createTablePosOpening();
      await createTablePosClosing();
      await createTableCustomer();
      await createTableItem();
      await createSalesPersonTable();
      await createCurrencyDenominationTable();
      await createTablePosClosingCurrencyDenomination();
      await createTableCashDrawer();
      await createSalesInvoiceItemTable();
      await createSalesInvoiceTable();
      await createSalesInvoicePayment();
      await createTableItemPrice();
      await createTableUOM();
      await createTableBatch();
      await createTableBarcode();
      await createTableSerial();
      await createHoldCartTable();
      await createHoldCartItemTable();
      await createLicenseTable();
      await UpdateBarcodeTable();
}