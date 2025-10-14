import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:offline_pos/database_conn/insert_customer.dart';
import 'package:offline_pos/database_conn/sales.dart';
import 'package:offline_pos/models/customer_list_model.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';


  final storage = FlutterSecureStorage();
Future<dynamic> getPrint() async {
  String httpType = "https";
   String frappeInstance = UserPreference.getString(PrefKeys.baseUrl) ?? "";
  try {
   
    // Send GET request to fetch items
    final response = await http.get(
      Uri.parse('https://$frappeInstance/api/method/offline_pos_erpnext.API.sales.get_sales_print?print_format=POS%20Invoice'),
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
        return body['message'];
      }
    }
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}





Future<bool> createInvoiceRequest() async {
  try {
  List invoices = await fetchGroupedInvoiceData();
  bool allSucceeded = true;
  await UserPreference.getInstance();
  List invoiceSentToERP = [];
  for (var invoice in invoices) {
  
    double paidAmount = invoice["payments"]
    .map((p) => (p["amount"] ?? 0) as num)
    .fold(0.0, (prev, amount) => prev + amount);
    await updateSalesInvoiceSynced(invoice["name"], "Sent", "", "");
    invoiceSentToERP.add({
          'customer': invoice['customer'],
        'posting_date': invoice['posting_date'],
        'pos_profile':  UserPreference.getString(PrefKeys.posProfileName),
        'is_pos': 1,
        'set_warehouse': UserPreference.getString(PrefKeys.posProfileWarehouse),
        "sales_person":invoice["sales_person"],
        'apply_discount_on': UserPreference.getString(PrefKeys.applyDiscountOn),
        'additional_discount_percentage':invoice['additional_discount_percentage'],
        'discount_amount': invoice['discount_amount'],
        "paid_amount": paidAmount,
        'items': invoice['items'],
        'payments': invoice['payments'],
        'pos_invoice_id':invoice['name'],
        'pos_invoice_name':invoice['name'],
        'update_stock': 1,
        "invoice_status":invoice["invoice_status"],
        'docstatus': 0
        });
        }
        if (invoiceSentToERP.isNotEmpty)
        {
          final posSessionResponse = await http.post(
              Uri.parse('https://${UserPreference.getString(PrefKeys.baseUrl)}/api/method/offline_pos_erpnext.API.sales.create_pos_invoice'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
              },
              body: jsonEncode({
                'data':invoiceSentToERP,
                'job_name_prefix': "${UserPreference.getString(PrefKeys.branchID)}-${UserPreference.getString(PrefKeys.posProfileName)}",
              }),
            );
              if (posSessionResponse.statusCode == 200) {
              final posSessionBody = jsonDecode(posSessionResponse.body);
              
              var message = posSessionBody['message'];
              if ( message != null && message['status'] == 'success') {
               
                for (var invoice in invoiceSentToERP){
                await updateSalesInvoiceSynced(invoice['pos_invoice_id'], "In Progress", "", message['message']);
                }
              }
              else
              {
                for (var invoice in invoiceSentToERP){
                await updateSalesInvoiceSynced(invoice['pos_invoice_id'], "Failed", "", "");
                }
              }
      allSucceeded = false;
        }
          
        }
  return allSucceeded;
  } catch (e) {
    logErrorToFile("❌ Error occurred: $e");
    return false;
  }
}


Future<bool> submitInvoiceRequest() async {
try {
List invoices = await fetchFromSalesInvoiceInProgress();
if (invoices.isNotEmpty) {

  List<String> invoiceNames = invoices.map((invoice) => invoice.name.toString()).toList();
bool allSucceeded = true;
final posSessionResponse = await http.post(
Uri.parse('https://${UserPreference.getString(PrefKeys.baseUrl)}/api/method/offline_pos_erpnext.API.sales.get_submitted_invoices'),
headers: {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
},
body: jsonEncode({
  'invoices':invoiceNames,
}),
);
if (posSessionResponse.statusCode == 200) {
final posSessionBody = jsonDecode(posSessionResponse.body);
List invoices = await fetchFromSalesInvoiceInProgress();
var message = posSessionBody['message'];

if (message != null) {
  for (var invoice in invoiceNames) {
    for(var inv in message)
    {
      if (inv['pos_invoice_name'] == invoice) {
        await  updateSalesInvoiceSyncedFinal(invoice, "Synced", inv['name'], inv['creation']);
      }
    }
  }
} 
} else {
allSucceeded = false;
}   
}

}catch (e) {
  logErrorToFile("❌ Error occurred: $e");
  return false;
}
return true;
}


Future<bool> errorInvoiceRequest() async {
try {
List invoices = await fetchFromSalesInvoiceInProgress();
if (invoices.isNotEmpty) {

  List<String> invoiceNames = invoices.map((invoice) => invoice.name.toString()).toList();
bool allSucceeded = true;
final posSessionResponse = await http.post(
Uri.parse('https://${UserPreference.getString(PrefKeys.baseUrl)}/api/method/offline_pos_erpnext.API.sales.get_error_invoices'),
headers: {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
},
body: jsonEncode({
  'invoices':invoiceNames,
}),
);
if (posSessionResponse.statusCode == 200) {
final posSessionBody = jsonDecode(posSessionResponse.body);
List invoices = await fetchFromSalesInvoiceInProgress();
var message = posSessionBody['message'];

if (message != null) {
  for (var invoice in invoiceNames) {
    for(var inv in message)
    {
      if (inv['reference_name'] == invoice) {
        await  updateSalesInvoiceErrorFinal(invoice, "Error", inv['error']);
      }
    }
  }
} 
} else {
allSucceeded = false;
}   
}

}catch (e) {
  logErrorToFile("❌ Error occurred: $e");
  return false;
}
return true;
}