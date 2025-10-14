import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/models/customer_list_model.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
List<TempCustomerData> customerDataList = [];

List<TempCustomerData> customerEditedDataList = [];

List<TempCustomerData> customerCreatedDataList = [];

Future<List<TempCustomerData>> fetchFromCustomer() async {
  
  try {
    final conn = await getDatabase();
    final  queryResult = await conn.query("SELECT * FROM Customer ORDER BY modified DESC;");
     final customerDataList = queryResult.map((row) {
      return TempCustomerData.fromJson(row.fields);
    }).toList().cast<TempCustomerData>();
    conn.close();
    
    // **NEW: Populate customer QR map for fast O(1) lookups**
    OptimizedDataManager.populateCustomerQRMap(customerDataList);
    
    return customerDataList;
  } catch (e) {
    logErrorToFile("Error fetching data from Customer Table: $e");
    return [];
  }
  
}



Future<List<TempCustomerData>> fetchFromEditedCustomer() async {
  
  try {
    final conn = await getDatabase();
    final  queryResult = await conn.query("SELECT * FROM Customer WHERE sync_status = 'Edited' ORDER BY modified DESC;");
     final customerEditedDataList = queryResult.map((row) {
      return TempCustomerData.fromJson(row.fields);
    }).toList().cast<TempCustomerData>();
    conn.close();
    return customerEditedDataList;
  } catch (e) {
   logErrorToFile("Error fetching data from edited Customer Table: $e");
    return [];
  }
  
}

Future<List<TempCustomerData>> fetchFromCreatedCustomer() async {
  
  try {
    final conn = await getDatabase();
    final  queryResult = await conn.query("SELECT * FROM Customer WHERE sync_status = 'Created' ;");
     final customerCreatedDataList = queryResult.map((row) {
      return TempCustomerData.fromJson(row.fields);
    }).toList().cast<TempCustomerData>();
    conn.close();
    return customerCreatedDataList;
  } catch (e) {
    logErrorToFile("Error fetching data from created Customer Table: $e");
    return [];
  }
  
}

Future<String?> fetchLastCustomerSequence() async {
  try {
    final conn = await getDatabase();
    final branchID = UserPreference.getString(PrefKeys.branchID) ?? '';
    final queryResult = await conn.query(
      "SELECT posx_id FROM Customer WHERE posx_id LIKE ? ORDER BY CAST(SUBSTRING_INDEX(posx_id, ' - ', -1) AS UNSIGNED) DESC LIMIT 1;",
      ["CM - $branchID - %"],
    );
    await conn.close();

    if (queryResult.isNotEmpty) {
      final name = queryResult.first['posx_id'] as String;
      final parts = name.split(' - ');
      if (parts.length >= 3) {
        return parts.last; 
      }
    }
    return null;
  } catch (e) {
    logErrorToFile("Error fetching data from last customer: $e");
    return null;
  }
}