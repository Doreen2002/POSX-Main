import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/models/item_model.dart';
import 'package:offline_pos/models/item_price.dart';
import 'package:offline_pos/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';
import 'package:offline_pos/database_conn/get_item_queries.dart' as batch;
import 'package:offline_pos/models/batch_list_model.dart';
import 'package:offline_pos/models/item.dart';
import 'package:offline_pos/widgets_components/batch_dialog.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/widgets_components/opening_entry.dart';
import '../common_utils/app_colors.dart';
import '../common_widgets/single_text.dart';

class AllItemsWidget extends StatefulWidget {
  final CartItemScreenController model;
  const AllItemsWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<AllItemsWidget> createState() => _AllItemsWidgetState();
}

class _AllItemsWidgetState extends State<AllItemsWidget> {
  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    return Flexible(
      child: SizedBox(
        height: 0.4.sh,

        // width: 1.sw / 0.5.w,
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(
              const Color(0x2F0033A1),
            ), // Set thumb color
            // trackColor: MaterialStateProperty.all(Colors.blue.shade100), // Optional: Set track color
            // radius: Radius.circular(8.0), // Optional: Set radius for rounded corners
          ),
          child: Scrollbar(
            thumbVisibility: true,
            controller: model.allItemsScrollController,
            // thumbColor: Colors.blue,
            child: Container(
              // color: Colors.pink,
              height: 5.sh,
              width: 50.sw,
              child: GridView.builder(
                itemCount: model.itemListdata.length,
                controller: model.allItemsScrollController,
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.w,
                  mainAxisSpacing: 15.h,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final item = model.itemListdata[index];

                  return GestureDetector(
                    onTap: () async {
                      if(item == null) {  
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
                                  'Item not found  Out of Stock',
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
                      getPosOpening();
                      model.notifyListeners();
                      if (posOpeningList.isEmpty) {
                        showOpeningPOSDialog(context, model, item);
                      }

                      if (posOpeningList.isNotEmpty) {
                        addItemsToCartTable(model, context, item);
                      }
                      model.itemListdata = await batch.fetchFromItem();

                      model.searchController.text = '';

                      model.notifyListeners();
                    },
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(2, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 40.h,
                                // child:
                                //     (item.image != null && item.image!.isNotEmpty)
                                //         ? Image.network(
                                //           '${UserPreference.getString(PrefKeys.httpType)}://${UserPreference.getString(PrefKeys.baseUrl)}/${item.image}',
                                //           fit: BoxFit.cover,
                                //           errorBuilder: (
                                //             context,
                                //             error,
                                //             stackTrace,
                                //           ) {
                                //             return Image.asset(
                                //               'assets/images/no_image.png',
                                //               fit: BoxFit.cover,
                                //             );
                                //           },
                                //         )
                                //         : Image.asset(
                                //           'assets/images/no_image.png',
                                //           // fit: BoxFit.cover,
                                //         ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.invoiceStatusColor,
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 3.h,
                                  ),
                                  child: Row(
                                    children: [
                                      SingleText(
                                        text: (item.openingStock ?? 0)
                                            .toStringAsFixed(
                                              0,
                                            ), // removes decimals
                                        fontSize: 4.sp,
                                        color: AppColors.darkGreenColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleText(
                                  text: item.itemName ?? "",
                                  fontSize: 3.4.sp,
                                  color: const Color(0xFF000000),
                                  fontWeight: FontWeight.w900,
                                ),
                                SingleText(
                                  text: item.itemCode ?? "",
                                  maxLine: 1,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 3.4.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF2B3691),
                                ),
                                Row(
                                  children: [
                                    SingleText(
                                      text: item.itemGroup ?? "",
                                      fontSize: 3.4.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF006A35),
                                    ),
                                    SizedBox(width: 5),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showOpeningPOSDialog(context, model, item) async {
  DialogUtils.showConfirm(
    context: context,
    title: 'Create POS Opening Entry',
    message: '',
    confirmText: 'Create POS Opening',
    cancelText: 'Cancel',
    onConfirm: () async {
      Navigator.of(context).pop();

      await showDialog(
        context: context,
        builder: (BuildContext context) {
         
          return openingEntryDialog(context, model);
        },
      );
      await getPosOpening();
      if (posOpeningList.isNotEmpty) {
        addItemsToCartTable(model, context, item);
      }
      
    },
  );

  model.msgTimeOut = true;
  model.notifyListeners();
}

Future<double> _setRate(itemCart)
async {
try{
await batch.fetchFromItemPrice();
double _newNetRate  = batch.itemPriceListdata.firstWhere(
(item) =>
item.itemCode.toLowerCase() ==itemCart.itemCode.toLowerCase() && item.UOM == itemCart.stockUom.toLowerCase(),
orElse: () => ItemPrice(name: '', itemCode: '', UOM: '', priceList: "", priceListRate: 0)
).priceListRate;
if (_newNetRate == 0) {
final converstionRate = await batch.fetchFromUOM(itemCart.itemCode);
if (converstionRate.isNotEmpty) {
converstionRate.where((uom)=> uom.uom.toLowerCase() == itemCart.stockUom.toLowerCase()).forEach((uom) {
_newNetRate=
(itemCart.standardRate ?? 0) * (uom.conversionFactor ?? 1);
});
}
}
return  _newNetRate;
}
catch(e)
{
logErrorToFile("Error setting rate $e");
print("Error setting rate $e");
return 0.0;
}

}

Future<void> addItemsToCartTable(model, context, item, {scan=false}) async {
  try {
    await UserPreference.getInstance();
    final _standardPrice = await _setRate(item);
   int allowNegativeStock = UserPreference.getInt(PrefKeys.allowNegativeStock) ?? 0;
    String searchedBatch = model.searchController.text.isNotEmpty ? model.searchController.text.toLowerCase() : item.itemCode!.toLowerCase();
    if (item.openingStock > 0 || (item.openingStock <= 0 && allowNegativeStock == 1)) {
     
      if (item.hasBatchNo == 1 && searchedBatch.isNotEmpty) {
       
        final searchMatchedBatch = OptimizedDataManager.getBatchByCode(
          searchedBatch
        ) ?? BatchListModel( batchId: '',name: '', expiryDate: '');
        final searchMatchedBatchItem = OptimizedDataManager.getBatchesByItem(
          searchedBatch
        ).item.isNotEmpty ? OptimizedDataManager.getBatchesByItem(
          searchedBatch
        ) : TempItem(name: '', itemCode: '', );
        
        if ((searchMatchedBatch.batchId ).isNotEmpty) {
          if ((searchMatchedBatch.batchQty ?? 0) > 0 || ((searchMatchedBatch.batchQty ?? 0) < 1 && allowNegativeStock == 1)) {
          
            await model.addItemsToCart(
              Item(
                name: item.itemCode,
                itemCode: item.itemCode,
                itemName: item.itemName,
                qty: 1,
                batchNumberSeries: searchMatchedBatch.batchId,
                hasExpiryDate: item.hasExpiryDate,
                hasBatchNo: item.hasBatchNo,
                newNetRate: _standardPrice,
                newRate: _standardPrice,
                standardRate: _standardPrice,
                itemGroup: item.itemGroup,
                stockUom: item.stockUom,
                batchQty: searchMatchedBatch.batchQty,
                image: item.image ?? '',
                totalWithVatPrev:
                    _standardPrice +
                    item.itemvat / 100 * _standardPrice,
                singleItemDiscAmount: 0,
                singleItemDiscPer: 0,
                openingStock:
                    double.parse(item.openingStock.toString()).toInt(),
                vatValue: item.itemvat,
                maxDiscount: item.maxDiscount,
                vatExclusiveRate: item.vatExclusiveRate,
                customVATInclusive: item.customVATInclusive,
                itemTotal: _standardPrice, 
                barcode: item.barcode,
                hasPricingRuleApplied: false,
                appliedPricingRuleId: null,
                appliedPricingRuleTitle: null,
                discountSource: 'none',
              ),
            );
            model.scrollToBottom();
            model.batchController.text = '';
          }
          return;
        }
        else if((searchMatchedBatchItem.item ?? "") .isNotEmpty)
        {
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return batchSelectionDialog(
              context,
              model,
              item.hasBatchNo,
              item.hasSerialNo,
              1,
              item.itemCode,
              item.itemName,

              submit: () async {
                final matchedBatch =batch.batchListdata
                    .firstWhere(
                      (batch) => batch.batchId.toLowerCase() == 
                          model.batchController.text.toLowerCase(),
                      orElse: () => BatchListModel( batchId: '',name: '', expiryDate: ''),
                    );

                if (model.batchController.text.isNotEmpty) {
                  if ((matchedBatch.batchQty ?? 0) > 0 ||((matchedBatch.batchQty ?? 0) == 0 && allowNegativeStock == 1)) {
                    Navigator.of(context).pop();
                    // item.openingStock = item.openingStock - 1;
                    await model.addItemsToCart(
                      Item(
                        name: item.itemCode,
                        itemCode: item.itemCode,
                        itemName: item.itemName,
                        qty: 1,
                        batchNumberSeries: model.batchController.text,
                        hasExpiryDate: item.hasExpiryDate,
                        hasBatchNo: item.hasBatchNo,
                        newNetRate: _standardPrice,
                        standardRate: _standardPrice,
                        newRate: _standardPrice,
                        itemGroup: item.itemGroup,
                        batchQty: matchedBatch.batchQty,
                        stockUom: item.stockUom,
                        image: item.image ?? '',
                        itemTotal: _standardPrice, // Line total will be calculated (rate × qty)
                        totalWithVatPrev:
                            _standardPrice +
                            item.itemvat / 100 * _standardPrice,
                        singleItemDiscAmount: 0,
                        singleItemDiscPer: 0,
                        openingStock:
                            double.parse(item.openingStock.toString()).toInt(),
                        vatValue: item.itemvat,
                        maxDiscount: item.maxDiscount,
                        vatExclusiveRate: item.vatExclusiveRate,
                        customVATInclusive: item.customVATInclusive,
                        barcode: item.barcode,
                        // ✅ NEW: Initialize pricing rule fields
                        hasPricingRuleApplied: false,
                        appliedPricingRuleId: null,
                        appliedPricingRuleTitle: null,
                        discountSource: 'none',
                      ),
                    );

                    model.scrollToBottom();
                    model.batchController.text = '';
                  } else {
                    model.msgTimeOut = true;
                    model.notifyListeners();
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
                              // gradient: const LinearGradient(
                              //   colors: [Color(0xFF018644), Color(0xFF033D20)],
                              //   begin: Alignment.topLeft,
                              //   end: Alignment.bottomRight,
                              // ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  " ${item.itemCode} : ${item.itemName} : ${item.batchNumberSeries}  Out of Stock ",
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
                                    backgroundColor: const Color(0xFF2B3691),
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(140, 50),
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

                    // Listen for Enter key to close dialog
                    RawKeyboard.instance.addListener((RawKeyEvent event) {
                      if (event is RawKeyDownEvent &&
                          (event.logicalKey == LogicalKeyboardKey.enter ||
                              event.logicalKey ==
                                  LogicalKeyboardKey.numpadEnter)) {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                          RawKeyboard.instance.removeListener(
                            (_) {},
                          ); // Remove listener to avoid leaks
                        }
                      }
                    });
                  }
                } else if (model.batchController.text.isEmpty) {
                  batchDialogError(context);
                }
              },
            );
          },
        );
        }
        
      } else if (item.hasBatchNo == 0) {
        
        model.addItemsToCart(
          Item(
            name: item.itemCode,
            itemCode: item.itemCode,
            itemName: item.itemName,
            qty: 1,
            newRate: _standardPrice,
            newNetRate: _standardPrice,
            itemGroup: item.itemGroup,
            stockUom: item.stockUom,
            image: item.image ?? '',
            hasBatchNo: item.hasBatchNo,
            itemTotal: _standardPrice,
            standardRate: _standardPrice, // Line total will be calculated (rate × qty)
            totalWithVatPrev:
                _standardPrice + item.itemvat / 100 * _standardPrice,
            singleItemDiscAmount: 0,
            singleItemDiscPer: 0,
            openingStock: double.parse(item.openingStock.toString()).toInt(),
            vatValue: item.itemvat,
            maxDiscount: item.maxDiscount,
            vatExclusiveRate: item.vatExclusiveRate,
            customVATInclusive: item.customVATInclusive,
            barcode: item.barcode,
            // ✅ NEW: Initialize pricing rule fields
            hasPricingRuleApplied: false,
            appliedPricingRuleId: null,
            appliedPricingRuleTitle: null,
            discountSource: 'none',
          ),
        );
        model.scrollToBottom();
        model.notifyListeners();
      }
    } else {
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
                    '${item.itemCode} : ${item.itemName}  Out of Stock',
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

    
  } catch (e) {
    logErrorToFile("Error adding item to cart: $e");
    print("Error adding item to cart: $e");
  }
  // } finally {
  //   model.searchController.text = '';
  //   model.autoFocusSearchItem = true;
  //   model.notifyListeners();
  //   model.searchFocusNode.requestFocus();
  // }
}

void batchDialogError(context) {
  DialogUtils.showError(
    context: context,
    title: 'Batch field cannot be empty',
    message: 'Please select batch',
  );
}
