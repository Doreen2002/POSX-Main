
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

  final searchVal = val.toLowerCase();

  // **NEW: Weight Scale Barcode Detection**
  final enableWeightScale = UserPreference.getBool(PrefKeys.enableWeightScale) ?? false;
  final weightScalePrefix = UserPreference.getString(PrefKeys.weightScalePrefix) ?? "";
  
  // Check if weight scale is enabled and this is a weight scale barcode
  if (enableWeightScale && weightScalePrefix.isNotEmpty && val.startsWith(weightScalePrefix)) {
    final weightScaleItem = await parseWeightScaleBarcode(val, model);
    if (weightScaleItem != null) {
      model.filteredItems = [weightScaleItem];
      return; // Found weight scale item, exit early
    }
    // If weight scale parsing failed, continue with regular scanning
  }

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
      itemMapByCode[barcodeMap[searchVal]?.itemCode.toLowerCase()]
   
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
      model.filteredItems.add(relatedItem);
    }
  }
}

/// **ENHANCED: Weight Scale Barcode Parser**
/// Parses weight scale barcodes using comprehensive Weight Scale Settings
/// Supports multiple prefixes, position-based parsing, and check digit validation
Future<TempItem?> parseWeightScaleBarcode(String barcode, dynamic model) async {
  try {
    // Check if weight scale is enabled
    final enableWeightScale = UserPreference.getBool(PrefKeys.enableWeightScale) ?? false;
    if (!enableWeightScale) return null;
    
    // Get comprehensive weight scale configuration from synced settings
    final barcodeType = UserPreference.getString(PrefKeys.barcodeType) ?? "EAN-13";
    final barcodeLength = UserPreference.getInt(PrefKeys.barcodeLength) ?? 13;
    final actualPluDigits = UserPreference.getInt(PrefKeys.actualPluDigits) ?? 4;
    final validateCheckDigit = UserPreference.getBool(PrefKeys.validateCheckDigit) ?? false;
    final currency = UserPreference.getString(PrefKeys.currency) ;
    final currencyPrecision = UserPreference.getInt(PrefKeys.currencyPrecision) ?? 2;
    final valueType = UserPreference.getString(PrefKeys.valueType) ?? "price";
    final pluStartPosition = UserPreference.getInt(PrefKeys.pluStartPosition) ?? 3;
    final pluLength = UserPreference.getInt(PrefKeys.pluLength) ?? 5;
    final valueStartPosition = UserPreference.getInt(PrefKeys.valueStartPosition) ?? 8;
    final valueLength = UserPreference.getInt(PrefKeys.valueLength) ?? 5;
    
    // Get weight scale prefixes (array format)
    final prefixesJson = UserPreference.getString(PrefKeys.weightScalePrefixes) ?? "[]";
    List<dynamic> prefixes = [];
    try {
      prefixes = jsonDecode(prefixesJson);
    } catch (e) {
      // Fallback to legacy single prefix
      final legacyPrefix = UserPreference.getString(PrefKeys.weightScalePrefix) ?? "";
      if (legacyPrefix.isNotEmpty) {
        prefixes = [{"prefix": legacyPrefix, "description": "Legacy"}];
      }
    }
    
    // Validate barcode length matches configuration
    if (barcode.length != barcodeLength) {
      logErrorToFile("Weight scale barcode length mismatch: expected $barcodeLength, got ${barcode.length}");
      return null;
    }
    
    // Check if barcode matches any enabled prefix
    Map<String, dynamic>? matchedPrefix;
    for (var prefixData in prefixes) {
      final prefix = prefixData['prefix']?.toString() ?? '';
      if (prefix.isNotEmpty && barcode.startsWith(prefix)) {
        matchedPrefix = prefixData;
        break;
      }
    }
    
    if (matchedPrefix == null) {
      logErrorToFile("No matching weight scale prefix found for barcode: $barcode");
      return null;
    }
    
    // Validate check digit if enabled
    if (validateCheckDigit && (barcodeType == "EAN-13" || barcodeType == "UPC-A")) {
      if (!_validateBarcodeCheckDigit(barcode, barcodeType)) {
        logErrorToFile("Invalid check digit for barcode: $barcode");
        return null;
      }
    }
    
    // Extract PLU using position-based parsing
    final pluStr = barcode.substring(pluStartPosition - 1, pluStartPosition - 1 + pluLength);
    final valueStr = barcode.substring(valueStartPosition - 1, valueStartPosition - 1 + valueLength);
    
    // Extract actual PLU from encoded PLU (e.g., 09004 → 9004)
    final actualPluStr = _extractActualPlu(pluStr, actualPluDigits);
    
    // Find item by actual PLU using OptimizedDataManager (O(1) lookup)
    final foundItem = OptimizedDataManager.getItemByPLU(actualPluStr);
    if (foundItem == null) {
      logErrorToFile("No item found for PLU: $actualPluStr (from encoded: $pluStr)");
      return null;
    }
    
    // Parse value based on configuration
    final rawValue = int.tryParse(valueStr);
    if (rawValue == null) {
      logErrorToFile("Invalid value in barcode: $valueStr");
      return null;
    }
    
    // Calculate divisor based on currency precision
    final divisor = pow(10, currencyPrecision).toInt();
    
    // Determine item name and processing based on value type
    String itemDisplayName;
    if (valueType == "weight") {
      final weight = rawValue / divisor;
      itemDisplayName = "${foundItem.itemName} (${weight.toStringAsFixed(model.decimalPoints)}kg)";
    } else {
      // Default to price
      final totalPrice = rawValue / divisor;
      itemDisplayName = "${foundItem.itemName} (${matchedPrefix['description'] ?? 'Weight Scale'}: ${totalPrice.toStringAsFixed(currencyPrecision)} $currency)";
    }
    
    // Create weight-based item with comprehensive information
    final weightBasedItem = TempItem(
      name: "${foundItem.name}_WS_${DateTime.now().millisecondsSinceEpoch}",
      itemCode: foundItem.itemCode,
      itemName: itemDisplayName,
      plu: foundItem.plu,
      standardRate: foundItem.standardRate,
      stockUom: foundItem.stockUom,
      itemGroup: foundItem.itemGroup,
      image: foundItem.image,
      openingStock: foundItem.openingStock,
      itemvat: foundItem.itemvat,
      hasBatchNo: foundItem.hasBatchNo,
      hasExpiryDate: foundItem.hasExpiryDate,
      barcode: barcode, // Store the weight scale barcode
    );
    
    // Log successful parsing for debugging
    if (UserPreference.getBool('developer_mode') ?? false) {
      final displayValue = rawValue / divisor;
      logErrorToFile("Weight scale barcode parsed: $barcode → PLU: $actualPluStr, ${valueType == 'weight' ? 'Weight' : 'Price'}: ${displayValue.toStringAsFixed(currencyPrecision)} ${valueType == 'weight' ? 'kg' : currency}, Prefix: ${matchedPrefix['prefix']}");
    }
    
    return weightBasedItem;
    
  } catch (e) {
    logErrorToFile("Weight scale barcode parsing error: $e");
    return null;
  }
}

/// **NEW: Check Digit Validation**
/// Validates EAN-13 and UPC-A check digits
bool _validateBarcodeCheckDigit(String barcode, String barcodeType) {
  try {
    if (barcodeType == "EAN-13" && barcode.length == 13) {
      return _validateEAN13CheckDigit(barcode);
    } else if (barcodeType == "UPC-A" && barcode.length == 12) {
      return _validateUPCACheckDigit(barcode);
    }
    return true; // Skip validation for other types
  } catch (e) {
    logErrorToFile("Check digit validation error: $e");
    return false;
  }
}

/// **NEW: EAN-13 Check Digit Validation**
bool _validateEAN13CheckDigit(String barcode) {
  final digits = barcode.split('').map(int.parse).toList();
  final checkDigit = digits.last;
  final dataDigits = digits.take(12).toList();
  
  int sum = 0;
  for (int i = 0; i < dataDigits.length; i++) {
    sum += dataDigits[i] * (i % 2 == 0 ? 1 : 3);
  }
  
  final calculatedCheckDigit = (10 - (sum % 10)) % 10;
  return calculatedCheckDigit == checkDigit;
}

/// **NEW: UPC-A Check Digit Validation**
bool _validateUPCACheckDigit(String barcode) {
  final digits = barcode.split('').map(int.parse).toList();
  final checkDigit = digits.last;
  final dataDigits = digits.take(11).toList();
  
  int sum = 0;
  for (int i = 0; i < dataDigits.length; i++) {
    sum += dataDigits[i] * (i % 2 == 0 ? 3 : 1);
  }
  
  final calculatedCheckDigit = (10 - (sum % 10)) % 10;
  return calculatedCheckDigit == checkDigit;
}

/// **NEW: Extract Actual PLU**
/// Extracts actual PLU digits from encoded PLU field
String _extractActualPlu(String encodedPlu, int actualDigits) {
  // Remove leading zeros and extract rightmost digits
  final cleanPlu = encodedPlu.replaceFirst(RegExp(r'^0+'), '');
  if (cleanPlu.length <= actualDigits) {
    return cleanPlu;
  } else {
    // Take rightmost digits if longer than expected
    return cleanPlu.substring(cleanPlu.length - actualDigits);
  }
}

/// **NEW: Detect if scanned code is a customer QR**
/// Returns customer if QR detected, null otherwise
/// Format: POSXCUST:{customer_name}
Future<TempCustomerData?> detectCustomerQR(String scannedCode) async {
  try {
    // Pattern 1: Prefixed QR - POSXCUST:{customer_id}
    if (scannedCode.startsWith('POSXCUST:')) {
      final qrData = scannedCode;
      
      // Try O(1) in-memory lookup first
      final customer = OptimizedDataManager.getCustomerByQR(qrData);
      if (customer != null) {
        logErrorToFile("Customer QR detected: ${customer.customerName} (${customer.name})");
        return customer;
      }
      
      // Fallback: Database query if not in memory
      final dbCustomer = await getCustomerByQRFromDB(qrData);
      if (dbCustomer != null) {
        logErrorToFile("Customer QR found in DB: ${dbCustomer.customerName}");
        return dbCustomer;
      }
      
      logErrorToFile("Customer QR not found: $qrData");
      return null;
    }
    
    // Pattern 2: Plain customer ID (backward compatibility)
    if (scannedCode.startsWith('CUST-')) {
      final qrDataWithPrefix = 'POSXCUST:$scannedCode';
      final customer = OptimizedDataManager.getCustomerByQR(qrDataWithPrefix);
      if (customer != null) {
        logErrorToFile("Customer detected by ID: ${customer.name}");
        return customer;
      }
    }
    
    return null; // Not a customer QR
    
  } catch (e) {
    logErrorToFile("Customer QR detection error: $e");
    return null;
  }
}

/// Helper: Query customer from database by QR code
Future<TempCustomerData?> getCustomerByQRFromDB(String qrData) async {
  try {
    final conn = await getDatabase();
    final results = await conn.query(
      'SELECT * FROM Customer WHERE custom_qr_code_data = ? LIMIT 1',
      [qrData],
    );
    
    await conn.close();
    
    if (results.isNotEmpty) {
      final customerMap = results.first.fields;
      return TempCustomerData.fromJson(customerMap);
    }
    return null;
  } catch (e) {
    logErrorToFile("Customer QR DB query error: $e");
    return null;
  }
}