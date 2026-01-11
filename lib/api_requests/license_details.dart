import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/licence_db.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/globals/global_values.dart';
Future<bool> activateLicenseRequest(String httpType, String frappeInstance, String deviceID, String licenseKey) async {
  try {
  

    final response = await http.post(
      Uri.parse('$transferProtocol://$frappeInstance/api/method/offline_pos_erpnext.API.login.activate_license'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
      body: jsonEncode({
        'data':{
          'device_id': deviceID,
          'license_key': licenseKey
        }
       
      })
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body)['message'];
     
    
      if (body is Map && body['message'] != null) {
      
        await UserPreference.putBool(PrefKeys.licenseActivated, true);
        await insertLicenseDetails(id:body['message']['name'] , licenseKey: body['message']['license_key'], licenseType: body['message']['license_type'],  primaryUrl: body['message']['primary_url'],secondaryUrl: body['message']['secondary_url'],  activatedOn: body['message']['activation_date'], expiryDate : body['message']['expiry_date'], status: body['message']['status']);
        return true;
      } else {
        await UserPreference.putBool(PrefKeys.licenseActivated, false);
        logErrorToFile("License activation failed: $body");
        return false;
      }
     
    } else {
       await UserPreference.putBool(PrefKeys.licenseActivated, false);
        logErrorToFile("License activation failed:");
      return false;
    }
  } catch (e) {
      await UserPreference.putBool(PrefKeys.licenseActivated, false);
    logErrorToFile("❌ Error: $e");
    return false;
  }
}



