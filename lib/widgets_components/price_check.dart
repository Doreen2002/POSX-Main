import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/get_item_queries.dart';
import 'package:offline_pos/models/item_model.dart';
import 'package:offline_pos/widgets_components/all_items.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/widgets_components/opening_entry.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';

final bool fromCart = false;

final TextEditingController _controller = TextEditingController();

// Assuming you have a controller for your cart

// Example item list
final List<String> itemNames =
    itemListdata.map((item) => item.itemName.toString() ).toList();

String? selectedItem;
String rate = '0.00';
dynamic stock = 0;
double vat = 0;
dynamic matchedItem = TempItem(name: '', itemCode: '');

Widget priceCheckModal(
  BuildContext context,
  model,
  void Function(void Function()) setState,
) {
  final currencyPrecision = 3;
  return Container(
    width: 150.w,
    height: 570.h,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10.r)),
      color: Colors.white,
    ),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Price Check",
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2B3691),
          ),
        ),
        SizedBox(height: 12.h),
        TypeAheadField<String>(
          controller: _controller,
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              style: TextStyle(fontSize: 5.sp, color: Colors.black),
              decoration: InputDecoration(
                labelText: "Scan Barcode or Enter Item Name",
                labelStyle: TextStyle(color: Color(0xFF2B3691)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.r),
                  borderSide: const BorderSide(color: Color(0xFF2B3691)),
                ),
                suffixIcon: Visibility(
                  visible: controller.text.isNotEmpty,
                  child: InkWell(
                    onTap: () {
                      controller.clear();
                      selectedItem = null;
                    },
                    child: Icon(
                      Icons.clear,
                      size: 30.r,
                      color: Color(0xFF2B3691),
                    ),
                  ),
                ),
              ),
            );
          },
          decorationBuilder:
              (context, child) => Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(6.r),
                child: child,
              ),
          suggestionsCallback: (pattern) async {
            if (pattern.trim().isEmpty) {
              return []; 
            }
            // if (pattern.length < 1) {

            //  model.notifyListeners();
            // }
            // }
            final _original = itemListdata;

            // Find all batch items matching the pattern
            final matchingBatches =
                batchListdata
                    .where(
                      (batch) => (batch.batchId ?? '').toLowerCase().contains(
                        pattern.toLowerCase(),
                      ),
                    )
                    .toList();

            final matchingBarcodes =
                barcodeListdata
                    .where(
                      (barcode) => (barcode.barcode ?? '')
                          .toLowerCase()
                          .contains(pattern.toLowerCase()),
                    )
                    .toList();

            final relatedItemCodes =
                matchingBatches
                    .map((batch) => batch.item)
                    .where((code) => code != null)
                    .cast<String>()
                    .toSet();
            relatedItemCodes.addAll(
              matchingBarcodes
                  .map((barcode) => barcode.itemCode)
                  .where((code) => code != null)
                  .cast<String>(),
            );

            return itemListdata
                .where(
                  (item) =>
                      (item.itemCode ?? "").toLowerCase().contains(
                        pattern.toLowerCase(),
                      ) ||
                      (item.itemName ?? "").toLowerCase().contains(
                        pattern.toLowerCase(),
                      ) ||
                      relatedItemCodes.contains(item.itemCode),
                )
                .map((item) => item.itemName.toString())
                .take(4)
                .toList();
          },

          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion, style: TextStyle(fontSize: 5.sp)),
            );
          },
          onSelected: (suggestion) {
            setState(() {
              selectedItem = suggestion;
              _controller.text = suggestion;
              matchedItem = OptimizedDataManager.getItemByName(selectedItem ?? '') ?? TempItem(name: '', itemCode: '');

              rate = matchedItem.standardRate.toString();
              stock = matchedItem.openingStock;
              vat = matchedItem.standardRate * matchedItem.itemvat / 100;
            });
          },
          // onSelected: (suggestion) {
          //   selectedItem = suggestion;
          //   _controller.text = suggestion;
          //   matchedItem =
          //       itemListdata
          //           .where((item) => item.itemName == selectedItem)
          //           .first;

          //   rate = matchedItem.valuationRate.toString();
          //   stock = matchedItem.openingStock;
          // },
        ),
        SizedBox(height: 3.h),
        if (selectedItem != null)
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE1E6FD),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFF2B3691), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$selectedItem",
                  style: TextStyle(
                    fontSize: 6.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2B3691),
                  ),
                ),

                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      "Price: ${UserPreference.getString(PrefKeys.currency)} ${double.tryParse(rate)?.toStringAsFixed(currencyPrecision) ?? rate}",
                      style: TextStyle(
                        fontSize: 5.sp,
                        color: Color(0xFF2B3691),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      // "VAT: $stock",
                      "VAT: ${UserPreference.getString(PrefKeys.currency)} ${vat.toStringAsFixed(model.decimalPoints)}",
                      style: TextStyle(
                        fontSize: 5.sp,
                        color: Color(0xFF2B3691),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      "Stock: $stock",
                      style: TextStyle(
                        fontSize: 5.sp,
                        color: Color(0xFF2B3691),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 160,
                  height: 80,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await addToCart(matchedItem, model, context).then((_) {
                        selectedItem = null;
                        matchedItem = null;
                        rate = '';
                        stock = 0;
                        _controller.clear();
                      });
                    },
                    icon: const Icon(Icons.add_shopping_cart, size: 28.0),
                    label: const Text(
                      "Add to Cart",
                      style: TextStyle(fontSize: 18), // bigger text
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006A35),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero, // so height is consistent
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 160,
                  height: 80,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedItem = null;
                        matchedItem = null;
                        rate = '';
                        stock = 0;
                        _controller.clear();
                      });
                      Navigator.pop(context);
                      model.searchFocusNode.requestFocus();
                    },
                    icon: const Icon(Icons.close, size: 28.0),
                    label: const Text(
                      "Discard",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF2B3691),
                        width: 2,
                      ),
                      foregroundColor: const Color(0xFF2B3691),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Future<void> addToCart(item, model, context) async {
  try
  {
Navigator.pop(context);
  getPosOpening();
  model.notifyListeners();
  if (posOpeningList.isEmpty) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Notice",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, size: 50, color: Color(0xFF006A35)),
                  const SizedBox(height: 10),
                  Text(
                    'Notice',
                    style: TextStyle(
                      color: Color(0xFF006A35),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Create POS Opening Entry',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFF444444)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF006A35),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();

                            await showDialog(
                              context: context,
                              builder: (context) {
                                return openingEntryDialog(
                                  context,
                                  model,
                                  onNext: () {
                                    Future.microtask(() {
                                      getPosOpening();
                                      if (posOpeningList.isNotEmpty) {
                                        addItemsToCartTable(
                                          model,
                                          context,
                                          item,
                                        );
                                      }
                                    });
                                  },
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Create POS Opening',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0xFF006A35)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xFF006A35)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  if (posOpeningList.isNotEmpty) {
    addItemsToCartTable(model, context, item);
  }
}
catch(e)
{
  logErrorToFile("error $e");
}

  }
  