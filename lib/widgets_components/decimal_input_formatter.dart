import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange; // Number of decimal places allowed

  DecimalTextInputFormatter({required this.decimalRange});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Allow empty input
    if (text.isEmpty) {
      return newValue;
    }

    // Allow only numbers and one decimal point
    if (RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
      // Restrict decimal places
      if (text.contains('.') && text.split('.')[1].length > decimalRange) {
        return oldValue;
      }
      return newValue;
    }

    // If the input is invalid, keep the old value
    return oldValue;
  }
}
