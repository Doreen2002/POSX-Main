import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:offline_pos/database_conn/insert_item_queries.dart';
import 'package:offline_pos/models/barcode.dart';
import 'package:offline_pos/models/batch_list_model.dart';
import 'package:offline_pos/models/item_model.dart';
import 'package:offline_pos/models/item_group_model.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/globals/global_values.dart';
final storage = FlutterSecureStorage();
Future<List<TempItem>> itemRequest( String httpType, String frappeInstance, String user) async {
  try {

    final response = await http.get(
      Uri.parse('$transferProtocol://$frappeInstance/api/method/offline_pos_erpnext.API.item_list.get_all_pos_items?user=$user'),
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
        // Map the items message to TempItem objects
        List<TempItem> items = [];
        for (var item in body['message']) {
          items.add(TempItem.fromJson(item));
          await insertTableItem( d: [TempItem.fromJson(item)]);
        }
       
        return items;
      } else {
        logErrorToFile("⚠️ No items found: $body");
        return [];
      }
    } else {
      logErrorToFile("❌ Failed to fetch items: ${response.statusCode}, body: ${response.body}");
      return [];
    }
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}

Future<List<BatchListModel>> batchRequest( String httpType, String frappeInstance, String user) async {
  try {
    await UserPreference.getInstance();

    final response = await http.get(
      Uri.parse('$transferProtocol://$frappeInstance/api/method/offline_pos_erpnext.API.item_list.get_batch?warehouse=${UserPreference.getString(PrefKeys.posProfileWarehouse)}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      
      },
    );

    
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

    
      if (body is Map && body['message'] != null) {
        
        List<BatchListModel> items = [];
        for (var item in body['message']) {
          items.add(BatchListModel.fromJson(item));
          await insertTableBatch( d: [BatchListModel.fromJson(item)]);
        }
       
        return items;
      } else {
        logErrorToFile("⚠️ No batch found: $body");
        return [];
      }
    } else {
      logErrorToFile("❌ Failed to fetch batch: ${response.statusCode}, body: ${response.body}");
      return [];
    }
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}

Future<List<BarcodeModel>> barcodeRequest( String httpType, String frappeInstance, String user) async {
  try {
    

    final response = await http.get(
      Uri.parse('$transferProtocol://$frappeInstance/api/method/offline_pos_erpnext.API.item_list.get_barcode'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      
      },
    );

    
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

    
      if (body is Map && body['message'] != null) {
        
        List<BarcodeModel> items = [];
        for (var item in body['message']) {
          items.add(BarcodeModel.fromJson(item));
          await insertTableBarcode( d: [BarcodeModel.fromJson(item)]);
        }
       
        return items;
      } else {
        logErrorToFile("⚠️ No barcode found: $body");
        return [];
      }
    } else {
      logErrorToFile("❌ Failed to fetch barcode: ${response.statusCode}, body: ${response.body}");
      return [];
    }
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}

Future<List<TempItem>> updateItems( String httpType, String frappeInstance) async {
  try {
    
    // Send GET request to fetch items
    final response = await http.get(
      Uri.parse('$transferProtocol://$frappeInstance/api/method/offline_pos_erpnext.API.item_list.get_vat_details'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
    );

    // Check if the response status is OK (200)
    if (response.statusCode == 200) {
      final conn = await getDatabase();
      final body = jsonDecode(response.body);
      
      // Check if the response contains data
      if (body is Map && body['message'] != null) {
        // Map the items message to TempItem objects
        List<TempItem> items = [];
        for (var item in body['message']) {
         
          await conn.query('''UPDATE Item si SET final = ${item['tax_rate']} WHERE si.name = '${item['item']}'; ''');
        }
        await conn.close();
        return items;
      } else {
        logErrorToFile("⚠️ No items found: $body");
        return [];
      }
    } else {
      logErrorToFile("❌ Failed to fetch items: ${response.statusCode}, body: ${response.body}");
      return [];
    }
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}


Future<List<TempItem>> updateItemsDetails( String httpType, String frappeInstance, String user) async {
  try {
   
    // Send GET request to fetch items
    final response = await http.get(
      Uri.parse('$transferProtocol://$frappeInstance/api/method/offline_pos_erpnext.API.item_list.get_all_pos_items?user=$user'),
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
        // Map the items message to TempItem objects
        final conn = await getDatabase();
        List<TempItem> items = [];
        for (var item in body['message']) {
         
          // Update only opening_stock as valuation_rate is no longer needed for POS operations
          await conn.query('''UPDATE Item si SET opening_stock = ${item['opening_stock']} WHERE si.name = '${item['name']}'; ''');
        
        }
       await  conn.close();
        return items;
      } else {
        logErrorToFile("⚠️ No items found: $body");
        return [];
      }
    } else {
      logErrorToFile("❌ Failed to fetch items: ${response.statusCode}, body: ${response.body}");
      return [];
    }
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}




Future updateItemsStockDetails(items) async {
  try {
  
    final conn = await getDatabase();
    final Map<String, num> itemTotals = {};
    for (var item in items) {
      itemTotals[item.itemCode] = (itemTotals[item.itemCode] ?? 0) + item.qty;
    }
    for (var entry in itemTotals.entries) {
      final itemCode = entry.key;
      final totalQty = entry.value;

    

      await conn.query(
        '''UPDATE Item si 
           SET opening_stock = opening_stock - $totalQty  
           WHERE si.name = '$itemCode';'''
      );
    }
    await conn.close();
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}


Future updateItemsStockBatchDetails( batchQty, itemID, batchId) async {
  try {

      final conn = await getDatabase();
      await conn.query('''UPDATE Batch si SET batch_qty = '$batchQty'  WHERE si.item = '$itemID' AND si.batch_id = '$batchId' ; ''');
      await  conn.close();
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}


Future<List<TempItemGroup>> itemGroupRequest( String httpType, String frappeInstance) async {
  try {
   

    final response = await http.get(
      Uri.parse('$transferProtocol://$frappeInstance/api/resource/Item Group?limit_page_length=100&limit_start=0&fields=["name"]'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map && body['data'] != null) {
        List<TempItemGroup> items = [];
        for (var item in body['data']) {
          TempItemGroup group = TempItemGroup.fromJson(item);
          items.add(group);
          await insertTableItemGroup( d: [group]);
        }
        return items;
      } else {
        logErrorToFile("⚠️ No items found: $body");
        return [];
      }
    } else {
      logErrorToFile("❌ Failed to fetch items: ${response.statusCode}, body: ${response.body}");
      return [];
    }
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}
