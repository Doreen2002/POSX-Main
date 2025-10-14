import 'dart:convert';
import 'package:http/http.dart' as http;
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
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

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
  final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
 
  if (connectivityResult.isEmpty || connectivityResult.contains(ConnectivityResult.none)) {
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
    Uri.parse('https://${frappeInstance}/api/method/login'),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: 'usr=$encodedUsername&pwd=$encodedPassword',
  );
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    if (body is Map && body['message'] == 'Logged In') {
      await UserPreference.getInstance();
      UserPreference.putString(PrefKeys.userName, usr);
      UserPreference.putString(PrefKeys.password, pwd);
      UserPreference.putString(PrefKeys.baseUrl, frappeInstance);
      UserPreference.putString(PrefKeys.httpType, httpType);

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
      await createTableBatch();
      await createTableBarcode();
      await createTableSerial();
      await createHoldCartTable();
      await createHoldCartItemTable();
      await createLicenseTable();
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
      
      
      // await deleteAllUser();
      // await deleteAllPOSProfile();
      await posProfileRequest(
        "https",
        UserPreference.getString(PrefKeys.baseUrl)!,
        UserPreference.getString(PrefKeys.userName)!,
      );
        modeOfPaymentList.modeOfPaymentList = await fetchFromModeofPayment();
    
      UserPreference.putString(
        PrefKeys.cookies,
        response.headers['set-cookie'] ?? '',
      );
     
      Future.delayed(Duration(seconds: 10), ()async{
        await itemRequest(
      
      "https",
      UserPreference.getString(PrefKeys.baseUrl)!,
      UserPreference.getString(PrefKeys.userName)!,
    );
    await customerRequest(
      
      "https",
      UserPreference.getString(PrefKeys.baseUrl)!,
    );
      });
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
    print("Error in login request: $e");
    return false;
  }

}
