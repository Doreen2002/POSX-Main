import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:offline_pos/api_requests/customer.dart';
import 'package:offline_pos/api_requests/items.dart';
import 'package:offline_pos/api_requests/license_details.dart';
import 'package:offline_pos/api_requests/pos.dart';
import 'package:offline_pos/api_requests/post_pos_entry.dart';
import 'package:offline_pos/api_requests/pricing_rules.dart';
import 'package:offline_pos/api_requests/sales.dart';
import 'package:offline_pos/api_requests/users.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/create_customer_table.dart';
import 'package:offline_pos/database_conn/create_payment_tables.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/database_conn/create_pricing_rule_tables.dart';
import 'package:offline_pos/database_conn/get_customer.dart';
import 'package:offline_pos/database_conn/get_item_queries.dart';
import 'package:offline_pos/database_conn/get_payment.dart';
import 'package:offline_pos/database_conn/get_pricing_rules.dart';
import 'package:offline_pos/database_conn/holdcart.dart';
import 'package:offline_pos/database_conn/sales.dart';
import 'package:offline_pos/database_conn/users.dart';
import 'package:offline_pos/models/uom.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';
import 'create_item_tables.dart';
import 'mysql_conn.dart';
import 'package:offline_pos/models/user.dart';
import 'package:offline_pos/globals/global_values.dart';
List itemGroupdata = [];
List customerDataList = [];
List modeOfPaymentList = [];
List posProfileList = [];
List itemListdata = [];
List pricingRuleListdata = [];
List pricingRuleItemListdata = [];
List pricingRuleItemGroupListdata = [];
List pricingRuleBrandListdata = [];

BuildContext? dialogContext ;

Future<void> dbSync(context, notifyListeners)async {
  await UserPreference.getInstance();
      bool hasInternet = await InternetConnection().hasInternetAccess;
  try {
    if (hasInternet) {
      onofflineSync(context);
      return;
    } else if (hasInternet) {
      onlineSync(context, notifyListeners);
    } else {
      dbSyncErrorDialog(
        context,
        "Unable to connect to the internet. Please try again later.",
      );
      return;
    }
  } catch (e) {
    logErrorToFile("Error during sync: $e");
    // Optionally show an error dialog
  }
}

// void onlineSync(context) async {
//   AwesomeDialog(
//     context: context,
//     dialogType: DialogType.noHeader,
//     animType: AnimType.scale,
//     dismissOnTouchOutside: false,
//     width: 600,
//     dismissOnBackKeyPress: false,
//     barrierColor: Colors.black.withOpacity(0.4),
//     body: const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(
//               Color.fromRGBO(0, 137, 255, 1.0),
//             ),
//           ),
//           SizedBox(height: 24),
//           Text(
//             'Syncing your database...',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Please wait a moment',
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 14, color: Colors.black54),
//           ),
//         ],
//       ),
//     ),
//     showCloseIcon: false,
//   ).show();
void onlineSync(context, notifyListeners)async {
  try{
    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext ctx) {
      dialogContext = ctx;
      return Container(
        color: Colors.black.withOpacity(0.4),
        child: const Center(
          child: Material(
            color: Colors.white,
            elevation: 10,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(0, 137, 255, 1.0),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Syncing your database...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please wait a moment',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  
  if (UserPreference.getBool(PrefKeys.isOfflinePOSSetup) == true) {
   
    customerDataList = await fetchFromCustomer();
    itemListdata = await fetchFromItem();
    salesPersonList = await fetchFromSalesPerson();
    modeOfPaymentList = await fetchFromModeofPayment();
    posProfileList = await fetchFromPosProfile();
    batchListdata = await fetchFromBatch();
    barcodeListdata = await fetchFromBarcode();
    pricingRuleListdata = await fetchFromPricingRules();
    pricingRuleItemListdata = await fetchFromPricingRuleItems();
    pricingRuleItemGroupListdata = await fetchFromPricingRuleItemGroups();
    pricingRuleBrandListdata = await fetchFromPricingRuleBrands();
    
    // Load optimized Maps for O(1) lookups (replaces O(n) List searches)
    await OptimizedDataManager.loadAllDataMaps();
    logErrorToFile("OptimizedDataManager: Maps loaded after sync - ${OptimizedDataManager.getDataCounts()}");
   
   if(dialogContext != null  && Navigator.canPop(dialogContext!))
   {
    if (Navigator.canPop(dialogContext!)) {
    Navigator.of(dialogContext!).pop();
   }
   
  }
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
      }); 
     await sync();
  }

  else  if (UserPreference.getBool(PrefKeys.isOfflinePOSSetup) == false) {
    await sync();
    await Future.delayed(const Duration(seconds: 360), ()async{
      customerDataList = await fetchFromCustomer();
    itemListdata = await fetchFromItem();
    salesPersonList = await fetchFromSalesPerson();
    modeOfPaymentList = await fetchFromModeofPayment();
    posProfileList = await fetchFromPosProfile();
     batchListdata = await fetchFromBatch();
     barcodeListdata = await fetchFromBarcode();
     pricingRuleListdata = await fetchFromPricingRules();
     pricingRuleItemListdata = await fetchFromPricingRuleItems();
     pricingRuleItemGroupListdata = await fetchFromPricingRuleItemGroups();
     pricingRuleBrandListdata = await fetchFromPricingRuleBrands();
   if(dialogContext != null  && Navigator.canPop(dialogContext!))
   {
    if (Navigator.canPop(dialogContext!)) {
    Navigator.of(dialogContext!).pop();
   }

  }
    }); 
    
  }


  await UserPreference.putBool(PrefKeys.isOfflinePOSSetup, true);
    customerDataList = await fetchFromCustomer();
    itemListdata = await fetchFromItem();
    salesPersonList = await fetchFromSalesPerson();
    modeOfPaymentList = await fetchFromModeofPayment();
    posProfileList = await fetchFromPosProfile();
    pricingRuleListdata = await fetchFromPricingRules();
    pricingRuleItemListdata = await fetchFromPricingRuleItems();
    pricingRuleItemGroupListdata = await fetchFromPricingRuleItemGroups();
    pricingRuleBrandListdata = await fetchFromPricingRuleBrands();
 
  }
  catch(e)
  {
    logErrorToFile("$e");
  }
  finally
  {
     if(dialogContext != null  && Navigator.canPop(dialogContext!))
  {
      if (Navigator.canPop(dialogContext!)) {
      Navigator.of(dialogContext!).pop();
      }

  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
      });
  }
  
}




void onofflineSync(context) async {
  late BuildContext dialogContext;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext ctx) {
      dialogContext = ctx;
      return Container(
        color: Colors.black.withOpacity(0.4),
        child: const Center(
          child: Material(
            color: Colors.white,
            elevation: 10,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(0, 137, 255, 1.0),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Syncing from offline database...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please wait a moment',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  customerDataList = await fetchFromCustomer();
  itemListdata = await fetchFromItem();
  salesPersonList = await fetchFromSalesPerson();
  modeOfPaymentList = await fetchFromModeofPayment();
  posProfileList = await fetchFromPosProfile();
  batchListdata = await fetchFromBatch();
  pricingRuleListdata = await fetchFromPricingRules();
  pricingRuleItemListdata = await fetchFromPricingRuleItems();
  pricingRuleItemGroupListdata = await fetchFromPricingRuleItemGroups();
  pricingRuleBrandListdata = await fetchFromPricingRuleBrands();
  Navigator.of(dialogContext).pop();
}

Future<dynamic> reloadItems() async {
  await UserPreference.getInstance();

  try {
    // Open the connection if it is not already opened
    final conn = await getDatabase();

    itemListdata = await fetchFromItem();
    batchListdata = await fetchFromBatch();
    pricingRuleListdata = await fetchFromPricingRules();
    pricingRuleItemListdata = await fetchFromPricingRuleItems();
    pricingRuleItemGroupListdata = await fetchFromPricingRuleItemGroups();
    pricingRuleBrandListdata = await fetchFromPricingRuleBrands();
    await closeDatabase(conn);
    // await closeDatabase(conn);
  } catch (e) {
    logErrorToFile("Error: $e");
    return null; // Handle the error
  }

  return;
}

//sync function
Future <void> sync() async {
   await activateLicenseRequest(
     "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
    UserPreference.getString(PrefKeys.deviceID)!,
    UserPreference.getString(PrefKeys.licenseKey)!,
  );
  await createModeOfPaymentTable();
  await createTablePosProfile();
  await createTableUser();
  await posProfileRequest(
    "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
    UserPreference.getString(PrefKeys.userName)!,
  );
 
  await createTableCustomer();
  await createTableItem();
  await createSalesPersonTable();
  await createSalesInvoiceItemTable();
  await createSalesInvoiceTable();
  await createSalesInvoicePayment();
  await createTableBatch();
  await createTableSerial();
  await createHoldCartTable();
  await createHoldCartItemTable();
  await createTablePosOpening();
  await createTablePosClosing();
  await createPricingRulesTable();
  await createPricingRuleItemsTable();
  await createPricingRuleItemGroupsTable();
  await createPricingRuleBrandsTable();
  await itemRequest(
    "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
    UserPreference.getString(PrefKeys.userName)!,
  );
  await customerRequest("$transferProtocol", UserPreference.getString(PrefKeys.baseUrl)!);
  await batchRequest(
    "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
    UserPreference.getString(PrefKeys.userName)!,
  );
  await barcodeRequest(  "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
    UserPreference.getString(PrefKeys.userName)!);
  await pricingRulesRequest(
    "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
    UserPreference.getString(PrefKeys.userName)!,
  );
  await itemPriceRequest(
    "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
  );
  await uomRequest(
    "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
  );
  await insertUserTable(
    d: [
      User(
        name: UserPreference.getString(PrefKeys.userName)!,
        fullName: UserPreference.getString(PrefKeys.userName)!,
        username: UserPreference.getString(PrefKeys.userName)!,
        password: UserPreference.getString(PrefKeys.password)!,
      ),
    ],
  );
  await salesPersonRequest(
    "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
  );
  customerDataList = await fetchFromCustomer();
  itemListdata = await fetchFromItem();
  salesPersonList = await fetchFromSalesPerson();
  modeOfPaymentList = await fetchFromModeofPayment();
  posProfileList = await fetchFromPosProfile();
  itemPriceListdata = await  fetchFromItemPrice();
  UOMListdata = await fetchFromUOM();
   batchListdata = await fetchFromBatch();
   barcodeListdata = await fetchFromBarcode();
  await fetchFromBatch();
}

//sync function
Future<void> syncData(context, model) async {
  try{
      // if(isSyncing){
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       backgroundColor: Color(0xFF018644),
      //       content: Text(
      //         'Auto Sync in progress',
      //         style: TextStyle(color: Colors.white, fontSize: 16),
      //       ),
      //     ),
      //   );
      //   return;
      // }
      // isSyncing = true;
  ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor:Color(0xFF018644),
          content: Text(
            'Syncing...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
  bool hasInternet = await InternetConnection().hasInternetAccess;
 if (hasInternet)
    {   
        await createopeningEntry();
        await createCustomerRequest(
          "$transferProtocol",
          UserPreference.getString(PrefKeys.baseUrl)!,
        );
        await updateCustomerRequest(
          "$transferProtocol",
          UserPreference.getString(PrefKeys.baseUrl)!,
        );
        await  createInvoiceRequest();
        await  closePOSTOERPnext();
        await posProfileRequest(
          "$transferProtocol",
          UserPreference.getString(PrefKeys.baseUrl)!,
          UserPreference.getString(PrefKeys.userName)!,
        );
        await batchRequest(
          "$transferProtocol",
          UserPreference.getString(PrefKeys.baseUrl)!,
          UserPreference.getString(PrefKeys.userName)!,
        );
          batchListdata = await fetchFromBatch();
        await itemRequest(
          "$transferProtocol",
          UserPreference.getString(PrefKeys.baseUrl)!,
          UserPreference.getString(PrefKeys.userName)!,
        );
        await customerRequest("$transferProtocol", UserPreference.getString(PrefKeys.baseUrl)!);
        
          await barcodeRequest(  "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
    UserPreference.getString(PrefKeys.userName)!);
     await itemPriceRequest(
    "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
  );
  await uomRequest(
    "$transferProtocol",
    UserPreference.getString(PrefKeys.baseUrl)!,
  );
        await salesPersonRequest(
        "$transferProtocol",
        UserPreference.getString(PrefKeys.baseUrl)!,
      );
    }
    
  await insertUserTable(
    d: [
      User(
        name: UserPreference.getString(PrefKeys.userName)!,
        fullName: UserPreference.getString(PrefKeys.userName)!,
        username: UserPreference.getString(PrefKeys.userName)!,
        password: UserPreference.getString(PrefKeys.password)!,
      ),
    ],
  );
  
  customerDataList = await fetchFromCustomer();
  itemListdata = await fetchFromItem();
  salesPersonList = await fetchFromSalesPerson();
  modeOfPaymentList = await fetchFromModeofPayment();
  posProfileList = await fetchFromPosProfile();
   batchListdata = await fetchFromBatch();
   barcodeListdata = await fetchFromBarcode();
   itemPriceListdata = await  fetchFromItemPrice();
    UOMListdata = await fetchFromUOM();
  await fetchFromBatch();
  await fetchFromPosOpening();
  await submitInvoiceRequest();
  await errorInvoiceRequest();
  model.notifyListeners();
 
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
   ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor:Color(0xFF018644),
          content: Text(
            'Syncing Complete',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
  }
  
  catch(e)
  {
     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor:Color(0xFF018644),
          content: Text(
            'Error during sync',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
  }
  finally
  {
    model.syncDataLoading = false;
    isSyncing = false;
  }
}

void dbSyncErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.white,
          titlePadding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(Icons.error_outline, color: Color(0xFFD32F2F), size: 50),
              SizedBox(height: 12),
              Text(
                'DB Sync Failed',
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xFFD32F2F),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),

          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006A35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
  );
}



Future<void> closePOSTOERPnext()
async{
  await fetchFromPosOpeningClosed();
  await fetchAllFromPosOpening();
  
   if (posOpeningClosedList.isNotEmpty) {
        for (var close in posOpeningClosedList)
        {
          closedSalesInvoiceData = await fetchFromClosedSalesInvoice((close.posOpeningEntry?? ""));
          
          if(closedSalesInvoiceData.isEmpty)
          {
            final closingEntries =await fetchSalesInvoicePaymentByNameClose((close.posOpeningEntry?? ""));
          final denominationEntries = await fetchAllFromPosClosingCurrencyDenomination(close.name ?? "");
          final openingEntry =allPosOpeningList.firstWhere((item)=>item.name == close.posOpeningEntry).erpnextID;
          await  closePosRequest({
          'pos_profile': UserPreference.getString(PrefKeys.posProfileName)!,
          'company': UserPreference.getString(PrefKeys.companyName)!,
          'user': UserPreference.getString(PrefKeys.userName)!,
          'pos_opening_entry':
              openingEntry,
          'pos_opening_amount': close.openingEntryAmount,
              "naming_series":close.name,
          'period_start_date': close.periodStartDate.toString(),
          'period_end_date': close.periodEndDate.toString(),
          'posting_date': DateTime.now().toString(),
          'payment_reconciliation':closingEntries,
          'denomination_entries':denominationEntries,
          'total_denomination_value': close.totalDenominationValue,
          'comment':close.comment
        });
        
        }
          }
           
          
       
      }
}