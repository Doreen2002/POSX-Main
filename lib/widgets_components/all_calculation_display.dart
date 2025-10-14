import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/widgets_components/number_pad.dart';
import '../common_widgets/single_text.dart';

Widget allCalculationDisplay(
  BuildContext context,
  CartItemScreenController model,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Left: Totals
      Expanded(
        flex: 1,
        child: Container(
        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow(
                "Gross Total",
                UserPreference.getString(PrefKeys.currency)! +
                    " " +
                    model
                        .roundToDecimals(model.grossTotal, model.decimalPoints)
                        .toStringAsFixed(model.decimalPoints),
              ),

              _buildRow(
                "Discount",
                UserPreference.getString(PrefKeys.currency)! +
                    " " +
                    (double.tryParse(
                              model.allItemsDiscountAmount.text.isNotEmpty
                                  ? model.allItemsDiscountAmount.text
                                  : "0",
                            ) ??
                            0)
                        .toStringAsFixed(model.decimalPoints),
              ),

              _buildRow(
                "Net Total",
                UserPreference.getString(PrefKeys.currency)! +
                    " " +
                    model.netTotal.toStringAsFixed(model.decimalPoints),
              ),

              _buildRow(
                "VAT Total",
                UserPreference.getString(PrefKeys.currency)! +
                    " " +
                    model.vatTotal.toStringAsFixed(model.decimalPoints),
              ),

              _buildRow(
                "Grand Total",
                UserPreference.getString(PrefKeys.currency)! +
                    " " +
                    model
                        .roundToDecimals(model.grandTotal, model.decimalPoints)
                        .toStringAsFixed(model.decimalPoints),
              ),

              _buildRow("Total Quantity", model.totalQTy.toString()),
              Visibility(
                visible:
                    model.allItemsDiscountPercent.text.isNotEmpty &&
                    model.allItemsDiscountPercent.text != '0',
                child: _buildRow(
                  "Discount % ",
                  ' ${model.allItemsDiscountPercent.text} %',
                ),
              ),
            ],
          ),
        ),
      ),

      SizedBox(width: 16), // space between totals and pad
      // Right: Number Pad
      Expanded(
        flex: 3, // fixed width for number pad
        child: NumberPad(),
      ),
    ],
  );
}

// Helper widget to avoid repeating Row logic
Widget _buildRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SingleText(
          text: label,
          fontWeight: FontWeight.bold,
          fontSize: 5.sp,
          color: Color(0xFF07723C),
        ),
        SingleText(
          text: value,
          fontWeight: FontWeight.bold,
          fontSize: 5.sp,
          color: Color(0xFF07723C),
        ),
      ],
    ),
  );
}
