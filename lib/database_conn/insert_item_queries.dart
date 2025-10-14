import 'dart:async';
import 'package:offline_pos/models/barcode.dart';
import 'package:offline_pos/models/batch_list_model.dart';
import 'package:offline_pos/models/item_group_model.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import '../models/item_model.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';

Future<dynamic> insertTableItem({required List<TempItem> d}) async { 
  try {
    final conn = await getDatabase();
    const insertQuery = '''
      INSERT INTO Item (
        name, item_code, item_name, item_group, stock_uom, is_stock_item,
        opening_stock, new_rate, standard_rate,
        has_serial_no, has_batch_no, itemvat, max_discount, vat_exclusive_rate, custom_is_vat_inclusive 
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
        item_name = VALUES(item_name),
        item_group = VALUES(item_group),
        stock_uom = VALUES(stock_uom),
        is_stock_item = VALUES(is_stock_item),
        opening_stock = VALUES(opening_stock),
        new_rate = VALUES(new_rate),
        standard_rate = VALUES(standard_rate),
        has_serial_no = VALUES(has_serial_no),
        has_batch_no = VALUES(has_batch_no),
        itemvat = VALUES(itemvat),
        max_discount = VALUES(max_discount),
        vat_exclusive_rate = VALUES(vat_exclusive_rate),
        custom_is_vat_inclusive = VALUES(custom_is_vat_inclusive )
    ''';

    for (var element in d) {
      await conn.query(insertQuery, [
        element.name,
        element.itemCode,
        element.itemName?.replaceAll("'", "''"),
        element.itemGroup,
        element.stockUom,
        element.isStockItem,
        element.openingStock,
        element.standardRate,
        element.standardRate,
        element.hasSerialNo,
        element.hasBatchNo,
        element.itemvat,
        element.maxDiscount,
        element.vatExclusiveRate,
        element.customVATInclusive,
      ]);
    }
    await conn.close();
  } catch (e) {
    logErrorToFile("Error inserting data into Item Table: $e");
    return null;
  }
}


Future<dynamic> insertTableBatch( {required List<BatchListModel> d}) async { 
  try {
     final conn = await getDatabase();
    const insertQuery = '''
      INSERT INTO Batch (
        name, batch_id, item, item_name, manufacturing_date, batch_qty,
        stock_uom, expiry_date
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
        item_name = VALUES(item_name),
        manufacturing_date = VALUES(manufacturing_date),
        batch_qty = VALUES(batch_qty),
        stock_uom = VALUES(stock_uom),
        expiry_date = VALUES(expiry_date)
    ''';

    for (var element in d) {
     await conn.query(insertQuery, [
        element.name,
        element.batchId,
        element.item,
        element.itemName?.replaceAll("'", "''"),
        element.manufacturingDate,
        element.batchQty,
        element.stockUom,
        element.expiryDate
      ]);
    }
    const deleteZeroQtyBatchesQuery = '''
      DELETE FROM Batch WHERE batch_qty = 0
    ''';
    await conn.query(deleteZeroQtyBatchesQuery);
    await conn.close();
  } catch (e) {
    logErrorToFile("Error inserting data into Item Table: $e");
    return null;
  }
}

Future<dynamic> insertTableBarcode( {required List<BarcodeModel> d}) async { 
  try {
     final conn = await getDatabase();
    const insertQuery = '''
      INSERT INTO Barcode (
        barcode, barcode_type, item_code, uom
      ) VALUES (?, ?, ?,  ?)
      ON DUPLICATE KEY UPDATE
        item_code = VALUES(item_code),
        barcode_type = VALUES(barcode_type),
        uom = VALUES(uom)
    ''';

    for (var element in d) {
     await conn.query(insertQuery, [
        element.barcode,
        element.barcodeType,
        element.itemCode,
        element.uom
      ]);
    }
    await conn.close();
  } catch (e) {
    logErrorToFile("Error inserting data into Barcode  Table: $e");
    return null;
  }
}


Future<dynamic> insertTableItemGroup({List<TempItemGroup>? d}) async {
  try {
    final conn = await getDatabase();
    dynamic res;
    for (var element in d!) {
       var insertItemGroupQuery = 'INSERT INTO ItemGroup (name)';
      res = await conn.query('''$insertItemGroupQuery VALUE('${element.name}');''');
    }
    await conn.close();
    return res;
  } catch (e) {
    logErrorToFile("Error inserting data into Item Table $e");
  }
}
