import 'package:offline_pos/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/database_conn/dbsync.dart' as itemListData;
import 'package:offline_pos/services/optimized_data_manager.dart';
import 'package:offline_pos/database_conn/get_payment.dart';
import 'package:offline_pos/models/item_model.dart';
import 'package:offline_pos/widgets_components/additional_discount.dart';
import 'package:offline_pos/widgets_components/checkout_right_screen.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/widgets_components/opening_entry.dart';
import 'package:offline_pos/widgets_components/single_item_discount.dart';
import 'package:provider/provider.dart';

class NumberPad extends StatefulWidget {
  @override
  State<NumberPad> createState() => _NumberPadState();

  final bool isSalesReturn;
  NumberPad(this.isSalesReturn);
}

class _NumberPadState extends State<NumberPad> {
  final Color blueColor = Color(0xFF006A35);
  final double buttonSize = 60; // Adjust for desired square size

  Widget buildButton(
    String text, {
    String? imagePath, // optional image
    Color? bgColor,
    double fontSize = 35,
    double imageSize = 35,
    Color textColor = Colors.black,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 50,
      height: 60,
      margin: const EdgeInsets.all(1),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? const Color(0xFF2B3691),
          foregroundColor: textColor,
          fixedSize: Size.square(buttonSize),
          padding: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: Colors.grey),
          ),
        ),
        onPressed: onPressed ?? () {},
        child:
            imagePath != null
                ? Image.asset(
                  imagePath,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.contain,
                )
                : Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<CartItemScreenController>(context);

    return Center(
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(color: Colors.transparent),
        children: [
          TableRow(
            children: [
              buildButton(
                "1",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '1', context);
                },
              ),
              buildButton(
                "2",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '2', context);
                },
              ),
              buildButton(
                "3",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '3', context);
                },
              ),

              buildButton(
                "Discount on \nInvoice",
                fontSize: 14,
                bgColor: Color(0xFF006A35),
                textColor: Colors.white,
                onPressed: () {
                  if (model.allItemsDiscountAmount.text.isNotEmpty ||
                      model.allItemsDiscountPercent.text.isNotEmpty) {
                    model.showAddDiscount = true;
                  } else {
                    // Toggle only if both fields are empty
                    model.showAddDiscount = !model.showAddDiscount;
                  }
                  model.notifyListeners();
                },
              ),
            ],
          ),
          TableRow(
            children: [
              buildButton(
                "4",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '4', context);
                },
              ),
              buildButton(
                "5",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '5', context);
                },
              ),
              buildButton(
                "6",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '6', context);
                },
              ),
              buildButton(
                "Submit\nPayment",
                fontSize: 14,
                bgColor: const Color(0xFF006A35),
                textColor: Colors.white,
                onPressed: () async {
                  if(widget.isSalesReturn)
                  {
                    return;
                  }
                  sumbitPaymentFnine(model, context);
                },
              ),
            ],
          ),
          TableRow(
            children: [
              buildButton(
                "7",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '7', context);
                },
              ),
              buildButton(
                "8",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '8', context);
                },
              ),
              buildButton(
                "9",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '9', context);
                },
              ),
              buildButton(
                "⌫", 
                imagePath: 'assets/ico/backspace.png',
                bgColor: const Color(0xFF006A35),
                imageSize: 35,
                onPressed: () async {
                  clear(model, context);
                },
              ),
            ],
          ),
          TableRow(
            children: [
              buildButton(
                "0",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '0', context);
                },
              ),

              buildButton(
                ".",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '.', context);
                },
              ),
              buildButton(
                "00",
                textColor: Colors.white,
                onPressed: () {
                  updateValue(model, '00', context);
                },
              ),

              const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}

bool _validateDecimalPointsExistence(String value, String currentText) {
  
  if (value == '.' && currentText.contains('.')) {
    return true;
  }
  return false;
}

void updateValue(model, value, context) {
  try {
    if (model.hasFocus == 'QTY') {
      final currentText = model.singleqtyController.text;

      _validateDecimalPointsExistence(value, currentText)
          ? model.singleqtyController.text = currentText
          : model.singleqtyController.text = currentText + value;

      model.singleqtyController.selection = TextSelection.fromPosition(
        TextPosition(offset: model.singleqtyController.text.length),
      );
      onChangeItemQTY(
        model.singleqtyController.text,
        model,
        model.selectedItemIndex,
      );
    }
    if (model.hasFocus == 'DISCOUNTAMOUNT') {
      final currentText = model.singlediscountAmountController.text;
      _validateDecimalPointsExistence(value, currentText)
          ? model.singlediscountAmountController.text = currentText
          : model.singlediscountAmountController.text = currentText + value;
      model
          .singlediscountAmountController
          .selection = TextSelection.fromPosition(
        TextPosition(offset: model.singlediscountAmountController.text.length),
      );
      onChageDiscountAmount(
        model,
        model.singlediscountAmountController.text,
        model.selectedItemIndex,
        context,
      );
    }
    if(model.hasFocus == "singleItemdiscountAmountfocusNode")
    {
       final currentText = model.singleItemdiscountAmountController.text;
      _validateDecimalPointsExistence(value, currentText)
          ? model.singleItemdiscountAmountController.text = currentText
          : model.singleItemdiscountAmountController.text = currentText + value;
      model
          .singleItemdiscountAmountController
          .selection = TextSelection.fromPosition(
        TextPosition(offset: model.singleItemdiscountAmountController.text.length),
      );
      model.singlediscountAmountController.text = ((double.tryParse(model
          .singleItemdiscountAmountController.text) ?? 0) / (int.tryParse(model.singleqtyController.text ) ?? 0)).toString();
      onChageDiscountAmount(
        model,
        model.singlediscountAmountController.text,
        model.selectedItemIndex,
        context,
      );
    }
    if (model.hasFocus == 'DISCOUNTPERCENT') {
      final currentText = model.singlediscountPercentController.text;

      _validateDecimalPointsExistence(value, currentText)
          ? model.singlediscountPercentController.text = currentText
          : model.singlediscountPercentController.text = currentText + value;
      model
          .singlediscountPercentController
          .selection = TextSelection.fromPosition(
        TextPosition(offset: model.singlediscountPercentController.text.length),
      );
      onChangeDiscountPercentage(
        model,
        model.singlediscountPercentController.text,
        model.selectedItemIndex,
        context,
      );
    }
    if (model.hasFocus == 'allItemsDiscountAmount') {
      final currentText = model.allItemsDiscountAmount.text;
      _validateDecimalPointsExistence(value, currentText)
          ? model.allItemsDiscountAmount.text = currentText
          : model.allItemsDiscountAmount.text = currentText + value;
      model.allItemsDiscountAmount.selection = TextSelection.fromPosition(
        TextPosition(offset: model.allItemsDiscountAmount.text.length),
      );
      allItemsDiscountAmountOnChange(
        model,
        model.allItemsDiscountAmount.text,
        context,
      );
    }
    if (model.hasFocus == 'allItemsDiscountPercent') {
      final currentText = model.allItemsDiscountPercent.text;
      _validateDecimalPointsExistence(value, currentText)
          ? model.allItemsDiscountPercent.text = currentText
          : model.allItemsDiscountPercent.text = currentText + value;
      model.allItemsDiscountPercent.selection = TextSelection.fromPosition(
        TextPosition(offset: model.allItemsDiscountPercent.text.length),
      );
      allItemsDiscountPercentOnChange(
        model,
        model.allItemsDiscountPercent.text,
        context,
      );
    }
    for (var focusNode in model.paymentModes) {
      if (model.hasFocus == focusNode.name) {
        final currentText = focusNode.controller.text;
        _validateDecimalPointsExistence(value, currentText)
            ? focusNode.controller.text = currentText
            : focusNode.controller.text = currentText + value;
        focusNode.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: focusNode.controller.text.length),
        );
        updatePayment(model, focusNode);
        model.notifyListeners();
      }
    }
  } catch (e) {
   logErrorToFile("$e");
  }
}

void clear(model, context) {
  if (model.hasFocus == 'QTY') {
    model.singleqtyController.clear();
    // Fast item lookup for stock validation (O(1) vs O(n))
    TempItem? item = OptimizedDataManager.getItemByCode(
      model.cartItems[model.selectedItemIndex].itemCode
    );
   
    model.cartItems[model.selectedItemIndex].qty = 0;
    model.singleqtyController.selection = TextSelection.fromPosition(
      TextPosition(offset: model.singleqtyController.text.length),
    );
  
    model.notifyListeners();
  }
  if (model.hasFocus == 'DISCOUNTAMOUNT') {
    model.singlediscountAmountController.clear();
    model.singlediscountAmountController.selection = TextSelection.fromPosition(
      TextPosition(offset: model.singlediscountAmountController.text.length),
    );
    onChageDiscountAmount(
      model,
      model.singlediscountAmountController.text,
      model.selectedItemIndex,
      context,
    );
  }
  if (model.hasFocus == 'DISCOUNTPERCENT') {
    model.singlediscountPercentController.clear();
    model
        .singlediscountPercentController
        .selection = TextSelection.fromPosition(
      TextPosition(offset: model.singlediscountPercentController.text.length),
    );
    onChangeDiscountPercentage(
      model,
      model.singlediscountPercentController.text,
      model.selectedItemIndex,
      context,
    );
  }
  if(model.hasFocus == "singleItemdiscountAmountfocusNode")
  {
    model.singlediscountAmountController.clear();
    model.singleItemdiscountAmountController.clear();
    onChageDiscountAmount(
      model,
      model.singlediscountAmountController.text,
      model.selectedItemIndex,
      context,
    );
  } 

  if (model.hasFocus == 'allItemsDiscountAmount') {
    model.allItemsDiscountAmount.clear();
    model.allItemsDiscountAmount.selection = TextSelection.fromPosition(
      TextPosition(offset: model.allItemsDiscountAmount.text.length),
    );
    allItemsDiscountAmountOnChange(
      model,
      model.allItemsDiscountAmount.text,
      context,
    );
  }
  if (model.hasFocus == 'allItemsDiscountPercent') {
    model.allItemsDiscountPercent.clear();
    model.allItemsDiscountPercent.selection = TextSelection.fromPosition(
      TextPosition(offset: model.allItemsDiscountPercent.text.length),
    );
    allItemsDiscountPercentOnChange(
      model,
      model.allItemsDiscountPercent.text,
      context,
    );
  }
  for (var focusNode in model.paymentModes) {
    if (model.hasFocus == focusNode.name) {
      focusNode.controller.clear();
      focusNode.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: focusNode.controller.text.length),
      );
      updatePayment(model, focusNode);
      model.notifyListeners();
    }
  }
}

void sumbitPaymentFnine(model, context) async {
  try {
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

    double amount = double.tryParse(model.allItemsDiscountAmount.text) ?? 0;
    _maxAmount =
        double.tryParse(
          (_maxAmount ?? 0).toStringAsFixed(model.decimalPoints),
        ) ??
        0;

    if (amount <= _maxAmount) {
    } else {
     

      model.allItemsDiscountPercent.text = '';
      model.allItemsDiscountAmount.text = '';

      DialogUtils.showDiscountError(
        context: context,
        message: "Discount cannot be greater than ${UserPreference.getString(PrefKeys.currency)} ${(double.tryParse(_maxAmount.toString()) ?? 0).toStringAsFixed(model.decimalPoints)}",
        width: MediaQuery.of(context).size.width * 0.4,
      );

      model.notifyListeners();
      model.discountCalculation('', '');
      return;
    }
    if (model.grandTotal <= 0) {
      DialogUtils.showDiscountError(
        context: context,
        message: "Discount can't be more than grand total",
        width: MediaQuery.of(context).size.width * 0.4,
      );

      return;
    }
    await getPosOpening();
    model.notifyListeners();
    if (posOpeningList.isEmpty) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return openingEntryDialog(context, model);
        },
      );
    }
   
    if (!model.isCheckOutScreen) {
      if (model.customerListController.text.isNotEmpty &&
          model.cartItems.isNotEmpty) {
        
        modeOfPaymentList = modeOfPaymentList;
        model.isCheckOutScreenText = 'Edit Cart';
        model.isCheckOutScreen = true;
        model.itemDiscountVisible = false;
        model.hasFocus = '';
        model.notifyListeners();
      }

      if (model.cartItems.isEmpty) {
        DialogUtils.showError(
          context: context,
          title: "Empty Cart",
          message: "Please add items to the cart before proceeding.",
          width: MediaQuery.of(context).size.width * 0.4,
        );

        model.msgTimeOut = true;
        model.notifyListeners();
        return;
      }

      if (model.customerListController.text.isEmpty) {
        DialogUtils.showWarning(
          context: context,
          title: "Customer Missing",
          message: "Please select a customer before submitting.",
          width: MediaQuery.of(context).size.width * 0.4,
        );

        model.msgTimeOut = true;
        model.notifyListeners();
        return;
      }
    } else if (model.isCheckOutScreen &&
        model.isCheckOutScreenText == 'Edit Cart') {
      model.isCheckOutScreen = false;
      model.notifyListeners();
    }
  } catch (e) {
    logErrorToFile("$e");
  }
}
