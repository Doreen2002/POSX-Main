import 'dart:async';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/models/pos_closing_currency_denomination.dart';
import 'package:offline_pos/models/pos_closing_entry_model.dart';
import 'package:offline_pos/models/pos_opening_entry_model.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
Future<void> createPosProfileTable() async {
  try{
    final db = await getDatabase();
  await db.query(
    '''
    CREATE TABLE IF NOT EXISTS PosOpening (
      name TEXT PRIMARY KEY,
      user TEXT,
      period_start_date TEXT,
      period_end_date TEXT,
      status TEXT,
      posting_date TEXT,
      company TEXT,
      pos_profile TEXT,
      pos_closing_entry TEXT,
      paymentMode TEXT,
      amount REAL
    );
    '''
  );
  await db.close();
  }
  catch (e) {
    logErrorToFile("Error creating PosOpening table: $e");
  }

}

Future<bool> createTablePosOpening() async {
 bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query("CREATE TABLE IF NOT EXISTS PosOpening (name varchar(255) PRIMARY KEY,erpnext_id varchar(255),user varchar(255),period_start_date varchar(255),period_end_date varchar(255),status varchar(255),posting_date varchar(255),company varchar(255),pos_profile varchar(255),pos_closing_entry varchar(255),paymentMode varchar(255),amount double,sync_status varchar(255));");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating pos opening table $e");
    isCreatedDB = false;
    
  }

  return isCreatedDB;
}

Future<bool> createTablePosClosing() async {
 bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query("CREATE TABLE IF NOT EXISTS PosClosing (name varchar(255) PRIMARY KEY,erpnext_id varchar(255),user varchar(255),period_start_date varchar(255),period_end_date varchar(255),posting_date varchar(255),posting_time varchar(255),company varchar(255),pos_profile varchar(255),pos_opening_entry varchar(255),closing_amount FLOAT,opening_entry_amount FLOAT,sync_status varchar(255), total_denomination_value FLOAT, comment varchar(255));");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
   logErrorToFile ("Error creating pos closing table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}


Future<bool> createTablePosProfile() async {
 bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query("CREATE TABLE IF NOT EXISTS POSProfile (name varchar(255) PRIMARY KEY,company varchar(255),customer varchar(255),country varchar(255),disabled int,warehouse varchar(255),update_stock int,currency varchar(255))");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating item table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}


Future<bool> createTablePosClosingCurrencyDenomination() async {
 bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query("CREATE TABLE IF NOT EXISTS PosClosingCurrencyDenomination (id INTEGER PRIMARY KEY AUTO_INCREMENT,pos_closing varchar(255),denomination_value FLOAT, total_denomination_value FLOAT, count INT)");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating PosClosingCurrencyDenomination table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}


Future<bool> createTableCashDrawer() async {
 bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query("CREATE TABLE IF NOT EXISTS CashDrawer (id INTEGER PRIMARY KEY AUTO_INCREMENT,username varchar(255),datetime varchar(255) )");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating CashDrawer table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}



List <PosOpeningEntry> posOpeningList = [];

Future<List<PosOpeningEntry>> fetchFromPosOpening() async {
  try {
     final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM PosOpening where status = 'OPEN' ;");

    posOpeningList = queryResult
      .map((row) => PosOpeningEntry.fromJson(row.fields))
      .toList()
      .cast<PosOpeningEntry>();
    await conn.close();
    return posOpeningList;
  } catch (e) {
    logErrorToFile("Error fetching data from Item Table: $e");
    return [];
  }
}

List <PosOpeningEntry> posOpeningNotSyncedList = [];
Future<List<PosOpeningEntry>> fetchFromNotSyncedPosOpening() async {
  try {
     final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM PosOpening WHERE sync_status IS NULL;");

    posOpeningNotSyncedList = queryResult
      .map((row) => PosOpeningEntry.fromJson(row.fields))
      .toList()
      .cast<PosOpeningEntry>();
    await conn.close();
    return posOpeningNotSyncedList;
  } catch (e) {
   logErrorToFile("Error fetching data from Item Table: $e");
    return [];
  }
}


List <PosClosingEntry> posOpeningClosedList = [];

Future<List<PosClosingEntry>> fetchFromPosOpeningClosed() async {
  try {
     final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM PosClosing where sync_status = 'Created' ;");

    posOpeningClosedList = queryResult
      .map((row) => PosClosingEntry.fromJson(row.fields))
      .toList()
      .cast<PosClosingEntry>();
    await conn.close();
    return posOpeningClosedList;
  } catch (e) {
    logErrorToFile("Error fetching data from Item Table: $e");
    return [];
  }
}



List <PosOpeningEntry> allPosOpeningList = [];
Future<List<PosOpeningEntry>> fetchAllFromPosOpening() async {
  try {
     final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM PosOpening Order by posting_date DESC  ;");

    allPosOpeningList = queryResult
      .map((row) => PosOpeningEntry.fromJson(row.fields))
      .toList()
      .cast<PosOpeningEntry>();
    await conn.close();
    return allPosOpeningList;
  } catch (e) {
    logErrorToFile("Error fetching data from Item Table: $e");
    return [];
  }
}


List <PosClosingEntry> allPosClosingList = [];
Future<List<PosClosingEntry>> fetchAllFromPosClosing() async {
  try {
     final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM PosClosing Order by posting_date DESC  ;");

    allPosClosingList = queryResult
      .map((row) => PosClosingEntry.fromJson(row.fields))
      .toList()
      .cast<PosClosingEntry>();
    await conn.close();
    return allPosClosingList;
  } catch (e) {
    logErrorToFile("Error fetching data from Item Table: $e");
    return [];
  }
}

List <PosClosingCurrencyDenomination> allPosClosingCurrencyDenominationList = [];

Future<List<PosClosingCurrencyDenomination>> fetchAllFromPosClosingCurrencyDenomination(String closingEntry) async {
  try {
     final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM PosClosingCurrencyDenomination WHERE pos_closing = '$closingEntry';");

     allPosClosingCurrencyDenominationList= queryResult
      .map((row) => PosClosingCurrencyDenomination.fromJson(row.fields))
      .toList()
      .cast<PosClosingCurrencyDenomination>();
    await conn.close();
    return allPosClosingCurrencyDenominationList;
  } catch (e) {
   logErrorToFile("Error fetching data from PosClosingCurrencyDenomination Table: $e");
    return [];
  }
}


Future<Map<String, dynamic>> fetchClosingEntryToPrint(String name, String closedName) async {
  final conn = await getDatabase();
  try {
    final closingResult = await conn.query(
      "SELECT * FROM PosClosing WHERE pos_opening_entry = ?",
      [name],
    );
    if (closingResult.isEmpty) {
      await conn.close();
      return {};
    }
    final closed = closingResult.first.fields;

   
    final invoiceResult = await conn.query(
      "SELECT * FROM SalesInvoice WHERE opening_name = ? AND invoice_status = 'Submitted' ",
      [name],
    );
    final invoices = invoiceResult.map((row) => row.fields).toList();

   
    List<Map<String, dynamic>> invoiceWithItems = [];
    int totalQty = 0;
    double grandTotal =0;
    double netTotal = 0;
    double vatTotal = 0;
    double discountTotal = 0;
    for (var invoice in invoices) {
      final itemsResult = await conn.query(
        "SELECT * FROM SalesInvoiceItem WHERE name = ?",
        [invoice['name']],
      );
      final items = itemsResult.map((row) => row.fields).toList();
       
      invoiceWithItems.add({
        "invoice": invoice,
        "items": items,
      });

      grandTotal += (invoice['grand_total'] is num)
      ? invoice['grand_total']
        : double.tryParse(invoice['grand_total'].toString()) ?? 0.0;
        discountTotal += (invoice['discount'] is num)
      ? invoice['discount']
        : double.tryParse(invoice['discount'].toString()) ?? 0.0;
      netTotal += (invoice['net_total'] is num)
        ? invoice['net_total']
        : double.tryParse(invoice['net_total'].toString()) ?? 0.0;
      vatTotal += (invoice['vat'] is num)
        ? invoice['vat']
        : double.tryParse(invoice['vat'].toString()) ?? 0.0;
    }
    int totalDenominations = 0;
    final denominations = await conn.query( "SELECT denomination_value , count , total_denomination_value FROM PosClosingCurrencyDenomination WHERE pos_closing = ?", [closedName]);
    final denominationList = denominations.map((row) => row.fields).toList();
      for (var denom in denominationList) {
        final value = denom['total_denomination_value'];

        if (value == null) {
          totalDenominations += 0;
        } else if (value is int) {
          totalDenominations += value;
        } else if (value is double) {
          totalDenominations += value.toInt();
        } else if (value is String) {
          totalDenominations += int.tryParse(value) ??
          double.tryParse(value)?.toInt() ??
          0;
        } else {
          totalDenominations += 0; 
        }
      }

    
    for (var invItem in invoiceWithItems.expand((i) => i['items'])) {
         if (invItem['qty'] is String) {
          totalQty += int.tryParse(invItem['qty']) ?? 0;
        } else {
          totalQty +=invItem['qty'].toString().isNotEmpty
            ? int.tryParse(invItem['qty'].toString()) ?? 0
            : 0;
        }
      
      }
   
    final paymentsResult = await conn.query(
      "SELECT mode_of_payment, SUM(amount) AS amount FROM SalesInvoicePayment WHERE opening_name = ? GROUP BY mode_of_payment",
      [name],
    );

    final paymentModes = paymentsResult.map((row) => row.fields).toList();

    await conn.close();

    return {
      "startDate": closed['period_start_date'],
      "endDate": closed['period_end_date'],
      "openingEntryName": closed['pos_opening_entry'],
      "closingEntryName": closed['name'] ?? closed['erpnext_id'],
      "company":closed['company'],
      'posProfile':closed['pos_profile'],
      "cashier":closed['user'],
      'postingDate':closed['posting_date'],
      "invoices": invoices,
      "totalQTy": totalQty,
      'totalInvoices': invoices.length,
      'averageSales': invoices.length > 0 ? grandTotal/invoices.length : 0,  
      'invoiceDiscount': discountTotal,
      "grandTotal":grandTotal,
      "netTotal":netTotal,
      "vatTotal":vatTotal,
      "openingAmount": closed['opening_entry_amount'],
      "closingAmount":closed['closing_amount'],
      "paymentModes": paymentModes,
      'denominations': denominationList,
      'totalDenominations':totalDenominations,
      'comment': closed['comment'] ?? ''
    };
  } catch (e) {
    logErrorToFile("Error fetching invoice for print: $e");
   
    await conn.close();
    return {};
  }
}