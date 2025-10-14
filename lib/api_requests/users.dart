import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offline_pos/database_conn/users.dart';
import 'package:offline_pos/models/sales_person.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

  final storage = FlutterSecureStorage();
Future<List<SalesPerson>> salesPersonRequest(String httpType, String frappeInstance) async {
  try {


    final response = await http.get(
      Uri.parse('https://$frappeInstance/api/method/offline_pos_erpnext.API.sales.get_Sales_person'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
    );

    // Check if the response status is OK (200)
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Check if the response contains data
      if (body is Map && body['message'] != null) {
        // Map the items data to TempItem objects
        List<SalesPerson> items = [];
        for (var item in body['message']) {
          items.add(SalesPerson.fromJson(item));
          await insertSalesPersonTable( d: [SalesPerson.fromJson(item)]);
        }
        return items;
      } else {
        logErrorToFile("⚠️ No items found: $body");
        return [];
      }
    } else {
      logErrorToFile("❌ Failed to fetch sales person: ${response.statusCode}, body: ${response.body}");
      return [];
    }
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}



