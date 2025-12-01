
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/models/hold_cart.dart';
import 'package:offline_pos/models/hold_cart_item.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

Future<bool> createHoldCartTable() async {
  bool isCreatedDB = false;
  final conn = await getDatabase();
  try {
    
    await conn.query("""
      CREATE TABLE IF NOT EXISTS HoldCart (
        id INTEGER PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255),
        customer VARCHAR(255),
        date VARCHAR(255),
        total_val_amount FLOAT,
        discount_amount FLOAT,
        discount_percent FLOAT,
        vat FLOAT,
        total_amount FLOAT,
        total_qty INT
  
      )
    """);
    isCreatedDB = true;
   
  } catch (e) {
    logErrorToFile("Error creating HoldCart table: $e");
    isCreatedDB = false;
  }
  finally
  {
     await conn.close();
  }
  return isCreatedDB;
}


Future<bool> createHoldCartItemTable() async {
  bool isCreatedDB = false;
     final conn = await getDatabase();
  try {
 
    await conn.query("""
      CREATE TABLE IF NOT EXISTS HoldCartItem (
        id INTEGER PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255),
        parent_id VARCHAR(255),
        date VARCHAR(255),
        rate FLOAT,
        qty INT,
        idx INT,
        item_code VARCHAR(255),
        item_name VARCHAR(255),
        item_group VARCHAR(255),
        stock_uom VARCHAR(255),
        discount_amount FLOAT,
        discount_percent FLOAT,
        opening_stock INT,
        rate_with_vat FLOAT,
        vat INT,
        batch_no VARCHAR(255),
        total_amount FLOAT

      )
    """);
    isCreatedDB = true;
   
  } catch (e) {
    logErrorToFile("Error creating HoldItemCart table: $e");
    isCreatedDB = false;
  }
  finally
  {
     await conn.close();
  }
  return isCreatedDB;
}

List<HoldCart> holdcartList = [];

Future<List<HoldCart>> fetchFromHoldCart() async {
     final conn = await getDatabase();
  try {
  
    final queryResult = await conn.query("SELECT * FROM HoldCart ORDER BY date DESC;");

    holdcartList = queryResult
      .map((row) => HoldCart.fromJson(row.fields))
      .toList()
      .cast<HoldCart>();
    
    return holdcartList;
  } catch (e) {
    logErrorToFile("Error fetching data from Hold Cart  Table: $e");
    return [];
  }
  finally
  {
    await conn.close();
  }
}

List<HoldCartItem> holdcartItemList = [];

Future<List<HoldCartItem>> fetchFromHoldCartItem() async {
    final conn = await getDatabase();
  try {
   
    final queryResult = await conn.query("SELECT * FROM HoldCartItem;");

    holdcartItemList = queryResult
      .map((row) => HoldCartItem.fromJson(row.fields))
      .toList()
      .cast<HoldCartItem>();
    
    return holdcartItemList;
  } catch (e) {
    logErrorToFile("Error fetching data from Hold Cart Item Table: $e");
    return [];
  }
  finally
  {
    await conn.close();
  }
}


Future<List<HoldCartItem>> deleteFromHoldCartItem(name) async {
   final conn = await getDatabase();
  try {
    
    await conn.query("DELETE FROM HoldCart WHERE name = '$name';");
    await conn.query("DELETE FROM HoldCartItem WHERE parent_id = '$name';");
 
    return holdcartItemList;
  } catch (e) {
    logErrorToFile("Error deleteing hold cart: $e");
    return [];
  }
  finally{
       await conn.close();
  }
}

Future<void> insertIntoHoldCart(HoldCart holdCart) async {
  final conn = await getDatabase();
  try {
    
    await conn.query(
      '''
      INSERT INTO HoldCart (
        id, name, customer, date, total_val_amount, discount_amount,
        discount_percent, vat, total_amount, total_qty
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
        customer = VALUES(customer),
        date = VALUES(date),
        total_val_amount = VALUES(total_val_amount),
        discount_amount = VALUES(discount_amount),
        discount_percent = VALUES(discount_percent),
        vat = VALUES(vat),
        total_amount = VALUES(total_amount),
        total_qty = VALUES(total_qty)
      ''',
      [
        holdCart.id,
        holdCart.name,
        holdCart.customer,
        holdCart.date,
        holdCart.totalValAmount,
        holdCart.discountAmount,
        holdCart.discountPercent,
        holdCart.vat,
        holdCart.totalAmount,
        holdCart.totalQty,
      ],
    );
 
  } catch (e) {
    logErrorToFile("Error inserting into HoldCart: $e");
  }
  finally{
       await conn.close();
  }
}


Future<void> insertIntoHoldCartItem(HoldCartItem item) async {
  final conn = await getDatabase();
  try {
    
    await conn.query(
      '''
      INSERT INTO HoldCartItem (
        id, name, parent_id, date, rate, qty, item_code, item_name,
        item_group, stock_uom, discount_amount, discount_percent,
        opening_stock, rate_with_vat, vat, total_amount, batch_no, idx
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
        parent_id = VALUES(parent_id),
        date = VALUES(date),
        rate = VALUES(rate),
        qty = VALUES(qty),
        item_code = VALUES(item_code),
        item_name = VALUES(item_name),
        item_group = VALUES(item_group),
        stock_uom = VALUES(stock_uom),
        discount_amount = VALUES(discount_amount),
        discount_percent = VALUES(discount_percent),
        opening_stock = VALUES(opening_stock),
        rate_with_vat = VALUES(rate_with_vat),
        vat = VALUES(vat),
        total_amount = VALUES(total_amount),
        batch_no = VALUES(batch_no),
        idx = VALUES(idx)
      ''',
      [
        item.id,
        item.name,
        item.parentId,
        item.date,
        item.rate,
        item.qty,
        item.itemCode,
        item.itemName,
        item.itemGroup,
        item.stockUom,
        item.discountAmount,
        item.discountPercent,
        item.openingStock,
        item.rateWithVat,
        item.vat,
        item.totalAmount,
        item.batchNo,
        item.idx
      ],
    );
    
  } catch (e) {
    logErrorToFile("Error inserting into HoldCartItem: $e");
   
  }
  finally{
    await conn.close();
  }
}