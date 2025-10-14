import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:offline_pos/database_conn/get_item_queries.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';
import 'package:offline_pos/models/batch_list_model.dart';
import 'package:offline_pos/models/item.dart';
import '../common_utils/app_colors.dart';
import '../common_widgets/single_text.dart';

Widget batchSelectionDialog(
  context,
  model,
  int hasBatch,
  int hasSerial,
  int qty,
  String itemCodeName,
  String itemName, {
  Function()? submit,
  double? batchQty,
  String? batchNo,
  String? serialNo,
}) {

  return StatefulBuilder(
    builder: (context, setState) {
      return IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.only(left: 100.w, right: 100.w),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              // backgroundColor: AppColors.white,
              child: Material(
                // color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5.w, right: 5.w),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center, // Changed to center
                            children: [
                              SingleText(
                                text:
                                    hasSerial == 1 && hasBatch == 1
                                        ? 'Select Batch ID and Serial ID'
                                        : hasBatch == 1 && hasSerial == 0
                                        ? 'Select Batch ID'
                                        : hasSerial == 1 && hasBatch == 0
                                        ? 'Select Serial ID'
                                        : '',
                                fontSize: 6.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2B3691),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Visibility(
                          visible: hasBatch == 1,
                          child: Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.w, right: 5.w),
                              child: Container(
                                // height: 50.h,
                                width: 500,
                                padding: EdgeInsets.only(left: 3.w),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF2B3691)),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                  color: AppColors.cartListColor,
                                ),
                                child: Center(
                                  child: TypeAheadField(
                                    controller: TextEditingController(),
                                    builder:
                                        (
                                          context,
                                          controller,
                                          focusNode,
                                        ) => TextField(
                                          controller: model.batchController,
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
                                              fontSize: 7.sp,
                                              color: Color(0x812B3591),
                                            ),
                                            suffixIcon: Visibility(
                                              // visible: model.batchController.text.isNotEmpty,
                                              child: InkWell(
                                                onTap: () async {
                                                  model.batchController.text =
                                                      '';
                                                },
                                                child: Icon(
                                                  Icons.clear,
                                                  size: 25.r,
                                                  color:
                                                      AppColors.cartTextColor,
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
                                      final batch = OptimizedDataManager.getBatchByCode(suggestion ?? '') ?? BatchListModel( batchId: '',name: '', expiryDate: '');
                                      final matchingCart = model.cartItems
                                          .firstWhere(
                                            (cart) =>
                                                cart.batchNumberSeries ==
                                                batch.batchId,
                                            orElse:
                                                () => Item(
                                                  name: '',
                                                  itemCode: '',
                                                  itemName: '',
                                                  itemGroup: '',
                                                  stockUom: '',
                                                  image: '',
                                                  qty: 0,
                                                  itemTotal: 0,
                                                  newRate: 0,
                                                ),
                                          );

                                      final cartQty = matchingCart.qty;

                                      return ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              batch.batchId!,
                                              style: TextStyle(fontSize: 5.sp),
                                            ),
                                            if (batch.expiryDate != null &&
                                                batch
                                                    .expiryDate!
                                                    .isNotEmpty) ...[
                                              SizedBox(width: 1.w),
                                              Text(
                                                '|',
                                                style: TextStyle(
                                                  fontSize: 5.sp,
                                                ),
                                              ),
                                              SizedBox(width: 1.w),
                                              Text(
                                                DateFormat('dd-MM-yyyy').format(
                                                  DateTime.parse(
                                                    batch.expiryDate!,
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 5.sp,
                                                ),
                                              ),
                                            ],
                                            SizedBox(width: 1.w),
                                            Text(
                                              '|',
                                              style: TextStyle(fontSize: 5.sp),
                                            ),
                                            SizedBox(width: 1.w),
                                            Text(
                                              ((batch.batchQty ?? 0))
                                                  .toString(),
                                              style: TextStyle(fontSize: 5.sp),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onSelected: (suggestion) {
                                      model.batchController.text = suggestion;
                                    },
                                    suggestionsCallback: (pattern) async {
                                      return batchListdata
                                          .where(
                                            (element) =>
                                                element.item == itemCodeName &&
                                                element.batchId!
                                                    .toLowerCase()
                                                    .contains(
                                                      pattern.toLowerCase(),
                                                    ),
                                          )
                                          .map(
                                            (e) => e.name,
                                          ) // Make sure you map to .name since you're using it in firstWhere
                                          .toList();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Visibility(
                          visible: hasSerial == 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.w, right: 5.w),
                            child: Container(
                              height: 100.h,
                              width: 1.sw,
                              padding: EdgeInsets.only(left: 3.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFF2B3691)),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                                color: AppColors.cartListColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SingleText(
                                    text: "Serial No",
                                    color: Color(0x812B3591),
                                  ),

                                  Visibility(
                                    // visible: itemWiseSerialVisibility == true,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return SizedBox(
                                          height: 50.h,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SingleText(
                                                text:
                                                    model
                                                        .serialController
                                                        .text = model
                                                            .serialItem[index]
                                                            .name ??
                                                        "",
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (context, child) =>
                                              SizedBox(height: 0.h),
                                      itemCount:
                                          batchListdata
                                              .where(
                                                (element) =>
                                                    element.item ==
                                                    itemCodeName,
                                              )
                                              .length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Visibility(
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
                                  border: Border.all(color: Color(0xFF006A35)),
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
                                  color: Color(0xFF006A35),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 🔹 Close Button
                            GestureDetector(
                              onTap: () async {
                                model.batchController.text = '';
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 160.h, // ✅ Bigger touch area
                                width: 80.w, // ✅ Wider button
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: const Color(0xFF2B3691),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: SingleText(
                                  text: 'Close',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 10.w,
                            ), // ✅ More spacing between buttons
                            // 🔹 Submit Button
                            GestureDetector(
                              onTap: submit,
                              child: Container(
                                height: 160.h, // ✅ Bigger touch area
                                width: 80.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  color: Color(0xFF006A35),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: SingleText(
                                  text: 'Submit',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
          ),
        ),
      );
    },
  );
}
