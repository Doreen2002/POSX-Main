import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/models/item_model.dart';
import 'package:offline_pos/widgets_components/complete_order_dialog.dart';
import '../common_utils/app_colors.dart';
import '../common_widgets/single_text.dart';
import '../common_widgets/common_search_bar.dart';
import '../widgets_components/decimal_input_formatter.dart';
import '../controllers/item_screen_controller.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

Timer? _debounce;

Widget singleItemDiscountScreen(
  BuildContext context,
  int selectedItemIndex,
  CartItemScreenController model, {
  int? openingStock,
  int? vatValue,
  double? totalWithVat,
  double? totalWithVatPrev,
  double? newRate,
  String? name,
  String? image,
  String? itemCode,
  String? itemName,
  double? itemTotal,
  int? qty,
  String? stockUom,
  String? warehouse,
  double? discount,
  double? priceListRate,
  int? hasBatch,
  int? hasSerial,
  String? batchNo,
  String? serialNo,
}) {
  final currencyPrecision = 3;

  return Visibility(
    visible: model.itemDiscountVisible == true,
    child: Expanded(
      child: Container(
        width: 1.sw / 0.9.w,
        height: 1.sh,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          color: Colors.white,
        ),
        padding: EdgeInsets.only(top: 20.h, bottom: 0.h, left: 5.w, right: 5.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            child: SingleText(
                              text:
                                  selectedItemIndex >= 0
                                      ? "${model.cartItems[selectedItemIndex].itemName}"
                                      : " ",
                              fontSize: 7.sp,
                              color: Color(0xFF2B3691),
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Row(
                            children: [
                              SizedBox(width: 3.w),
                              SizedBox(width: 60.w),
                            ],
                          ),
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.all(4),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF018644), Color(0xFF033D20)],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleText(
                                  text:
                                      selectedItemIndex >= 0
                                          ? "Code: ${model.cartItems[selectedItemIndex].name}"
                                          : "Code: ",
                                  fontSize: 6.sp,
                                  color: const Color(0xFFFFFFFF),
                                ),
                                SingleText(
                                  text:
                                      selectedItemIndex >= 0
                                          ? "UOM: ${model.cartItems[selectedItemIndex].stockUom}"
                                          : "UOM: ",
                                  fontSize: 6.sp,
                                  color: const Color(0xFFFFFFFF),
                                ),
                                SingleText(
                                  text:
                                      selectedItemIndex >= 0
                                          ? "Stock: ${model.cartItems[selectedItemIndex].openingStock.toString()}"
                                          : '',
                                  fontSize: 6.sp,
                                  color: const Color(0xFFFFFFFF),
                                  // fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            SizedBox(width: 20.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleText(
                                  text:
                                      selectedItemIndex >= 0
                                          ? "Price: ${UserPreference.getString(PrefKeys.currency)} ${model.cartItems[selectedItemIndex].newRate.toStringAsFixed(currencyPrecision)}"
                                          : "Price: ",
                                  fontSize: 6.sp,
                                  color: const Color(0xFFFFFFFF),
                                ),
                                SingleText(
                                  text:
                                      selectedItemIndex >= 0
                                          ? "VAT: ${model.cartItems[selectedItemIndex].vatValue}%"
                                          : "VAT: ",
                                  fontSize: 6.sp,
                                  color: const Color(0xFFFFFFFF),
                                ),
                                SingleText(
                                  text:
                                      selectedItemIndex >= 0
                                          ? "Cart Qty: ${model.cartItems[selectedItemIndex].qty.toString()}"
                                          : '',
                                  fontSize: 6.sp,
                                  color: const Color(0xFFFFFFFF),
                                  // fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 70.h),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Discount Amount Section
                    Visibility(
                      visible: false,
                      child: 
                      Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleText(
                            text:
                                'Max Discount ${UserPreference.getString(PrefKeys.currency)} ${(double.tryParse( model.singlediscountMaxAmount) ?? 0).toStringAsFixed(model.decimalPoints)}',
                            fontSize: 5.sp,
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFF2B3691),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: CommonTextField(
                                      controller:
                                          model.singlediscountAmountController,
                                      focusNode:
                                          model.singlediscountAmountfocusNode,
                                      hintText: '',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        DecimalTextInputFormatter(
                                          decimalRange: 3,
                                        ),
                                        LengthLimitingTextInputFormatter(10),
                                      ],

                                      onTap: () {},
                                      onChanged: (val) {
                                        onChageDiscountAmount(
                                          model,
                                          val,
                                          selectedItemIndex,
                                          context,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                InkWell(
                                  onTap: () {
                                    model.singlediscountAmountController
                                        .clear();
                                    model.singlediscountPercentController
                                        .clear();
                                    FocusScope.of(context).requestFocus(
                                      model.singlediscountAmountfocusNode,
                                    );
                                    model.hasFocus = '';
                                    model.notifyListeners();
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 15.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: Color(0xFF2B3691),
                                        width: 1,
                                      ),
                                      color: Color(0xFF2B3691),
                                    ),
                                    child: Center(
                                      child: SingleText(
                                        text: 'C',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 5.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    
                    ),
                    
                     Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleText(
                            text:
                                'Max Discount ${UserPreference.getString(PrefKeys.currency)} ${((double.tryParse(model.singlediscountMaxAmount) ?? 0) * (int.tryParse(model.singleqtyController.text) ?? 0)).toStringAsFixed(model.decimalPoints)}',
                            fontSize: 5.sp,
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFF2B3691),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: CommonTextField(
                                      controller:
                                          model.singleItemdiscountAmountController,
                                      focusNode:
                                          model.singleItemdiscountAmountfocusNode,
                                      hintText: '',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        DecimalTextInputFormatter(
                                          decimalRange: 3,
                                        ),
                                        LengthLimitingTextInputFormatter(10),
                                      ],

                                      onTap: () {},
                                      onChanged: (val) {
                                        model.singlediscountAmountController.text = ((double.tryParse(val) ?? 0) / (int.tryParse(model.singleqtyController.text ) ?? 0)).toString();
                                        onChageDiscountAmount(
                                          model,
                                          model.singlediscountAmountController.text,
                                          selectedItemIndex,
                                          context,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                InkWell(
                                  onTap: () {
                                    model.singlediscountAmountController
                                        .clear();
                                    model.singleItemdiscountAmountController
                                        .clear();
                                    model.singlediscountPercentController
                                        .clear();
                                    FocusScope.of(context).requestFocus(
                                      model.singleItemdiscountAmountfocusNode,
                                    );
                                    model.hasFocus = '';
                                    model.notifyListeners();
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 15.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: Color(0xFF2B3691),
                                        width: 1,
                                      ),
                                      color: Color(0xFF2B3691),
                                    ),
                                    child: Center(
                                      child: SingleText(
                                        text: 'C',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 5.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleText(
                            text:
                                'Max Discount: ${model.singlediscountMaxPercent}%',
                            fontSize: 5.sp,
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xFF2B3691),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: CommonTextField(
                                      controller:
                                          model.singlediscountPercentController,
                                      focusNode:
                                          model.singlediscountPercentfocusNode,
                                      hintText: '',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        DecimalTextInputFormatter(
                                          decimalRange: 3,
                                        ),
                                        LengthLimitingTextInputFormatter(4),
                                      ],
                                      onChanged: (val) async{
                                        await onChangeDiscountPercentage(
                                          model,
                                          val,
                                          selectedItemIndex,
                                          context,
                                        );
                                      },
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                InkWell(
                                  onTap: () {
                                    model.singlediscountPercentController
                                        .clear();
                                    model.singlediscountAmountController
                                        .clear();
                                        model.singleItemdiscountAmountController
                                        .clear();
                                    FocusScope.of(context).requestFocus(
                                      model.singlediscountPercentfocusNode,
                                    );
                                    model.hasFocus = '';
                                    model.notifyListeners();
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 15.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: Color(0xFF2B3691),
                                        width: 1,
                                      ),
                                      color: Color(0xFF2B3691),
                                    ),
                                    child: Center(
                                      child: SingleText(
                                        text: 'C',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 5.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item Cart Qty Input
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleText(text: 'Item Quantity', fontSize: 5.sp),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xFF2B3691),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: CommonTextField(
                                    controller: model.singleqtyController,
                                    hintText: '',
                                    focusNode: model.singleqtyfocusNode,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onTap: () {
                                      model.focusInputNode =
                                          model.singleqtyfocusNode;
                                      model.focusInput =
                                          model.singleqtyController;
                                      model.notifyListeners();
                                    },
                                    onChanged: (value) {
                                      if (value.isEmpty) {
                                        // Update model qty to 1 immediately but don't change UI here
                                        onChangeItemQTY(
                                          '',
                                          model,
                                          selectedItemIndex,
                                        );
                                        return;
                                      }

                                      if (value == '0') {
                                        // Ignore temporary zero input to let user continue typing
                                        return;
                                      }

                                      onChangeItemQTY(
                                        value,
                                        model,
                                        selectedItemIndex,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              InkWell(
                                onTap: () {
                                  model.singleqtyController.clear();
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(model.singleqtyfocusNode);
                                  model.hasFocus = '';
                                  model.notifyListeners();
                                },
                                child: Container(
                                  height: 40.h,
                                  width: 15.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: Color(0xFF2B3691),
                                      width: 1,
                                    ),
                                    color: Color(0xFF2B3691),
                                  ),
                                  child: Center(
                                    child: SingleText(
                                      text: 'C',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 5.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              
                SizedBox(height: 20.h),

                Row(
                  children: [
                    Expanded(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Decrease Quantity Button
                          InkWell(
                            onTap:
                                model.isCheckOutScreen
                                    ? null
                                    : () async {
                                      try {
                                        if (model.cartItems.isEmpty) return;

                                        final item =
                                            model.cartItems[selectedItemIndex];
                                        if (item.qty > 0) {
                                          item.qty -= 1;
                                          
                                          item.singleItemDiscAmount =
                                              (item.singleItemDiscAmount ?? 0);
                                          item.newRate =
                                              (item.newNetRate ?? 0) -
                                              (item.singleItemDiscAmount ?? 0);
                                          item.itemTotal =
                                              (item.qty * item.newRate);
                                          item.totalWithVatPrev =
                                              (item.vatValue! /
                                                  100 *
                                                  item.itemTotal) +
                                              item.itemTotal;
                                              item.itemTotal;

                                          if (item.qty == 0) {
                                            model.itemDiscountVisible = false;
                                            model.hasFocus = '';
                                            resetCalculations(model);
                                          }

                                          model.discountCalculation(
                                            model.allItemsDiscountAmount.text,
                                            model.allItemsDiscountPercent.text,
                                          );

                                          model.cartItems =
                                              model.cartItems
                                                  .where(
                                                    (item) => item.qty != 0,
                                                  )
                                                  .toList();
                                          if (model.cartItems.isEmpty) {
                                            model.selectedItemIndex = -1;
                                          } else if (model.selectedItemIndex >=
                                              model.cartItems.length) {
                                            model.selectedItemIndex = -1;
                                          }
                                          model.singleqtyController.text =
                                              model
                                                  .cartItems[selectedItemIndex]
                                                  .qty
                                                  .toString();
                                                  await model.playBeepSound();
                                          model.notifyListeners();
                                        }
                                      } catch (e) {
                                        print("$e");
                                      }
                                    },
                            child: Container(
                              width: 150,
                              height: 90,
                              decoration: BoxDecoration(
                                color:
                                    model.isCheckOutScreen
                                        ? Colors.grey.shade400
                                        : null,
                                gradient:
                                    model.isCheckOutScreen
                                        ? null
                                        : LinearGradient(
                                          colors: [
                                            Color(0xFFFF3B3B),
                                            Color(0xFFFF3B3B),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.remove,
                                size: 80.r,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          SizedBox(width: 10.w),
                          InkWell(
                            onTap:
                                model.isCheckOutScreen
                                    ? null
                                    : () async {
                                      final item =
                                          model.cartItems[selectedItemIndex];

                                      if ((item.hasSerialNo != 1 &&
                                              item.hasBatchNo != 1 &&
                                              item.openingStock! > 0 &&
                                              item.qty <
                                                  (item.openingStock ?? 0)) ||
                                          (item.hasBatchNo == 1 &&
                                              item.hasSerialNo != 1 &&
                                              (item.batchQty ?? 0) > 0 &&
                                              item.qty <
                                                  (item.batchQty ?? 0))) {
                                        item.qty += 1;

                                        item.singleItemDiscAmount =
                                            (item.singleItemDiscAmount ?? 0);
                                        item.newRate =
                                            (item.newNetRate ?? 0) -
                                            (item.singleItemDiscAmount ?? 0);
                                        item.itemTotal =
                                            (item.qty * item.newRate);
                                        item.totalWithVatPrev =
                                            (item.vatValue! /
                                                100 *
                                                item.itemTotal) +
                                            item.itemTotal;

                                        model.discountCalculation(
                                          model.allItemsDiscountAmount.text,
                                          model.allItemsDiscountPercent.text,
                                        );
                                        model.singleqtyController.text =
                                            model
                                                .cartItems[selectedItemIndex]
                                                .qty
                                                .toString();
                                                await model.playBeepSound();
                                        model.notifyListeners();
                                      } else if ((item.qty >=
                                                  (item.openingStock ?? 0) &&
                                              item.hasBatchNo != 1) ||
                                          (item.hasBatchNo == 1 &&
                                              item.hasSerialNo != 1 &&
                                              item.qty >=
                                                  (item.batchQty ?? 0))) {
                                        AwesomeDialog(
                                          context: context!,
                                          dialogType: DialogType.noHeader,
                                          animType: AnimType.scale,
                                          width: 600,
                                          title: 'Insufficient Stock',
                                          desc:
                                              'You cannot set quantity greater than available stock.\nAvailable stock: ${item.hasBatchNo != 1 ? item.openingStock : item.batchQty}',
                                          btnOkOnPress: () {},
                                          headerAnimationLoop: false,
                                          titleTextStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ).show();
                                      }
                                    },
                            child: Container(
                              width: 150,
                              height: 90,
                              decoration: BoxDecoration(
                                color:
                                    model.isCheckOutScreen
                                        ? Colors.grey.shade400
                                        : null,
                                gradient:
                                    model.isCheckOutScreen
                                        ? null
                                        : LinearGradient(
                                          colors: [
                                            Color(0xFF03A353),
                                            Color(0xFF03A353),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 80.r,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF018644), Color(0xFF033D20)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () async{
                          final item = model.cartItems[selectedItemIndex];

                          // Case 1: No discount entered
                          if (model
                                  .singlediscountAmountController
                                  .text
                                  .isEmpty &&
                              model
                                  .singlediscountPercentController
                                  .text
                                  .isEmpty) {
                            item.newRate = (item.newNetRate ?? 0);
                            item.itemTotal =
                                item.qty * (item.newNetRate ?? 0);
                            item.totalWithVatPrev =
                                (item.vatValue! / 100 * item.itemTotal) +
                                item.itemTotal;

                            model.discountCalculation(
                              model.allItemsDiscountAmount.text,
                              model.allItemsDiscountPercent.text,
                            );
                            item.singleItemDiscAmount = 0.0;
                            item.singleItemDiscPer = 0.0;
                            item.ItemDiscAmount = 0.0;
                          }

                          // Case 2: Both discount fields have values
                          if (model
                                  .singlediscountAmountController
                                  .text
                                  .isNotEmpty &&
                              model
                                  .singlediscountPercentController
                                  .text
                                  .isNotEmpty) {
                            double enteredAmount = double.parse(
                              model.singlediscountAmountController.text,
                            );
                            double maxAmount = double.parse(
                              model.singlediscountMaxAmount,
                            );
                            double enteredPercent = double.parse(
                              model.singlediscountPercentController.text,
                            );
                            double maxPercent = double.parse(
                              model.singlediscountMaxPercent,
                            ) ;

                            //  Stop execution if validation fails
                            if (enteredAmount > maxAmount) {
                              discountAlert(
                                "MAX allowed discount amount : ${(( double.tryParse(model.singlediscountMaxAmount) ?? 0) * (int.tryParse(model.singleqtyController.text)??0)).toStringAsFixed(model.decimalPoints)}",
                                "Please set discount amount less than or equal to allowed amount.",
                                context,
                              );
                              return; //  Do not continue
                            } else if (enteredPercent > maxPercent) {
                              discountAlert(
                                "MAX discount percent allowed : ${model.singlediscountMaxPercent}",
                                "Please set discount percent less than or equal to allowed MAX.",
                                context,
                              );
                              return; // Do not continue
                            }

                            //  If validation passes, apply the discount
                            item.singleItemDiscAmount = enteredAmount;
                            
                            item.singleItemDiscPer = enteredPercent;
                            item.newRate =
                                (item.newNetRate ?? 0) -
                                (item.singleItemDiscAmount ?? 0);
                            item.itemTotal = (item.newRate * item.qty);
                            item.totalWithVatPrev =
                                item.itemTotal +
                                (item.itemTotal *
                                    (item.vatValue ?? 0) /
                                    100);
                            item.ItemDiscAmount = enteredAmount * item.qty;
                          }

                          
                          await model.discountCalculation(
                            model.allItemsDiscountAmount.text,
                            model.allItemsDiscountPercent.text,
                          );
                          model.itemDiscountVisible = false;
                          model.hasFocus = '';
                          model.notifyListeners();

                          if (model.cartItems[selectedItemIndex].qty == 0) {
                            model.cartItems.remove(
                              model.cartItems[selectedItemIndex],
                            );
                            model.itemDiscountVisible = false;
                            model.hasFocus = '';
                          }

                          model.notifyListeners();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          fixedSize: Size(150, 90),
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Submit'),
                      ),
                    ),

                    SizedBox(width: 10.w),
                    Container(
                      width: 150,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2B3691), Color(0xFF151E6E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final item = model.cartItems[selectedItemIndex];
                            
                            item.qty = 0;
                            model.discountCalculation(
                              model.allItemsDiscountAmount.text,
                              model.allItemsDiscountPercent.text,
                            );
                            model.itemDiscountVisible = false;
                            model.hasFocus = '';
                            model.cartItems =
                                model.cartItems
                                    .where((item) => item.qty != 0)
                                    .toList();

                            resetCalculations(model);
                            model.selectedItemIndex = -1;
                            model.discountCalculation(
                              model.allItemsDiscountAmount.text,
                              model.allItemsDiscountPercent.text,
                            );
                            await model.playBeepSound();
                            model.notifyListeners();
                          } catch (e) {
                            print("$e");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          fixedSize: Size(150, 90),
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Remove\nItem',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),
                Row(
                  children: [
                    Visibility(
                      visible: hasBatch == 1,
                      child: Expanded(
                        child: Container(
                          // height: 50.h,
                          width: 1.sw,
                          padding: EdgeInsets.only(left: 3.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.cartListColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                            color: AppColors.cartListColor,
                          ),
                          child: Center(
                            child: TypeAheadField(
                              controller: TextEditingController(),
                              builder:
                                  (context, controller, focusNode) => TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    maxLines: 1,
                                    autofocus: false,
                                    style: TextStyle(
                                      fontSize: 5.sp,
                                      color: AppColors.cartTextColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    decoration: InputDecoration(
                                      // contentPadding: EdgeInsets.only(left: 1.w),
                                      isDense: true,
                                      border: const UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: 'Batch',
                                      hintStyle: TextStyle(
                                        fontSize: 5.sp,
                                        color: AppColors.lightTextColor,
                                      ),
                                      suffixIcon: Visibility(
                                        // visible: model.batchController.text.isNotEmpty,
                                        child: InkWell(
                                          onTap: () async {},
                                          child: Icon(
                                            Icons.clear,
                                            size: 25.r,
                                            color: AppColors.cartTextColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              decorationBuilder:
                                  (context, child) => Material(
                                    type: MaterialType.card,
                                    elevation: 4,
                                    borderOnForeground: false,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(6.r),
                                    ),
                                    child: child,
                                  ),
                              itemBuilder: (context, suggestion) {
                                return ListTile(title: Row(children: [
                                    ]
                                  ));
                              },
                              onSelected: (suggestion) {},
                              suggestionsCallback: (pattern) async {},
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(width: 10.w,),
                    Visibility(
                      visible: hasSerial == 1,
                      child: Expanded(
                        child: Container(
                          height: 150.h,
                          width: 1.sw,
                          padding: EdgeInsets.only(left: 3.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.cartListColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.r),
                            ),
                            color: AppColors.cartListColor,
                          ),
                          child: Visibility(
                            // visible: itemWiseSerial == true,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Container(child: SingleText(text: "")),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Visibility(
                    visible: hasSerial == 1,
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.r),
                            ),
                            border: Border.all(color: AppColors.cartTextColor),
                            color: AppColors.cartListColor,
                          ),
                          padding: EdgeInsets.only(
                            top: 2.h,
                            bottom: 2.h,
                            left: 3.w,
                            right: 3.w,
                          ),
                          child: SingleText(
                            text: 'Auto Fetch Serial Number',
                            fontSize: 5.sp,
                          ),
                        ),
                      ),
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
}

void discountAlert(String title, String message, context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16, color: Color(0xFF444444)),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('OK', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
  );
}

Future<void> onChangeDiscountPercentage(model, val, selectedItemIndex, context) {
  return Future.delayed(const Duration(microseconds: 1), () {
    if (val.isEmpty) {
      model.singlediscountAmountController.text = '';
      model.singlediscountPercentController.text = '';
      return;
    }

    final itemAmount = model.cartItems[selectedItemIndex].newNetRate ?? 0.0;
    final maxPercent = double.parse(model.singlediscountMaxPercent);
    final allowedAmount = (itemAmount * double.parse(val)) / 100;

    model.singlediscountAmountController.text = allowedAmount.toStringAsFixed(
      model.decimalPoints,
    );
     model.singleItemdiscountAmountController.text = ((double.tryParse(model.singlediscountAmountController.text) ?? 0) * (int.tryParse(model.singleqtyController.text) ?? 0)).toStringAsFixed(
      model.decimalPoints,
    );
    if (double.parse(val) > maxPercent) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        width: 600,
        title:
            'MAX allowed discount percent: ${model.singlediscountMaxPercent}%',
        desc: 'Please enter a discount percent within the allowed limit.',
        headerAnimationLoop: false,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        descTextStyle: const TextStyle(fontSize: 16, color: Color(0xFF444444)),
        btnOk: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF04490D),
            foregroundColor: Colors.white,
            minimumSize: const Size(160, 80), // big and touch-friendly
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // square corners
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ).show();
    }

    model.notifyListeners();
  });
}

void onChageDiscountAmount(model, val, selectedItemIndex, context) {
  if (val.isEmpty) {
    model.singlediscountAmountController.text = '';
    model.singlediscountPercentController.text = '';
    return;
  }

  final itemAmount = model.cartItems[selectedItemIndex].newNetRate ?? 0.0;
  final maxDiscount = model.cartItems[selectedItemIndex].maxDiscount ?? 0.0;
  final allowedDiscount = (100 / itemAmount) * double.parse(val);

  model.singlediscountPercentController.text = allowedDiscount.toStringAsFixed(
    model.decimalPoints,
  );
  bool _isDialogShowing = false;

  if (double.parse(val) > double.parse(model.singlediscountMaxAmount)) {
    if (!_isDialogShowing) {
      _isDialogShowing = true;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        width: 600,
        title: 'MAX allowed discount amount: ${(( double.tryParse(model.singlediscountMaxAmount) ?? 0) * (int.tryParse(model.singleqtyController.text)??0)).toStringAsFixed(model.decimalPoints)}',
        desc: 'Please enter a discount amount within the allowed limit.',
        headerAnimationLoop: false,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        descTextStyle: const TextStyle(fontSize: 16, color: Color(0xFF444444)),
        btnOk: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF04490D),
            foregroundColor: Colors.white,
            minimumSize: const Size(160, 80), // big & touch friendly
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // square corners
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            _isDialogShowing = false;
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ).show();
    }
  }

  model.notifyListeners();
}

void onChangeItemQTY(value, model, selectedItemIndex) {
  final selectedItemModel = model.cartItems[selectedItemIndex];
  int _value = int.tryParse(value.isNotEmpty ? value : "0") ?? 0;

  TempItem? item = OptimizedDataManager.getItemByCode(
    model.cartItems[model.selectedItemIndex].itemCode
  );
  if (item == null) {
    return; // Item not found, skip processing
  }
  if (item.hasBatchNo ==1)
  {
    item.batchQty = model.cartItems[model.selectedItemIndex].batchQty;
  }
  if ((_value > item.openingStock && item.hasBatchNo != 1) || (_value > (item.batchQty ?? 0) && item.hasBatchNo == 1))  {
    AwesomeDialog(
      context: model.context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      width: 600,
      title: 'Insufficient Stock',
      desc:
          'You cannot set quantity greater than available stock.\nAvailable stock: ${item.hasBatchNo != 1?  item.openingStock : (item.batchQty ?? 0)}',
      headerAnimationLoop: false,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      descTextStyle: const TextStyle(fontSize: 16, color: Color(0xFF444444)),
      btnOk: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF04490D),
          foregroundColor: Colors.white,
          minimumSize: const Size(160, 80), // big and touch-friendly
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // square corners
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          model.singleqtyController.text =
              model.cartItems[selectedItemIndex].qty.toString();
          Navigator.of(model.context).pop();
        },
        child: const Text('OK'),
      ),
    ).show();
    return;
  } else if (_value <= item.openingStock) {
    
    model.cartItems[model.selectedItemIndex].qty = _value ?? 0;
    selectedItemModel.singleItemDiscAmount =
        (selectedItemModel.singleItemDiscAmount ?? 0);
    selectedItemModel.newRate =
        (selectedItemModel.newNetRate ?? 0) -
        (selectedItemModel.singleItemDiscAmount ?? 0);
    selectedItemModel.itemTotal =
        (selectedItemModel.qty * selectedItemModel.newRate);
    selectedItemModel.totalWithVatPrev =
        (selectedItemModel.vatValue! / 100 * selectedItemModel.itemTotal) +
        selectedItemModel.itemTotal;

    model.discountCalculation(
      model.allItemsDiscountAmount.text,
      model.allItemsDiscountPercent.text,
    );
    model.notifyListeners();
  }
}
