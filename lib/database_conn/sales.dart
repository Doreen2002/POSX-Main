import 'dart:async';

import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
// ignore: unused_import
import 'package:offline_pos/database_conn/create_pos_table.dart';

import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/models/item.dart';
import 'package:offline_pos/models/sales_invoice_model.dart';
import 'package:offline_pos/models/single_invoice_data.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';



Future<bool> createSalesInvoiceTable() async {
 bool isCreatedDB = false;
  try {
    print("Creating Sales Invoice Table");
    final conn = await getDatabase();
    await conn.query("CREATE TABLE IF NOT EXISTS SalesInvoice (id varchar(255), name varchar(255) PRIMARY KEY,erpnext_id varchar(255),customer varchar(255), customer_name varchar(255),pos_profile varchar(255),company varchar(255),posx_date varchar(255),erpnext_si_date varchar(255),due_date varchar(255),net_total FLOAT,additional_discount_percentage FLOAT,grand_total FLOAT,gross_total FLOAT, change_amount FLOAT,status varchar(255),messageStatus varchar(255),vat FLOAT,discount FLOAT,opening_name varchar(255),invoice_status varchar(255),sales_person varchar(255),submitted_at varchar(255),background_job_id varchar(255), is_return varchar(255), return_against varchar(255))");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    print("Error creating sales invoice table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}

Future<bool> createSalesInvoiceItemTable() async {
 bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query( "CREATE TABLE IF NOT EXISTS SalesInvoiceItem  (id INTEGER PRIMARY KEY AUTO_INCREMENT,name varchar(255),item_code varchar(255),item_name varchar(255),image varchar(255),stock_uom varchar(255),item_group varchar(255),rate FLOAT,qty int,batch_no varchar(255),serial_no varchar(255),item_tax_rate varchar(255),price_list_rate FLOAT,base_price_list_rate FLOAT,amount FLOAT,net_rate FLOAT,net_amount FLOAT,discount_percentage FLOAT,discount_amount FLOAT, custom_is_vat_inclusive INTEGER,applied_pricing_rule_id varchar(255),applied_pricing_rule_title varchar(255),discount_source varchar(255))");
    
    // Add pricing rule columns to existing tables
    try {
      await conn.query("ALTER TABLE SalesInvoiceItem ADD COLUMN applied_pricing_rule_id varchar(255)");
    } catch (e) {
      // Column already exists
    }
    try {
      await conn.query("ALTER TABLE SalesInvoiceItem ADD COLUMN applied_pricing_rule_title varchar(255)");
    } catch (e) {
      // Column already exists
    }
    try {
      await conn.query("ALTER TABLE SalesInvoiceItem ADD COLUMN discount_source varchar(255)");
    } catch (e) {
      // Column already exists
    }
    
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating sales invoice item table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}

Future<bool> createSalesInvoicePayment() async {
 bool isCreatedDB = false;
  try {
    final conn = await getDatabase(); 
    await conn.query(  "CREATE TABLE IF NOT EXISTS SalesInvoicePayment (id varchar(255),mode_of_payment varchar(255),amount FLOAT,opening_name varchar(255), erpnext_invoice_id varchar(255))");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating sales invoice payment table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}

List<TempSalesInvoiceModel> closedSalesInvoiceData = [];

Future<List<TempSalesInvoiceModel>> fetchFromClosedSalesInvoice(name) async {
  try {

    final conn = await getDatabase();


    final queryResult = await conn.query("""
      SELECT * 
      FROM SalesInvoice
      WHERE opening_name = '$name'
        AND invoice_status = 'Submitted'
        AND (status != 'Synced' AND status != 'Error');

    """);
  
      closedSalesInvoiceData = queryResult
          .map((row) => TempSalesInvoiceModel.fromJson(row.fields))
          .toList().cast<TempSalesInvoiceModel>();

    await closeDatabase(conn);
    return closedSalesInvoiceData ;
  } catch (e) {
    logErrorToFile("Error fetching data from SalesInvoice Table $e");
    return [];
  } 

}


Future<List<Map<String, dynamic>>> fetchGroupedInvoiceData() async {
  await UserPreference.getInstance();
  final conn = await getDatabase();
  List<Map<String, dynamic>> result = [];

  try {
    // Step 1: Fetch all invoices
    var invoiceRows = await conn.query("SELECT * FROM SalesInvoice WHERE (status = 'Created' OR status = 'In Progress'  OR status = 'Sent' );");
  
    for (final row in invoiceRows) {
      final invoiceName = row['name'];

  
      final itemRows = await conn.query(
        "SELECT * FROM SalesInvoiceItem WHERE name = ?",
        [invoiceName],
      );

    
      final paymentRows = await conn.query(
        "SELECT * FROM SalesInvoicePayment WHERE id = ?",
        [invoiceName],
      );

      result.add({
        'customer': row['customer'],
        "additional_discount_percentage": row['additional_discount_percentage'] ?? 0,
        'discount_amount': row['discount'] ?? 0,
        "invoice_status":row['invoice_status'] ?? "Submitted",
        'is_return':row['is_return'] ?? "No",
        'return_against':row['return_against'] ?? "",
        "name":row['name'],
        "sales_person":row["sales_person"],
        'posting_date': row['posx_date'],
        'items':  itemRows.map((i) {
  final fields = i.fields;
  return {
    'item_code': fields['item_code'],
    'item_name': fields['item_name'],
    'warehouse':UserPreference.getString(PrefKeys.posProfileWarehouse),
    'qty':row['is_return'] =="Yes" ?  fields['qty'] * -1 : fields['qty'] ,
    'rate': fields['rate'],
    'amount':fields['price_list_rate'],
    'discount_percentage': fields['discount_percentage'] ,
    'batch_no': fields['batch_no'],
    'discount_amount': fields['discount_amount'] ,
    'custom_is_vat_inclusive': fields['custom_is_vat_inclusive'] ?? 0,
    'applied_pricing_rule_id': fields['applied_pricing_rule_id'],
    'applied_pricing_rule_title': fields['applied_pricing_rule_title'],
    'discount_source': fields['discount_source'],
   
      };
    }).toList(),
        'payments': paymentRows.map((p) {
        final payment = Map<String, dynamic>.from(p.fields);
        payment['base_amount'] = row['is_return'] == 'Yes'? payment['amount'] * -1 : payment['amount']  ;
        payment['amount'] = row['is_return'] == 'Yes'? payment['amount'] * -1 : payment['amount']  ;
        return payment;
      }).toList(),
      });
    }

    await conn.close();
  } catch (e) {
    logErrorToFile("❌ Error fetching invoice data: $e");
    await conn.close();
  }

  return result;
}


Future<dynamic> insertTableSalesInvoice({String? id, String? name, String? customer, String? customerName, String? posProfile,String? company,String? postingDate,
    String? postingTime,String? paymentDueDate,double? netTotal,double? additionalDiscountPer,double? grandTotal, double? grossTotal, double? changeAmount, String? status,String? messageStatus,double? vat,double? discount,String? setWarehouse,String? openingName, String? invoiceStatus, String? salesPerson,  String? returnAgainst, String? isReturn}) async {
  try {
    final conn = await getDatabase();
    dynamic res;
     var insertItemQuery = 'INSERT INTO SalesInvoice (id, name,customer,customer_name, pos_profile,company,posx_date,erpnext_si_date,due_date,net_total,additional_discount_percentage,grand_total,gross_total, change_amount, status,messageStatus,vat,discount,opening_name,invoice_status, sales_person, is_return, return_against) ';
      res = await conn.query('''$insertItemQuery VALUES('$id','$name','$customer', '$customerName', '$posProfile','$company','$postingDate','$postingTime','$paymentDueDate','$netTotal','$additionalDiscountPer','$grandTotal', '$grossTotal', '$changeAmount', '$status','$messageStatus','$vat','$discount','$openingName','$invoiceStatus','$salesPerson' , '$isReturn', '$returnAgainst')''');
     
      await closeDatabase(conn);
    return res;
  } catch (e) {
    logErrorToFile("Error inserting data into invoice Table $e");
  }
}

Future<dynamic> insertTableSalesInvoiceItem(conn, {List<Items>? ici})async {
  try {
    
    dynamic res;
      for (var element in ici!) {
      var insertItemQuery = 'INSERT INTO SalesInvoiceItem (name,item_code,item_name,item_group,stock_uom,rate,qty,batch_no,serial_no,item_tax_rate,price_list_rate,base_price_list_rate,amount,net_rate,net_amount,discount_percentage,discount_amount, custom_is_vat_inclusive,applied_pricing_rule_id,applied_pricing_rule_title,discount_source) ';
      res = conn.query('''$insertItemQuery VALUE('${element.name}','${element.itemCode}','${element.itemName}','${element.itemGroup}','${element.stockUom}','${element.rate}','${element.qty}','${element.batchNo}','${element.serialNo}','${element.itemTaxRate}','${element.priceListRate}','${element.basePriceListRate}','${element.amount}','${element.netRate}','${element.netAmount}','${element.discountPercentage}','${element.discountAmount}' , '${element.customVATInclusive}','${element.appliedPricingRuleId ?? ''}','${element.appliedPricingRuleTitle ?? ''}','${element.discountSource ?? ''}')''');
    }
    return res;
  } catch (e) {
    logErrorToFile("Error inserting data into invoice item Table $e");
  }
}


Future<dynamic> insertTableSalesInvoicePayment(conn, {List<Payments>? pm,String? openingEntry})async {
  try {
    
    dynamic res;
     for (var element in pm!) {
      var insertItemQuery = 'INSERT INTO SalesInvoicePayment (id,mode_of_payment,amount,opening_name) ';
      res = conn.query('''$insertItemQuery VALUES('${element.name}','${element.modeOfPayment}','${element.amount}','${element.openingEntry}')''');
    }
    return res;
  } catch (e) {
    logErrorToFile("Error inserting data into invoice item Table $e");
  }
}

List<TempSalesInvoiceModel> salesInvoiceData = [];


Future<List<TempSalesInvoiceModel>> fetchFromSalesInvoice() async {
  try {
    // query the query
    final conn = await getDatabase();
    // final queryResult = await conn.query("""
    //   SELECT * FROM SalesInvoice
    //   WHERE opening_name = '${posOpeningList.isNotEmpty ? posOpeningList[0].name : null}'
    //   ORDER BY posting_date DESC;
    // """);

    final queryResult = await conn.query("""
      SELECT * FROM SalesInvoice
     
      ORDER BY posx_date DESC;
    """);
  
      salesInvoiceData = queryResult
          .map((row) => TempSalesInvoiceModel.fromJson(row.fields))
          .toList().cast<TempSalesInvoiceModel>();

    await closeDatabase(conn);
    return salesInvoiceData ;
  } catch (e) {
    logErrorToFile("Error fetching data from SalesInvoice Table $e");
    return [];
  } 
}

List<TempSalesInvoiceItemModel> salesInvoiceItemModelList =[];
Future <List<TempSalesInvoiceItemModel>> fetchFromSalesInvoiceItem() async {
  try {
    final conn = await getDatabase();
    final queryResult = await conn.query("""
      SELECT * FROM SalesInvoiceItem;
    """);
      salesInvoiceItemModelList = queryResult.map((row) => TempSalesInvoiceItemModel.fromJson(row.fields))
          .toList().cast<TempSalesInvoiceItemModel>();
  
    await closeDatabase(conn);
    return salesInvoiceItemModelList;
  } catch (e) {
    logErrorToFile("Error fetching data from SalesInvoice Table $e");
     print("Error fetching data from SalesInvoice Table $e");
    return [];
  } 
}

List<TempSalesInvoiceModel> salesInvoiceInProgressData = [];


Future<List<TempSalesInvoiceModel>> fetchFromSalesInvoiceInProgress() async {
  try {
    final conn = await getDatabase();
    final queryResult = await conn.query("""
      SELECT * FROM SalesInvoice
      WHERE status = 'In Progress'
      ORDER BY posx_date DESC;
    """);
  
      salesInvoiceInProgressData = queryResult
          .map((row) => TempSalesInvoiceModel.fromJson(row.fields))
          .toList().cast<TempSalesInvoiceModel>();

    await closeDatabase(conn);
    return salesInvoiceInProgressData ;
  } catch (e) {
    logErrorToFile("Error fetching data from SalesInvoice Table $e");
    return [];
  } 
}


Future<bool> updateSalesInvoiceSynced(String invoiceName, String status, String erpnextID, String backgroundJobID) async {
  final conn = await getDatabase();
  try {
    await conn.query(
      "UPDATE SalesInvoice SET status = '$status', submitted_at='${DateTime.now().toString()}', erpnext_id ='$erpnextID', background_job_id='$backgroundJobID' WHERE name = ?",
      [invoiceName],
    );
    await conn.query(
      "UPDATE SalesInvoicePayment SET erpnext_invoice_id ='$erpnextID' WHERE id = ?",
      [invoiceName],
    );
    await conn.close();
    return true;
  } catch (e) {
    logErrorToFile("❌ Error updating SalesInvoice synced status: $e");
    await conn.close();
    return false;
  }
}

Future<bool> updateSalesInvoiceSyncedFinal(String invoiceName, String status, String erpnextID, String creation) async {
  final conn = await getDatabase();
  try {
    await conn.query(
      "UPDATE SalesInvoice SET status = '$status', submitted_at='${DateTime.now().toString()}', erpnext_si_date ='$creation',  erpnext_id ='$erpnextID' WHERE name = ?",
      [invoiceName],
    );
    await conn.query(
      "UPDATE SalesInvoicePayment SET erpnext_invoice_id ='$erpnextID' WHERE id = ?",
      [invoiceName],
    );
    await conn.close();
    return true;
  } catch (e) {
    logErrorToFile("❌ Error updating SalesInvoice synced status: $e");
    await conn.close();
    return false;
  }
}

Future<bool> updateSalesInvoiceErrorFinal(String invoiceName, String status, String message) async {
  final conn = await getDatabase();
  try {
    await conn.query(
      "UPDATE SalesInvoice SET status = '$status', messageStatus = '$message' WHERE name = ?",
      [invoiceName],
    );

    await conn.close();
    return true;
  } catch (e) {
    logErrorToFile("❌ Error updating SalesInvoice synced status: $e");
    await conn.close();
    return false;
  }
}

Future<bool> updateCancelledInvoice(String invoiceName, String invoiceStatus) async {
  final conn = await getDatabase();
  try {
    await conn.query(
      "UPDATE SalesInvoice SET invoice_status = '$invoiceStatus' WHERE name = ?",
      [invoiceName],
    );
    await conn.close();
    return true;
  } catch (e) {
    logErrorToFile("❌ Error updating SalesInvoice cancelled status: $e");
    await conn.close();
    return false;
  }
}

Future<bool> updateErrorRetryInvoice(String invoiceName, String invoiceStatus) async {
  final conn = await getDatabase();
  try {
    await conn.query(
      "UPDATE SalesInvoice SET status = '$invoiceStatus', messageStatus = '' WHERE name = ?",
      [invoiceName],
    );
    await conn.close();
    return true;
  } catch (e) {
    logErrorToFile("❌ Error updating SalesInvoice retry status: $e");
    await conn.close();
    return false;
  }
}

List<Payments> salesInvoicePaymentData = [];

Future<List<Payments>> fetchSalesInvoicePaymentByName(String name) async {
  try {
    // query the query
    final conn = await getDatabase();
    final queryResult = await conn.query("""SELECT 
                        m.name AS mode_of_payment,
                        COALESCE(SUM(p.amount), 0) AS amount
                      FROM 
                        `ModeOfPayment` m
                      LEFT JOIN 
                        `SalesInvoicePayment` p 
                        ON m.name = p.mode_of_payment AND p.opening_name = '$name'
                      LEFT JOIN 
                        `SalesInvoice` si
                        ON p.id = si.name
                      WHERE 
                        si.invoice_status = 'Submitted' OR si.name IS NULL
                      GROUP BY 
                        m.name
                      ORDER BY 
                        m.name ASC;

                """);  
      salesInvoicePaymentData = queryResult
          .map((row) => Payments.fromJson(row.fields))
          .toList().cast<Payments>();

    await closeDatabase(conn);
    return salesInvoicePaymentData ;
  } catch (e) {
    logErrorToFile("Error fetching data from SalesInvoice Table $e");
    return [];
  } 
}


Future<dynamic> fetchSalesInvoicePaymentByNameClose(String name) async {
  try {
    // query the query
    final conn = await getDatabase();
        final queryResult = await conn.query("""
      SELECT 
        m.name AS mode_of_payment,
        COALESCE(opening.amount, 0) AS opening_amount,
        COALESCE(opening.amount, 0) AS expected_amount,
        COALESCE(SUM(p.amount), 0) AS closing_amount,
        (
          COALESCE(SUM(p.amount), 0) - COALESCE(opening.amount, 0)
        ) AS difference
      FROM 
        `ModeOfPayment` m
   
      LEFT JOIN 
        `PosOpening` opening
          ON m.name = opening.paymentMode AND opening.name = '$name'
      LEFT JOIN 
        `SalesInvoicePayment` p
          ON m.name = p.mode_of_payment AND p.opening_name = '$name'
      LEFT JOIN 
        `SalesInvoice` si
          ON p.opening_name = si.opening_name

      WHERE 
       si.invoice_status != 'Cancelled' AND m.name != 'Loyalty Points' 
      GROUP BY 
        m.name
      ORDER BY 
        m.name ASC;
    """);
 
      
          

    await closeDatabase(conn);
    return queryResult.map((row) => row.fields).toList();
  } catch (e) {
    logErrorToFile("Error fetching data from payment closing data $e");
    return [];
  } 
}
//return invoice details
Future<Map<String, dynamic>> fetchSalesInvoiceDetailsToReturn(String name) async {
  final conn = await getDatabase();
  try {
    final invoiceResult = await conn.query(
      "SELECT * FROM SalesInvoice WHERE name = ?",
      [name],
    );
    if (invoiceResult.isEmpty) {
      await conn.close();
      return {};
    }
    final invoice = invoiceResult.first.fields;
    await conn.close();
    return invoice;
  }  catch (e) {
    logErrorToFile("Error fetching invoice details: $e");
    await conn.close();
    return {};
  }
}

Future<List<Item>> fetchSalesInvoiceItemDetailsToReturn(String name) async {
  final conn = await getDatabase();
  try {
    final invoiceResult = await conn.query(
      "SELECT * FROM SalesInvoiceItem WHERE name = ?",
      [name],
    );
    if (invoiceResult.isEmpty) {
      await conn.close();
      return [];
    }
    final List<Item> invoice = invoiceResult.map<Item>((row) {
      
      final Map<String, dynamic> fields =
          Map<String, dynamic>.from(row.fields);

    
      if (fields.containsKey('rate')) {
        fields['new_net_rate'] = fields['rate'];
        fields['new_rate'] = fields['rate'];
        fields['standard_rate'] = fields['rate'];
        fields['vat_value'] = int.tryParse(fields['item_tax_rate']) ;
        fields['item_total'] = fields['net_amount'];
        fields['total_with_vat_prev'] = fields['net_amount'];
        fields['name'] = fields['item_code'];
      
      }
      if (fields.containsKey('qty')) {
        fields['qty'] = fields['qty'] ;
        fields['validate_qty'] = fields['qty'] ;
      }

  return Item.fromJson(fields);
}).toList();


    print("Invoice Items: ${invoice[0]}");
    await conn.close();
   
    return invoice;
  }  catch (e) {
    logErrorToFile("Error fetching invoice details: $e");
    print("Error fetching invoice details: $e");
    await conn.close();
    return [];
  }
}


Future<Map<String, dynamic>> fetchSalesInvoiceToPrint(String name) async {
  final conn = await getDatabase();
  try {
   
    final invoiceResult = await conn.query(
      "SELECT name AS invoice_no, is_return, change_amount, sales_person,  gross_total AS grossTotal, customer_name,   discount AS discountAmount , vat as vatTotal, net_total AS netTotal,  grand_total AS grandTotal, posx_date AS postingDate, customer FROM SalesInvoice WHERE name = ?",
      [name],
    );
    if (invoiceResult.isEmpty) {
      await conn.close();
      return {};
    }
    final invoice = invoiceResult.first.fields;

    
    final itemsResult = await conn.query(
      "SELECT * FROM SalesInvoiceItem WHERE name = ?",
      [name],
    );
    final items = itemsResult.map((row) => row.fields).toList();

    
    final paymentsResult = await conn.query(
      "SELECT mode_of_payment, amount FROM SalesInvoicePayment WHERE id = ?",
      [name],
    );
    final paymentModes = paymentsResult.map((row) => row.fields).toList();
    
    final totalQty = items.fold<int>(
      0,
      (int sum, dynamic item) {
        final qty = item['qty'];
        if (qty is int) return sum + qty;
        if (qty is double) return sum + qty.toInt();
        if (qty is String) return sum + (int.tryParse(qty) ?? 0);
        return sum;
      },
    );
    
    final paidAmount = paymentModes.fold<double>(
      0.0,
      (double sum, dynamic p) {
        final amount = p['amount'];
        if (amount is double) return sum + amount;
        if (amount is int) return sum + amount.toDouble();
        if (amount is String) return sum + (double.tryParse(amount) ?? 0.0);
        return sum;
      },
    );

    await conn.close();
    
    return {
      "grandTotal": invoice['grandTotal'],
      "postingDate": invoice['postingDate'],
      'served_by':invoice['sales_person'],
      "isReturn": invoice['is_return'] ?? "No",
      "customer": invoice['customer'],
      "invoice_no": invoice['invoice_no'],
      "vatTotal": invoice['vatTotal'] ?? 0.0,
      "netTotal": invoice['netTotal'],
      "discountAmount": invoice['discountAmount'] ?? 0.0,
      "items": items,
      "totalQty": totalQty,
      "paymentModes": paymentModes,
      "paidAmount": paidAmount,
      "grossTotal":invoice['grossTotal'],
      "customerName": invoice['customer_name'] ?? "",
      'change_amount':invoice['change_amount'] ?? 0.0,
    };
  }  catch (e) {
    logErrorToFile("Error fetching invoice for logErrorToFile: $e");
    await conn.close();
    return {};
  }
}