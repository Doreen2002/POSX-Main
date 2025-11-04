import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/api_requests/items.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';
import 'package:offline_pos/database_conn/insert_customer.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/database_conn/users.dart';
import 'package:offline_pos/models/batch_list_model.dart';
import 'package:offline_pos/models/customer_list_model.dart';
import 'package:offline_pos/models/sales_person.dart';
import 'package:offline_pos/models/single_invoice_data.dart';
import 'package:offline_pos/database_conn/get_item_queries.dart' as batch;

import 'package:offline_pos/database_conn/sales.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

Widget completeOrderDialog(
  BuildContext context,
  CartItemScreenController model,
) {
  return StatefulBuilder(
    builder: (context, setState) {
      return IntrinsicHeight(
        child: Visibility(
          visible: model.isCompleteOrderTap == true,
          child: Padding(
            padding: EdgeInsets.only(left: 100.w, right: 100.w),
            child: Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0.r),
              ),
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title Row
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: Colors.blue,
                            size: 30.r,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Confirm Submission',
                            style: TextStyle(
                              fontSize: 6.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    Divider(color: Colors.grey.shade300),
                    SizedBox(height: 20.h),

                    // Content Message
                    Text(
                      'Are you sure you want to permanently submit the invoice?',
                      style: TextStyle(
                        fontSize: 6.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 30.h),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 25.w,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                              fontSize: 4.sp,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006A35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: 10.h,
                              horizontal: 25.w,
                            ),
                          ),
                          onPressed: () async {
                            await createInvoice(model);
                           
                            model.cartItems.clear();
                            model.isCompleteOrderTap = false;
                             model.isCheckOutScreen = false;
                            model.customerListController.clear();
                            model.customerListController.text = UserPreference.getString(PrefKeys.walkInCustomer) ?? "";
                            model.allItemsDiscountAmount.text = '';
                            model.allItemsDiscountPercent.text = '';
                            model.totalQTy = 0;
                            model.grossTotal = 0;
                            model.netTotal = 0;
                            model.vatTotal = 0;
                            model.grandTotal = 0;
                            model.showAddDiscount = false;
                            model.notifyListeners();

                           
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              fontSize: 4.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<dynamic> createInvoice(model) async {
  try{
     
   final match = await OptimizedDataManager.getCustomerByName(
     model.customerListController.text
   );
     final matchSalesPerson = salesPersonList.firstWhere(
        (c) => c.fullName == model.salesListController.text,
        orElse: () => SalesPerson(name: '', fullName: '')
      );

      model.customerData = match;
      model.salePersonID = matchSalesPerson.name;
   
  int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final conn = await getDatabase();
  final invoiceNo = 'INV-${UserPreference.getString(PrefKeys.branchID)}-${timestamp}';
  await fetchFromSalesPerson();
  await insertTableSalesInvoice(
    id: invoiceNo,
    name: invoiceNo,
    customer: model.customerData.name,
    customerName : model.customerData.customerName,
    posProfile: UserPreference.getString(PrefKeys.posProfileName),
    company: UserPreference.getString(PrefKeys.companyName),
    postingDate: model.printCurrDate ?? "",
    postingTime: model.printCurrTime ?? "",
    paymentDueDate: "",
    netTotal: model.netTotal,
    grandTotal: model.grandTotal,
    grossTotal: model.grossTotal,
    changeAmount: ((model.paidAmount - model.grandTotal) < 0) ? 0.00 : (model.paidAmount - model.grandTotal),
    status: 'Created',
    invoiceStatus: "Submitted",
    salesPerson: salesPersonList.firstWhere((salesPer)=>salesPer.fullName==model.salesListController.text, orElse: ()=>SalesPerson(name: '', fullName: '')).name ,
    vat: model.vatTotal,
    openingName: UserPreference.getString(PrefKeys.openingEntry),
    additionalDiscountPer: model.allItemsDiscountPercent.text.isNotEmpty ?  double.parse( model.allItemsDiscountPercent.text ) : 0.00,
    discount: model.allItemsDiscountAmount.text.isNotEmpty ?  double.parse( model.allItemsDiscountAmount.text ) : 0.00
  );
  await createInvoiceItem(model, conn, invoiceNo);
  await createPayment(model, conn, invoiceNo);
  await closeDatabase(conn);
  return invoiceNo;
  }
  catch (e) {
   
    logErrorToFile("Failed to create invoice: $e");
   
  }
 
}

Future<void> createInvoiceItem(model, conn, invoiceNo) async {
  ///<<<<<<--------Insert Invoice Item Data--------->>>>>>>>
  
  try
  {
      List<Items> temp = [];
  for (var element in model.cartItems) {
  
    Items aa = Items();
    aa.name = '$invoiceNo';
    aa.itemCode = element.itemCode;
    aa.itemName = element.itemName;
    aa.stockUom = element.stockUom;
    aa.rate =  element.newRate;
    aa.itemGroup = element.itemGroup;
    aa.qty = element.qty;
    aa.batchNo = element.batchNumberSeries ?? "";
    aa.serialNo = element.serialNo ?? "";
    aa.itemTaxRate = "${element.vatValue}";
    aa.priceListRate = element.standardRate;
    aa.basePriceListRate = element.standardRate;
    aa.amount = element.itemTotal;
    aa.netRate = element.totalWithVatPrev;
    aa.netAmount = element.totalWithVatPrev;
    aa.customVATInclusive =  0;
    aa.discountPercentage = element.singleItemDiscPer != null ? element.singleItemDiscPer?.toDouble() : 0.000;
    aa.discountAmount = element.singleItemDiscAmount != null ? element.singleItemDiscAmount?.toDouble() : 0.000;
    temp.add(aa);
    if(element.hasBatchNo == 1)
    {
       batch.batchListdata =  await batch.fetchFromBatch();
      final matchedBatch = OptimizedDataManager.getBatchByCode(
        element.batchNumberSeries ?? ''
      ) ?? BatchListModel(
              name: '',
              batchId: '',
              item: '',
              itemName: '',
              manufacturingDate: '',
              batchQty: 0,
              stockUom: '',
              expiryDate: '',
            );
    final batchQty = (matchedBatch.batchQty ?? 0) - element.qty;
    await updateItemsStockBatchDetails(batchQty, element.itemCode, matchedBatch.batchId);
    batch.batchListdata =  await batch.fetchFromBatch();

    }
   
  }
  await insertTableSalesInvoiceItem(conn, ici: temp);
  await updateItemsStockDetails(model.cartItems);
  itemListdata = await batch.fetchFromItem();
  }
  catch (e)
  {
    print("Failed to create invoice items: $e");
  }

}

Future<void> createPayment(model, conn, invoiceNo) async {
  List<Payments> temp2 = [];
  for (var element in model.paymentModes) {
    if (element.controller.text == null ||
        element.controller.text == "" ||
        element.controller.text == "0.000") {
      continue;
    }
    Payments pm = Payments();
    pm.name = invoiceNo;
    pm.modeOfPayment = element.name ?? "";
    pm.amount = double.parse(double.parse(element.controller.text ?? '0.000').toStringAsFixed(model.decimalPoints));
    pm.openingEntry = UserPreference.getString(PrefKeys.openingEntry);
    temp2.add(pm);
    if (pm.modeOfPayment == "Loyalty Points")
    {
      await updateCustomerLoyaltyPoints(model.customerData.name, double.parse(element.controller.text ?? '0.000'));
    }
  }
  await insertTableSalesInvoicePayment(
    conn,
    pm: temp2,
    openingEntry: UserPreference.getString(PrefKeys.openingEntry),
  );
}



void resetCalculations(CartItemScreenController model) {
  if (model.cartItems.isEmpty)
  {
    model.totalQTy = 0;
  model.grossTotal = 0;
  model.netTotal = 0;
  model.vatTotal = 0;
  model.grandTotal = 0;
  model.showAddDiscount = false;
  model.allItemsDiscountAmount.text = '';
  model.allItemsDiscountPercent.text = '';

  model.notifyListeners();
  }
  
}