import 'package:offline_pos/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import '../common_utils/app_colors.dart';
import '../common_widgets/single_text.dart';
import '../widgets_components/decimal_input_formatter.dart';

Widget additionalDiscountField(
  BuildContext context,
  CartItemScreenController model,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: DottedBorder(
      color: AppColors.cartTextColor,
      child: SizedBox(
        width: 160.w,
        child: Container(
          padding: EdgeInsets.all(5.r),
          child: Column(
            children: [
              Row(
                children: [
                  // Amount label + input
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          // color: AppColors.cartListColor,
                          child: SingleText(
                            text:
                                '${UserPreference.getString(PrefKeys.currency)}.',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 50.w,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40.h,
                                  margin: EdgeInsets.only(left: 4.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: Color(0xFF006A35),
                                      width: 2,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: model.allItemsDiscountAmount,
                                    keyboardType: TextInputType.number,
                                    focusNode:
                                        model.allItemsDiscountAmountFocusNode,
                                    // readOnly:
                                    //     model.allItemsDiscountPercent.text.isNotEmpty,
                                    inputFormatters: [
                                      DecimalTextInputFormatter(
                                        decimalRange: 3,
                                      ),
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    cursorHeight: 18.h,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintStyle: TextStyle(
                                        color: AppColors.lightTextColor,
                                        fontSize: 5.sp,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      allItemsDiscountAmountOnChange(
                                        model,
                                        value,
                                        context,
                                      );
                                    },
                                    onTapOutside: (_) {
                                      if (model
                                          .allItemsDiscountAmount
                                          .text
                                          .isEmpty) {
                                        model.showAddDiscount = false;
                                        model.notifyListeners();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  model.allItemsDiscountPercent.clear();
                                  model.allItemsDiscountAmount.clear();
                                  FocusScope.of(context).requestFocus(
                                    model.allItemsDiscountAmountFocusNode,
                                  );
                                  model.hasFocus = '';
                                  model.discountCalculation(
                                    model.allItemsDiscountAmount.text,
                                    model.allItemsDiscountPercent.text,
                                  );
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
                  SizedBox(width: 10.w),

                  // Percent label + input
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          // color: AppColors.cartListColor,
                          child: SingleText(
                            text: '%',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(
                          width: 50.w,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 40.h,
                                  margin: EdgeInsets.only(left: 4.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: Color(0xFF006A35),
                                      width: 2,
                                    ),
                                  ),

                                  child: TextField(
                                    controller: model.allItemsDiscountPercent,
                                    focusNode:
                                        model.allItemsDiscountPercentFocusNode,
                                    keyboardType: TextInputType.number,
                                    // readOnly:
                                    //     model.allItemsDiscountAmount.text.isNotEmpty,
                                    inputFormatters: [
                                      DecimalTextInputFormatter(
                                        decimalRange: 3,
                                      ),
                                      LengthLimitingTextInputFormatter(5),
                                    ],
                                    cursorHeight: 18.h,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintStyle: TextStyle(
                                        color: AppColors.lightTextColor,
                                        fontSize: 5.sp,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    onTapOutside: (_) {
                                      if (model
                                          .allItemsDiscountPercent
                                          .text
                                          .isEmpty) {
                                        model.showAddDiscount = false;
                                        model.notifyListeners();
                                      }
                                    },
                                    onChanged: (val) {
                                      allItemsDiscountPercentOnChange(
                                        model,
                                        val,
                                        context,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  model.allItemsDiscountPercent.clear();
                                  model.allItemsDiscountAmount.clear();
                                  FocusScope.of(context).requestFocus(
                                    model.allItemsDiscountPercentFocusNode,
                                  );
                                  model.hasFocus = '';
                                  model.discountCalculation(
                                    model.allItemsDiscountAmount.text,
                                    model.allItemsDiscountPercent.text,
                                  );
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
            ],
          ),
        ),
      ),
    ),
  );
}

void allItemsDiscountAmountOnChange(model, value, context) async {
  await UserPreference.getInstance();

  final applyDiscountOn = UserPreference.getString(PrefKeys.applyDiscountOn);
  final rawMaxPercent = UserPreference.getString(PrefKeys.maxDiscountAllowed);
 

  double _maxPercent = double.tryParse(rawMaxPercent ?? "100") ?? 100;
  double _maxAmount;

  if (applyDiscountOn == 'Grand Total') {
    _maxAmount = model.grossTotal * _maxPercent / 100;
  } else if (applyDiscountOn == 'Net Total') {
    _maxAmount = (model.originalNetTotal) * _maxPercent / 100;
  } else {
    throw Exception('Invalid value for applyDiscountOn: $applyDiscountOn');
  }

  double amount = double.tryParse(value) ?? 0;

  if (value.isEmpty) {
    model.allItemsDiscountPercent.text = '';
    model.discountCalculation(value, '');
    return;
  }
  _maxAmount =
      double.tryParse((_maxAmount ?? 0).toStringAsFixed(model.decimalPoints)) ??
      0;
  if (amount <= _maxAmount && model.grossTotal != 0) {
   
    model.discountCalculation(value, '');
    model.showAddDiscount = true;
    model.allItemDiscountValidated = true;
  } else {
   

    model.allItemsDiscountPercent.text = '';
    model.allItemsDiscountAmount.text = '';

    DialogUtils.showError(
      context: context,
      title:
          "Discount cannot be greater than ${UserPreference.getString(PrefKeys.currency)} ${(double.tryParse(_maxAmount.toString()) ?? 0).toStringAsFixed(model.decimalPoints)}",
      message: "",
    );

    model.notifyListeners();
    model.discountCalculation('', '');
    model.allItemDiscountValidated = false;
  }
}

void allItemsDiscountPercentOnChange(model, val, context) async {
  await UserPreference.getInstance();
  final rawMax = UserPreference.getString(PrefKeys.maxDiscountAllowed);



  double _maxPercent = double.tryParse(rawMax ?? "0") ?? 0;

  if (val.isEmpty) {
    model.allItemsDiscountAmount.text = '';
    model.discountCalculation('', val);
  }

  if (val.isNotEmpty) {
    double percent = double.tryParse(val) ?? 0;

    if (percent <= _maxPercent && model.grossTotal != 0) {
   
      model.discountCalculation('', val);
      model.showAddDiscount = true;
      model.allItemDiscountValidated = true;
    } else {
      model.allItemsDiscountPercent.text = '';
      model.allItemsDiscountAmount.text = '';

      DialogUtils.showWarning(
        context: context,
        title: "Discount cannot be greater than $_maxPercent %",
        message: "",
      );

      model.msgTimeOut = true;
      model.notifyListeners();
      model.discountCalculation('', '');
      model.allItemDiscountValidated = false;
    }
  }
}
