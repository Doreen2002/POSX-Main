import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:offline_pos/database_conn/get_customer.dart';
import 'package:offline_pos/database_conn/insert_customer.dart';
import 'package:offline_pos/models/customer_list_model.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';


  final storage = FlutterSecureStorage();
Future<List<TempCustomerData>> customerRequest( String httpType, String frappeInstance) async {
  try {
    final response = await http.get(
      Uri.parse('https://${UserPreference.getString(PrefKeys.baseUrl)}/api/method/offline_pos_erpnext.API.customer.get_cutomers'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is Map && body['message'] != null) {
      
        List<TempCustomerData> items = [];
        for (var item in body['message']) {
          items.add(TempCustomerData.fromJson(item));
          await insertTableCustomer( d: [TempCustomerData.fromJson(item)]);
        }
        return items;
      } else {
        logErrorToFile("⚠️ No items found: $body");
        return [];
      }
    } else {
      logErrorToFile("❌ Failed to fetch customers: ${response.statusCode}, body: ${response.body}");
      return [];
    }
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}

Future<void> updateCustomerRequest( String httpType, String frappeInstance) async {
  try {
    customerEditedDataList = await fetchFromEditedCustomer();
    
    for(var customer in customerEditedDataList)
    {
      try{
        final response = await http.post(
      Uri.parse('https://$frappeInstance/api/method/offline_pos_erpnext.API.customer.update_customer'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
      body: jsonEncode({
        'data':{
        'name':customer.name,
        'customer_name':customer.customerName,
        'mobile_no':customer.mobileNo,
        'gender':customer.gender,
        'city':customer.city,
        'country':customer.country,
        'address_line_1':customer.addressLine1,
        "address_line_2":customer.addressLine2,
        'national_id':customer.nationalId,
       'email':customer.emailId
        }
       
      })
    );

    // Check if the response status is OK (200)
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map && body['message'] != null) {
        if (body["message"]["status"] == "success")
        {
          await updateCustomerSyncStatus(customer.name);
        }
        
      
      } else {
        logErrorToFile("⚠️ No customer updated: $body");
       
      }
    } else {
      logErrorToFile("❌ Failed toupdate customers: ${response.statusCode}, body: ${response.body}");
 
    }
      }
  catch (e) {
    logErrorToFile("❌ Error: $e");

  }

    }
    
  } catch (e) {
    logErrorToFile("❌ Error: $e");
   
  }
}


Future<void> createCustomerRequest( String httpType, String frappeInstance) async {
  try {
    customerCreatedDataList = await fetchFromCreatedCustomer();
 
    for(var customer in customerCreatedDataList)
    {
      try{
        final response = await http.post(
      Uri.parse('https://$frappeInstance/api/method/offline_pos_erpnext.API.customer.create_customer'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
      body: jsonEncode({
        'data':{
        'name':customer.name,
        'customer_name':customer.customerName,
        'mobile_no':customer.mobileNo,
        'gender':customer.gender,
        'city':customer.city,
        'country':customer.country,
        'address_line_1':customer.addressLine1,
        "address_line_2":customer.addressLine2,
        'national_id':customer.nationalId,
       'email':customer.emailId
        }
       
      })
    );

    // Check if the response status is OK (200)
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map && body['message'] != null) {
        if (body["message"]["status"] == "success")
        {
          if ((customer.name ?? "").isNotEmpty)
          {
             await updateCustomerID((customer.name ?? ""), body["message"]["id"]);
             await updateSalesInvoiceCustomerID((customer.name ?? ""), body["message"]["id"]);
          }
         
        }
        
      
      } else {
        logErrorToFile("⚠️ No customer updated: $body");
       
      }
    } else {
      logErrorToFile("❌ Failed toupdate customers: ${response.statusCode}, body: ${response.body}");
 
    }
      }
  catch (e) {
    logErrorToFile("❌ Error: $e");

  }

    }
    
  } catch (e) {
    logErrorToFile("❌ Error: $e");
   
  }
}