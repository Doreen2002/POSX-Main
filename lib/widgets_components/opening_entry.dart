import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/api_requests/post_pos_entry.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/database_conn/insert_pos.dart';
import '../common_utils/app_colors.dart';
import '../common_widgets/single_text.dart';
import '../common_widgets/common_form_textfield.dart';
import '../widgets_components/decimal_input_formatter.dart';

Widget openingEntryDialog(context, CartItemScreenController model, {onNext}) {
  bool _isTapped = false;
  getPosOpening();
  void _appendToTextField(String value) {
    final currentText = model.posOpeningAmount.text;

    // Prevent multiple decimal points
    if (value == '.' && currentText.contains('.')) {
      return;
    }

    // Prevent decimal as first character
    if (value == '.' && currentText.isEmpty) {
      model.posOpeningAmount.text = '0.';
      return;
    }
   
    if (currentText.length >= 10) {
      return;
    }
     if (currentText.contains('.')) {
    final parts = currentText.split('.');
    final decimals = parts[1];

    // If there are already 3 decimal places, stop further typing
    if (decimals.length > (model.decimalPoints - 1)) {
      return ;
    }
  }
    model.posOpeningAmount.text = currentText + value;
  }

  bool _isNumberPadVisible = false;
  void _backspace() {
    final currentText = model.posOpeningAmount.text;
    if (currentText.isNotEmpty) {
      model.posOpeningAmount.text = currentText.substring(
        0,
        currentText.length - 1,
      );
    }
  }

  void _clearTextField() {
    model.posOpeningAmount.clear();
  }

  void _submitAmount() {
    final amount = double.tryParse(model.posOpeningAmount.text) ?? 0.0;
 
  }

  Widget _buildKeypadButton(
    String text,
    VoidCallback onPressed, {
    bool isSpecial = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSpecial ? Color(0xFF07723C) : Color(0xFF2B3691),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(16),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  model.companyName.text = UserPreference.getString(PrefKeys.companyName) ?? "";
  model.posProfileController.text =
      UserPreference.getString(PrefKeys.posProfileName) ?? "";
  model.openingEntryPaymentController.text =
      UserPreference.getString(PrefKeys.paymentMode) ?? '';
  model.posOpeningAmount.text = (double.tryParse(
            UserPreference.getString(PrefKeys.openingAmount) ?? '0',
          ) ??
          0)
      .toStringAsFixed(model.decimalPoints);
  return StatefulBuilder(
    builder: (context, setState) {
      return IntrinsicHeight(
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 100.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0.r),
          ),
          backgroundColor: AppColors.white,
          child: Material(
            child: Padding(
              padding: EdgeInsets.only(
                top: 20.h,
                bottom: 20.h,
                left: 5.w,
                right: 5.w,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "POS Opening Entry",
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2B3691),
                          ),
                        ),

                        // Visibility(
                        //   visible: model.openAmount.isNotEmpty,
                        //   child: InkWell(
                        //     onTap: () {},
                        //     child: const Icon(Icons.edit, size: 25),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 520,
                          child: CommonFormTextField(
                            controller: model.posOpeningAmount,
                            text: 'Enter Cash in Drawer',
                            keyboardType: TextInputType.none,
                            inputFormatters: [
                              DecimalTextInputFormatter(decimalRange: 3),
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),

                        // Toggle Button for Number Pad
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isNumberPadVisible = !_isNumberPadVisible;
                            });
                          },
                          icon: Icon(
                            _isNumberPadVisible
                                ? Icons.keyboard_hide
                                : Icons.keyboard,
                            size: 18,
                          ),
                          label: Text(
                            _isNumberPadVisible
                                ? 'Hide Number Pad'
                                : 'Show Number Pad',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2B3691),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Numeric Keypad (Conditionally Visible)
                        if (_isNumberPadVisible)
                          Center(
                            child: Container(
                              width: 400,
                              child: GridView.count(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 4,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                childAspectRatio: 1.0,
                                children: [
                                  _buildKeypadButton(
                                    '1',
                                    () => _appendToTextField('1'),
                                  ),
                                  _buildKeypadButton(
                                    '2',
                                    () => _appendToTextField('2'),
                                  ),
                                  _buildKeypadButton(
                                    '3',
                                    () => _appendToTextField('3'),
                                  ),
                                  _buildKeypadButton(
                                    '.',
                                    () => _appendToTextField('.'),
                                    isSpecial: true,
                                  ),

                                  _buildKeypadButton(
                                    '4',
                                    () => _appendToTextField('4'),
                                  ),
                                  _buildKeypadButton(
                                    '5',
                                    () => _appendToTextField('5'),
                                  ),
                                  _buildKeypadButton(
                                    '6',
                                    () => _appendToTextField('6'),
                                  ),
                                  _buildKeypadButton(
                                    '0',
                                    () => _appendToTextField('0'),
                                  ),

                                  _buildKeypadButton(
                                    '7',
                                    () => _appendToTextField('7'),
                                  ),
                                  _buildKeypadButton(
                                    '8',
                                    () => _appendToTextField('8'),
                                  ),
                                  _buildKeypadButton(
                                    '9',
                                    () => _appendToTextField('9'),
                                  ),
                                  _buildKeypadButton(
                                    '⌫',
                                    () => _backspace(),
                                    isSpecial: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible:
                              UserPreference.getString(
                                PrefKeys.openingAmount,
                              )!.isEmpty,
                          child: Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (_isTapped) return;
                                    _isTapped = true;
                                    
                                      int timestamp =
                                          DateTime.now()
                                              .millisecondsSinceEpoch ~/
                                          1000;
                                      if (await openPosRequest(
                                        UserPreference.getString(
                                          PrefKeys.httpType,
                                        )!,
                                        UserPreference.getString(
                                          PrefKeys.baseUrl,
                                        )!,
                                        true,
                                        {
                                          'pos_profile':
                                              UserPreference.getString(
                                                PrefKeys.posProfileName,
                                              )!,
                                          'company':
                                              UserPreference.getString(
                                                PrefKeys.companyName,
                                              )!,
                                          'user':
                                              UserPreference.getString(
                                                PrefKeys.userName,
                                              )!,
                                          'naming_series':
                                              'OV-${UserPreference.getString(PrefKeys.branchID)}-$timestamp',
                                          'period_start_date':
                                              DateTime.now().toString(),
                                          'balance_details': [
                                            {
                                              "mode_of_payment": "Cash",
                                              "opening_amount":
                                                  model.posOpeningAmount.text,
                                            },
                                            ...model.paymentModes
                                                .where(
                                                  (it) =>
                                                      it.name !=
                                                          "Loyalty Points" &&
                                                      it.name != "Cash",
                                                )
                                                .map(
                                                  (it) => {
                                                    "mode_of_payment": it.name,
                                                    "opening_amount": "0",
                                                  },
                                                )
                                                .toList(),
                                          ],
                                        },
                                      )) {
                                        Navigator.pop(context);
                                      }
                                      Navigator.pop(context);
                                   
                                    onNext();
                                     model.searchFocusNode.requestFocus();
                                  },
                                  child: Container(
                                    width: 260,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF006A35),
                                          Color(0xFF044223),
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: SingleText(
                                        text: 'Submit',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () =>{ Navigator.pop(context), model.searchFocusNode.requestFocus()},
                                  child: Container(
                                    width: 260,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF2B3691),
                                          Color(0xFF0E144D),
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: SingleText(
                                        text: 'Cancel',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Visibility(
                          visible:
                              UserPreference.getString(
                                PrefKeys.openingAmount,
                              )!.isNotEmpty,
                          child: Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                   if (posOpeningList.isNotEmpty)
                                   {
                                     await updatePosOpening(
                                      posOpeningList[0].name!,
                                      double.parse(model.posOpeningAmount.text),
                                      context,
                                    );
                                   }
                                    model.searchFocusNode.requestFocus();
                                  },
                                  child: Container(
                                    width: 260,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF018644),
                                          Color(0xFF033D20),
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: SingleText(
                                        text: 'Save',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () => {Navigator.pop(context),  model.searchFocusNode.requestFocus()},
                                  child: Container(
                                    width: 260,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF2B3691),
                                          Color(0xFF0E144D),
                                        ],
                                      ),
                                    ),
                                    child: const Center(
                                      child: SingleText(
                                        text: 'Cancel',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
