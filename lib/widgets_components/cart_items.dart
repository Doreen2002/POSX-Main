import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/database_conn/get_item_queries.dart';
import 'package:offline_pos/models/batch_list_model.dart';
import 'package:offline_pos/widgets_components/all_calculation_display.dart';
import 'package:offline_pos/widgets_components/single_item_discount.dart';
import '../common_utils/app_colors.dart';
import '../common_widgets/single_text.dart';
import '../common_widgets/common_message_print.dart';
import '../widgets_components/additional_discount.dart';

Widget cartDesign(BuildContext context, CartItemScreenController model, isSalesReturn) {
  model.selectedItemIndex =
      model.cartItems.isEmpty ? -1 : model.selectedItemIndex;
  final currencyPrecision = model.decimalPoints;
  model.isCheckOutScreen == false
      ? model.isCheckOutScreenText = 'Submit Payment'
      : model.isCheckOutScreenText = 'Edit Cart';

  return Expanded(
    child: Stack(
      children: [
        Container(
          width: 5.sw / 0.5.w,
          height: 1.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(
            top: 20.h,
            bottom: 10.h,
            left: 15.w,
            right: 5.w,
          ),
          child: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     SingleText(
              //       text: "Item Cart",
              //       fontSize: 5.sp,
              //       fontWeight: FontWeight.bold,
              //     ),

              //   ],
              // ),
              SizedBox(height: 20.h),
              Container(
                padding: const EdgeInsets.all(8),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 12.w,
                      // color: Colors.pink,
                      child: SingleText(
                        text: "No.",
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                    SizedBox(
                      width: 25.w,
                      // color: Colors.pink,
                      child: SingleText(
                        text: "Item Code",
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                    SizedBox(
                      width: 60.w,
                      // color: Colors.blue,
                      child: SingleText(
                        text: "Item Name",
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                     SizedBox(
                      width: 24.w,
                      // color: Colors.pink,
                      child: Align(
                        alignment: Alignment.center,
                        child: SingleText(
                          text: "Price",
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    SizedBox(
                      // color: Colors.pink,
                      width: 25.w,
                      child: Center(
                        child: SingleText(
                          text: "Qty",
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.w,
                      // color: Colors.blue,
                      child: SingleText(
                        text: "UOM",
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                   
                    SizedBox(width: 4.w,),
                    SizedBox(
                      width: 25.w,
                      // color: Colors.blue,
                      child: SingleText(
                        text: " Disc",
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                      // color: Colors.pink,
                      child: SingleText(
                        text: "Amount",
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                    SizedBox(
                      width: 25.w,
                      // color: Colors.blue,
                      child: SingleText(
                        text: "With VAT",
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                    // SingleText(
                    //     text: "     ",
                    //     fontSize: 5.sp,
                    //     fontWeight: FontWeight.bold,
                    //     color: AppColors.cartTextColor),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Flexible(
                child: ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thumbColor: WidgetStateProperty.all(Colors.grey),
                  ),

                  child: ListView.builder(
                    primary: false,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,

                    controller: model.scrollController,
                    itemCount: model.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartitem = model.cartItems[index];
                      final batch =
                          cartitem.hasBatchNo == 1
                              ? batchListdata
                                  .where(
                                    (element) =>
                                        element.name ==
                                        cartitem.batchNumberSeries,
                                  )
                                  .first
                              : BatchListModel( batchId: '',name: '', expiryDate: '');
                      String formattedDate =
                          batch.expiryDate!.isNotEmpty
                              ? DateFormat(
                                'dd-MM-yyyy',
                              ).format(DateTime.parse(batch.expiryDate!))
                              : '';
                      return InkWell(
                        onTap: () {
                          if (model.isCheckOutScreen) return;
                          model.selectedItemIndex =
                              model.cartItems.isEmpty ? -1 : index;
                         
                          singleItemDiscountScreen(
                            context,
                            model.selectedItemIndex,
                            model,
                            name: cartitem.name,
                            image: cartitem.image,
                            openingStock: cartitem.openingStock,
                            hasBatch: cartitem.hasBatchNo,
                            hasSerial: cartitem.hasSerialNo,
                            batchNo: cartitem.batchNumberSeries,
                          );

                          model.itemDiscountVisible =
                              !model.itemDiscountVisible;

                          if (model.itemDiscountVisible) {
                             model.singleuomController.text =model
                                      .cartItems[model.selectedItemIndex].stockUom;
                            if (model.selectedItemIndex >= 0) {
                              model.singleqtyController.text =
                                  model.cartItems[model.selectedItemIndex].qty
                                      .toString();

                              model.singlediscountMaxPercent =
                                  model
                                      .cartItems[model.selectedItemIndex]
                                      .maxDiscount
                                      .toString();
                              model.singlediscountMaxAmount = ((model
                                              .cartItems[model
                                                  .selectedItemIndex]
                                              .newNetRate ??
                                          0.0) /
                                      100 *
                                      (model
                                              .cartItems[model
                                                  .selectedItemIndex]
                                              .maxDiscount ??
                                          0.0))
                                  .toStringAsFixed(model.decimalPoints);
                            }
                            model.singlediscountAmountController.text = (model
                                        .cartItems[model.selectedItemIndex]
                                        .singleItemDiscAmount ??
                                    0)
                                .toStringAsFixed(model.decimalPoints);
                                 model.singleItemdiscountAmountController.text = ((model
                                        .cartItems[model.selectedItemIndex]
                                        .singleItemDiscAmount ??
                                    0) * model.cartItems[model.selectedItemIndex]
                                        .qty)
                                .toStringAsFixed(model.decimalPoints);
                            model.singlediscountPercentController.text =
                                (model
                                            .cartItems[model.selectedItemIndex]
                                            .singleItemDiscPer ??
                                        0)
                                    .toString();
                          } else if (model.itemDiscountVisible == false) {
                            model.hasFocus = '';
                          }
                          model.notifyListeners();
                        },

                        child: Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                SizedBox(
                                  width: 12.w,
                                  child: SingleText(
                                    text: '${(index + 1)}.',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(
                                  width: 25.w,
                                  child: SingleText(
                                    text: cartitem.itemCode,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(
                                  width: 65.w,
                                  // color: Colors.blue,
                                  child: SingleText(
                                    text: cartitem.itemName,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                SizedBox(
                                  width: 20.w,
                                  child: SingleText(
                                    text: (cartitem.newNetRate ?? 0.0)
                                        .toStringAsFixed(currencyPrecision),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(
                                  width: 25.w,
                                  child: Center(
                                    child: Row(
                                      children: [

                                        SizedBox(width: 10.w),

                                        // Quantity Text
                                        SingleText(
                                          text:"${model.isSalesReturn ? '-':''} ${cartitem.qty.toString()}",
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13,
                                        ),

                                        SizedBox(width: 1.w),

                                        // Increase Quantity Button
                                        // InkWell(
                                        //   onTap:
                                        //       model.isCheckOutScreen
                                        //           ? null
                                        //           : () async {
                                        //             if (cartitem.hasBatchNo !=
                                        //                     1 &&
                                        //                 cartitem.hasSerialNo !=
                                        //                     1) {
                                        //               if (cartitem
                                        //                       .openingStock! >
                                        //                   0) {
                                        //                 cartitem.qty += 1;
                                        //                 cartitem.openingStock =
                                        //                     cartitem
                                        //                         .openingStock! -
                                        //                     1;

                                        //                 cartitem.valuationRate =
                                        //                     cartitem.newRate *
                                        //                     cartitem.qty;
                                        //                 cartitem.totalWithVatPrev =
                                        //                     cartitem.vatValue! /
                                        //                         100 *
                                        //                         cartitem
                                        //                             .valuationRate +
                                        //                     cartitem
                                        //                         .valuationRate;

                                        //                 model.cartItems =
                                        //                     model.cartItems
                                        //                         .where(
                                        //                           (item) =>
                                        //                               item.qty !=
                                        //                               0,
                                        //                         )
                                        //                         .toList();

                                        //                 itemListdata =
                                        //                     itemListdata.map((
                                        //                       item,
                                        //                     ) {
                                        //                       if (item.name ==
                                        //                           cartitem
                                        //                               .name) {
                                        //                         item.openingStock =
                                        //                             cartitem
                                        //                                 .openingStock
                                        //                                 .toString();
                                        //                       }
                                        //                       return item;
                                        //                     }).toList();

                                        //                 print(
                                        //                   "✅ Updated opening stock: ${cartitem.openingStock}",
                                        //                 );
                                        //               }
                                        //               print(
                                        //                 "✅ opening stock: ${cartitem.qty} ${cartitem.openingStock}",
                                        //               );
                                        //               model.discountCalculation(
                                        //                 '',
                                        //                 '',
                                        //               );
                                        //               model.notifyListeners();
                                        //             }
                                        //           },
                                        //   child: Container(
                                        //     padding: EdgeInsets.all(6.r),
                                        //     decoration: BoxDecoration(
                                        //       color:
                                        //           model.isCheckOutScreen
                                        //               ? Colors
                                        //                   .grey
                                        //                   .shade400 // Disabled color
                                        //               : Colors
                                        //                   .green
                                        //                   .shade400, // Active color
                                        //       borderRadius: BorderRadius.all(
                                        //         Radius.circular(10.r),
                                        //       ),
                                        //     ),
                                        //     child: Icon(
                                        //       Icons.add,
                                        //       size: 20.r,
                                        //       color: Colors.white,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  width: 14.w,
                                  child: SingleText(
                                    text: cartitem.stockUom,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                SizedBox(
                                  width: 25.w,
                                  // color: Colors.blue,
                                  child: SingleText(
                                    text:
                                        (cartitem.ItemDiscAmount != null
                                            ? cartitem.ItemDiscAmount!
                                                .toStringAsFixed(
                                                  model.decimalPoints,
                                                )
                                            : '0.000'),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(
                                  width: 20.w,
                                  child: SingleText(
                                    text:"${model.isSalesReturn ? '-':''} ${(cartitem.itemTotal ?? 0.0)
                                        .toStringAsFixed(currencyPrecision)}",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                // SizedBox(
                                //   width: 25.w,
                                //   child: SingleText(
                                //     text: cartitem.valuationRate
                                //         .toStringAsFixed(currencyPrecision),
                                //     fontWeight: FontWeight.bold,
                                //     fontSize: 13,
                                //   ),
                                // ),
                                SizedBox(
                                  width: 25.w,

                                  child: SingleText(
                                    text:"${model.isSalesReturn ? '-':''} ${(model.roundToDecimals(
                                      (cartitem.totalWithVatPrev ?? 0),
                                      model.decimalPoints,
                                    )).toStringAsFixed(currencyPrecision)}",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),

                                // InkWell(
                                //     onTap: ()async{

                                //     cartitem.openingStock = cartitem.openingStock! + cartitem.qty;

                                //     cartitem.qty = 0;
                                //     model.cartItems = model.cartItems.where((item) => item.qty != 0).toList();

                                //     itemListdata = itemListdata.map((item) {
                                //       if (item.name == cartitem.name) {
                                //         item.openingStock = cartitem.openingStock.toString();
                                //       }
                                //       return item;
                                //     }).toList();

                                //     print("✅ Updated opening stock: ${cartitem.openingStock}");
                                //     model.discountCalculation('', '');
                                //     model.notifyListeners();

                                //     },
                                //     child: Icon(Icons.delete,color: Colors.red,size: 35.r,)
                                // ),
                              ],
                            ),

                            Visibility(
                              visible:
                                  cartitem.serialNo != null &&
                                  cartitem.serialNo != '',
                              child: Row(
                                children: [
                                  SingleText(
                                    text: "Serial No : ",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    // color: AppColors.cartTextColor,
                                  ),
                                  SingleText(
                                    text: cartitem.serialNo.toString(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    // color: AppColors.cartTextColor,
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible:
                                  cartitem.batchNumberSeries != null &&
                                  cartitem.batchNumberSeries != '',
                              child: Row(
                                children: [
                                  SingleText(
                                    text: "Batch : ",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: const Color(0xFF2B3691),
                                  ),
                                  SingleText(
                                    text: cartitem.batchNumberSeries.toString(),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: const Color(0xFF0A5C29),

                                    // color: AppColors.cartTextColor,
                                  ),
                                  SizedBox(width: 9.w),
                                  SingleText(
                                    text: "Expiry Date : ",
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: const Color(0xFF2B3691),
                                  ),
                                  SingleText(
                                    text: formattedDate,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13,
                                    color: const Color(0xFF0A5C29),
                                  ),
                                ],
                              ),
                            ),

                            const Divider(color: AppColors.cartTextColor),
                          ],
                        ),
                      );
                    },
                  ),
                  // ),
                ),
              ),
              SizedBox(height: 10.h),
              // Visibility(
              //   visible: model.cartItems.isNotEmpty ,
              //   child: Padding(
              //     padding: const EdgeInsets.only(
              //         left: 30, right: 30),
              //     child: InkWell(
              //       onTap: (){

              //           model.showAddDiscount = !model.showAddDiscount;
              //           model.notifyListeners();

              //       },
              //       child: DottedBorder(
              //         color: AppColors.cartTextColor,
              //         child: Container(
              //           width: 1.sw,
              //           padding: EdgeInsets.all(5.r),
              //           child: Center(
              //             child: SingleText(
              //               text: model.allItemsDiscountAmount.text.isNotEmpty ? ' ${model.allItemsDiscountAmount.text} ${UserPreference.getString(PrefKeys.currency)} Applied':
              //               model.allItemsDiscountPercent.text.isNotEmpty ? ' ${model.allItemsDiscountPercent.text} % Applied' : 'Offer Discount On Invoice' ,
              //               fontWeight:
              //               FontWeight.normal,
              //                fontSize: 12,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Visibility(
                visible: model.showAddDiscount,
                child: additionalDiscountField(context, model),
              ),
              SizedBox(height: 20.h),

              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  child: Column(
                    children: [
                      allCalculationDisplay(context, model,isSalesReturn),
                      SizedBox(height: 10.h),
                      // Shortcuts(
                      //   shortcuts: <LogicalKeySet, Intent>{
                      //     // Map the F1 key to an intent
                      //     LogicalKeySet(LogicalKeyboardKey.f1): const ActivateIntent(),
                      //   },
                      //   child: Actions(
                      //     actions: <Type, Action<Intent>>{
                      //       // Define the action to be executed
                      //       ActivateIntent: CallbackAction<ActivateIntent>(
                      //         onInvoke: (intent) async{

                      //         },
                      //       ),
                      //     },
                      //     child: Focus(
                      //       autofocus: true,
                      //       child: GestureDetector(
                      //         onTap: () {
                      //           if (model.isCheckOutScreen == false)
                      //           {

                      //              if(model.customerListController.text.isNotEmpty && model.cartItems.isNotEmpty){
                      //               model.isCheckOutScreenText='Edit Cart';
                      //               model.isCheckOutScreen = true;
                      //               model.notifyListeners();
                      //           }
                      //           if (model.cartItems.isEmpty)
                      //           {
                      //                 model.customerNotSelectionMsg = 'Please Add Items To Cart';
                      //                 model.msgTimeOut = true;
                      //                 model.notifyListeners();
                      //                 return ;
                      //           }
                      //           if (model.customerListController.text.isEmpty)
                      //           {
                      //                 model.customerNotSelectionMsg = 'Please Select Customer';
                      //                 model.msgTimeOut = true;
                      //                 model.notifyListeners();
                      //                 return ;
                      //           }
                      //           }
                      //           else if (model.isCheckOutScreen == true && model.isCheckOutScreenText=='Edit Cart')
                      //           {
                      //             model.isCheckOutScreen = false;
                      //             model.notifyListeners();
                      //           }

                      //         },
                      //         child: Container(
                      //           padding:
                      //           EdgeInsets.all(10.r),
                      //           width: 1.sw,
                      //           decoration: BoxDecoration(
                      //             borderRadius:
                      //             BorderRadius.all(
                      //                 Radius.circular(
                      //                     5.r)),
                      //             color: model.cartItems.isNotEmpty && model.isCheckOutScreen == false ? Colors.blue : AppColors.lightBlue,
                      //           ),
                      //           child: Center(
                      //             child: SingleText(
                      //               text: model.isCheckOutScreenText,
                      //               fontWeight:
                      //               FontWeight.bold,
                      //                fontSize: 12,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Visibility(
            visible:
                model.customerNotSelectionMsg != '' && model.msgTimeOut == true,
            child: CommonMessagePrint(
              msg: model.customerNotSelectionMsg,
              onTap: () {
                model.customerNotSelectionMsg = '';
                model.msgTimeOut = false;
                model.notifyListeners();
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _actionButton(String text, {Color color = const Color(0xFF2490EF)}) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Text(text),
  );
}
