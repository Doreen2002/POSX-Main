import 'dart:async';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

Future<bool> createTableItem() async {
 bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
await conn.query("""
    CREATE TABLE IF NOT EXISTS Item (
        name varchar(20) PRIMARY KEY,
        item_code varchar(20),
        item_name varchar(50),
        item_group varchar(20),
        stock_uom varchar(20),
        is_stock_item INTEGER,
        opening_stock FLOAT,
        new_rate FLOAT,
        standard_rate FLOAT,
        has_serial_no INTEGER,
        has_batch_no INTEGER,
        max_discount FLOAT,
        itemvat INTEGER,
        custom_is_vat_inclusive INTEGER,
        vat_exclusive_rate FLOAT,
        plu varchar(10),
        modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );
""");

    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating item table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}


Future<bool> createTableItemGroup(conn) async {
  bool isCreatedDB = false;
  try {
 
    await conn.query( "CREATE TABLE IF NOT EXISTS ItemGroup (name varchar(255) PRIMARY KEY)");
    isCreatedDB = true;
  } catch (e) {
    logErrorToFile("Error creating item table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}

Future<bool> createTableBarcode() async {
  bool isCreatedDB = false;
  try {
      final conn = await getDatabase();
    await conn.query( "CREATE TABLE IF NOT EXISTS Barcode (barcode varchar(255) PRIMARY KEY, item_code varchar(255));");
     isCreatedDB = true;
    await conn.close();
  } catch (e) {
   logErrorToFile("Error creating item table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}

Future<bool> createTableBatch() async {
  bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query(  "CREATE TABLE IF NOT EXISTS Batch (name varchar(255) PRIMARY KEY,batch_id varchar(255),item varchar(255),item_name varchar(255),manufacturing_date varchar(255),batch_qty FLOAT,stock_uom varchar(255),expiry_date varchar(255),modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
   logErrorToFile ("Error creating batch table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}

Future<bool> createTableSerial() async {
  bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query( "CREATE TABLE IF NOT EXISTS Serial (name varchar(255) PRIMARY KEY,serial_no varchar(255),batch_no varchar(255),item_code varchar(255),item_name varchar(255),item_group varchar(255),purchase_date varchar(255),purchase_rate FLOAT)");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating item table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}