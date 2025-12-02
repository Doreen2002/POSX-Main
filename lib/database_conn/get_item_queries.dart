
import 'dart:async';

import 'package:offline_pos/models/barcode.dart';
import 'package:offline_pos/models/batch_list_model.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import '../models/item_model.dart';
import '../models/item_group_model.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/models/item_price.dart';
import 'package:offline_pos/models/uom.dart';

List <TempItem> itemListdata = [];

List <BatchListModel> batchListdata = [];
List<TempItemGroup> itemGroupdata = [];

Future<List<TempItem>> fetchFromItem() async {
   final conn = await getDatabase();
  try {
    
    final queryResult = await conn.query("SELECT * FROM Item;");

    itemListdata = queryResult
      .map((row) => TempItem.fromJson(row.fields))
      .toList()
      .cast<TempItem>();
   
    return itemListdata;
  } catch (e) {
    logErrorToFile("Error fetching data from Item Table: $e");
    return [];
  }
  finally
  {
     await conn.close();
  }
}

Future<List<BatchListModel>> fetchFromBatch() async {
  final conn = await getDatabase();
  try {
     
    final queryResult = await conn.query("SELECT * FROM Batch WHERE expiry_date IS NULL OR expiry_date > CURDATE() AND batch_qty > 0 ORDER BY expiry_date ASC;");

    batchListdata = queryResult
      .map((row) => BatchListModel.fromJson(row.fields))
      .toList()
      .cast<BatchListModel>();
    
    return batchListdata;
  } catch (e) {
    logErrorToFile("Error fetching data from Batch Table: $e");
    return [];
  }
   finally
  {
     await conn.close();
  }
}

List<BarcodeModel> barcodeListdata = [];

Future<List<BarcodeModel>> fetchFromBarcode() async {
    final conn = await getDatabase();
  try {
   
    final queryResult = await conn.query("SELECT * FROM Barcode;");

    barcodeListdata = queryResult
      .map((row) => BarcodeModel.fromJson(row.fields))
      .toList()
      .cast<BarcodeModel>();
    
    return barcodeListdata;
  } catch (e) {
    logErrorToFile("Error fetching data from Barcode Table: $e");
    return [];
  }
  finally{
    await conn.close();
  }
}

Future<List<TempItemGroup>> fetchFromItemGroup(conn) async {
  try {
    // query the query
    final queryResult = await conn.query("SELECT * FROM ItemGroup;");
    
    // Map the query result to TempItem objects and cast to List<TempItem>
    itemGroupdata = queryResult.map((e) => TempItemGroup.fromJson(e.assoc())).toList().cast<TempItemGroup>();
    
    return itemGroupdata;
  } catch (e) {
    logErrorToFile("Error fetching data from Item Group $e");
    return [];
  } 
}

/// Get item by PLU (for weight-based barcode processing)
Future<TempItem?> getItemByPLU(String plu) async {
    final conn = await getDatabase();
  try {
  
    final queryResult = await conn.query("SELECT * FROM Item WHERE plu = ?", [plu]);
    
    if (queryResult.isNotEmpty) {
      final item = TempItem.fromJson(queryResult.first.fields);
   
      return item;
    }
    
    
    return null;
  } catch (e) {
    logErrorToFile("Error fetching item by PLU $plu: $e");
    return null;
  }
  finally{
    await conn.close();
  }
}

/// Get items by PLU pattern (for searching)
Future<List<TempItem>> searchItemsByPLU(String pluPattern) async {
  final conn = await getDatabase();
  try {
    
    final queryResult = await conn.query("SELECT * FROM Item WHERE plu LIKE ?", ['%$pluPattern%']);
    
    List<TempItem> items = queryResult
        .map((row) => TempItem.fromJson(row.fields))
        .toList()
        .cast<TempItem>();
    
    
    return items;
  } catch (e) {
    logErrorToFile("Error searching items by PLU pattern $pluPattern: $e");
    return [];
  }
   finally{
    await conn.close();
  }
}



List <ItemPrice> itemPriceListdata = [];

Future<List<ItemPrice>> fetchFromItemPrice() async {
   final conn = await getDatabase();
  try {
    
    final queryResult = await conn.query("SELECT * FROM ItemPrice;");

    itemPriceListdata = queryResult
      .map((row) => ItemPrice.fromJson(row.fields))
      .toList()
      .cast<ItemPrice>();
    
    return itemPriceListdata;
  } catch (e) {
    logErrorToFile("Error fetching data from Item Price Table: $e");
    return [];
  }
  finally
  {
    await conn.close();
  }
}

List <UOM> UOMListdata = [];

Future<List<UOM>> fetchFromUOM(itemCode) async {
   final conn = await getDatabase();
  try {
    
    final queryResult = await conn.query("SELECT * FROM UOM WHERE item_code = $itemCode;");

    UOMListdata = queryResult
      .map((row) => UOM.fromJson(row.fields))
      .toList()
      .cast<UOM>();
   
    return UOMListdata;
  } catch (e) {
    logErrorToFile("Error fetching data from Item Price Table: $e");
    return [];
  }
  finally{
     await conn.close();
  }
}