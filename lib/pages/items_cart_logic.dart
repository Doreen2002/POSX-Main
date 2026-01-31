
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/database_conn/get_item_queries.dart'
    as fetchQueries;
import 'package:offline_pos/database_conn/holdcart.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/models/customer_list_model.dart';
import 'package:offline_pos/models/hold_cart.dart';
import 'package:offline_pos/models/hold_cart_item.dart';
import 'package:offline_pos/models/item_model.dart';
import 'package:offline_pos/models/item_price.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';

import 'package:offline_pos/widgets_components/all_items.dart';

import 'package:offline_pos/widgets_components/log_error_to_file.dart';



Future<bool> holdCartItem(model) async {
  try {
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final name =
        'HC-${UserPreference.getString(PrefKeys.branchID)}-${timestamp.toString()}';
    final date = DateTime.now().toString();
    final vat = model.vatTotal;
    await fetchQueries.fetchFromItem();
    model.itemListdata = fetchQueries.itemListdata;
    await insertIntoHoldCart(
      HoldCart(
        name: name,
        customer: model.customerListController.text,
        date: date,
        totalValAmount: model.grandTotal,
        vat: vat,
        discountAmount:
            model.allItemsDiscountAmount.text.isNotEmpty
                ? double.parse(model.allItemsDiscountAmount.text)
                : 0.00,
        discountPercent:
            model.allItemsDiscountPercent.text.isNotEmpty
                ? double.parse(model.allItemsDiscountPercent.text)
                : 0.00,
        totalAmount: model.grandTotal,
        totalQty: model.totalQTy,
      ),
    );

    for (final item in model.cartItems) {
      int idx = model.cartItems.indexOf(item) + 1;
      await insertIntoHoldCartItem(
        HoldCartItem(
          name: item.name,
          parentId: name,
          date: date,
          rate: item.newNetRate,
          qty: item.qty,
          itemCode: item.itemCode,
          itemName: item.itemName,
          itemGroup: item.itemGroup,
          stockUom: item.stockUom,
          discountAmount: item.singleItemDiscAmount,
          discountPercent: item.singleItemDiscPer,
          openingStock: item.openingStock,
          rateWithVat: item.itemTotal,
          batchNo: item.batchNumberSeries,
          vat: item.vatValue,
          totalAmount: item.totalWithVatPrev,
          idx: idx,
        ),
      );
    }
    model.notifyListeners();
    return true;
  } catch (e) {
    logErrorToFile("$e");
    return false;
  }
}

Future<void> scanItems(model, context, value) async {
  if (model.filteredItems.length == 1) {
      final item = model.filteredItems[0];
      await getPosOpening();
  

      if (posOpeningList.isEmpty) {
       await  showOpeningPOSDialog(context, model, item);
      }

      if (posOpeningList.isNotEmpty) {
       await  addItemsToCartTable(model, context, item);
      }
    }
    else {  
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(
                '$value :  not found.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B3691),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF018644),
                  foregroundColor: const Color(0xFFFFFFFF),
                  minimumSize: const Size(120, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      );
    },
  );
  }
   

   
    model.searchController.text = '';
    model.autoFocusSearchItem = true;
    model.hasFocus = '';
    model.searchFocusNode.requestFocus();
    model.notifyListeners();
}

Future<void> searchItems(model, val) async {
  try
  {
      final searchVal = val.toLowerCase();

  final itemMapByName = {
    for (var item in model.itemListdata) (item.itemName ?? '').toLowerCase(): item
  };
  final itemMapByCode = {
    for (var item in model.itemListdata) (item.itemCode ?? '').toLowerCase(): item
  };
  final itemMapByPLU = {
    for (var item in model.itemListdata) (item.plu ?? '').toLowerCase(): item
  };
  final itemMapByBatchSeries = {
    for (var item in model.itemListdata) (item.batchNumberSeries ?? '').toLowerCase(): item
  };
  final batchMap = {
    for (var batch in model.batchListdata) batch.batchId.toLowerCase(): batch
  };
  final barcodeMap = {
    for (var barcode in model.barcodeListdata) barcode.barcode.toLowerCase(): barcode
  };

  model.filteredItems = [
    if (itemMapByName.containsKey(searchVal)) itemMapByName[searchVal],
    if (itemMapByCode.containsKey(searchVal)) itemMapByCode[searchVal],
    if (itemMapByPLU.containsKey(searchVal)) itemMapByPLU[searchVal],
    if (itemMapByBatchSeries.containsKey(searchVal)) itemMapByBatchSeries[searchVal],
    if (barcodeMap.containsKey(searchVal) && barcodeMap[searchVal]?.itemCode != null)
      ..._getItemWithBarcodeUom(barcodeMap[searchVal], itemMapByCode),
  ].whereType().toList();

  if (model.filteredItems.length == 1) return;

  if (batchMap.containsKey(searchVal)) {
    final batch = batchMap[searchVal];
    final relatedItem = itemMapByCode[batch?.item?.toLowerCase()];
    if (relatedItem != null && !model.filteredItems.contains(relatedItem)) {
      model.filteredItems.add(relatedItem);
    }
  }
  if (model.filteredItems.length == 1) return;

  if (barcodeMap.containsKey(searchVal)) {
    final barcode = barcodeMap[searchVal];
    final relatedItem = itemMapByCode[barcode?.itemCode?.toLowerCase()];
    if (relatedItem != null && !model.filteredItems.contains(relatedItem)) {
     
      if (barcode?.uom != null && barcode!.uom!.isNotEmpty) {
        relatedItem.stockUom = barcode.uom;
      }
      model.filteredItems.add(relatedItem);
    }
  }
  }
  catch(e){
    logErrorToFile("Error searching items for value $val: $e");
    print("Error searching items for value $val: $e");
  }

}

List<TempItem> _getItemWithBarcodeUom(dynamic barcode,  itemMapByCode) {
  if (barcode == null) return [];
  
  final itemCode = (barcode.itemCode ?? '').toString().toLowerCase();
  final item = itemMapByCode[itemCode];
  
  if (item == null) return [];
  
  if (barcode.uom != null && barcode.uom!.isNotEmpty) {
    item.stockUom = barcode.uom;
    
  }
  
  return [item];
}
