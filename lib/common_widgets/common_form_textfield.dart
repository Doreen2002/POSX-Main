import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/common_utils/app_colors.dart';
import 'package:offline_pos/common_widgets/single_text.dart';

class CommonFormTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final Function(String)? onChange;
  final Function(PointerDownEvent)? onTapOutside;
  final FormFieldValidator<String>? validator;
  const CommonFormTextField({
    super.key,
    required this.controller,
    this.onTap,
    required this.text,
    this.inputFormatters,
    this.keyboardType,
    this.validator,
    this.onChange,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleText(
            text: text,
            color: const Color(0xFF024126),
            fontSize: 6.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 5.h),
          TextFormField(
            controller: controller,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 6.sp),
            validator: validator,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 15.h,
                bottom: 15.h,
                left: 3.w,
                right: 3.w,
              ),
              isDense: true,
              border: const OutlineInputBorder(),
              // labelText: "Delivery Date",
            ),
            onTap: onTap,
            onChanged: onChange,
            onTapOutside: onTapOutside,
          ),
        ],
      ),
    );
  }
}

class CommonDiscountTextField extends StatelessWidget {
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final Function(String)? onChange;
  final Function(PointerDownEvent)? onTapOutside;
  final FormFieldValidator<String>? validator;
  const CommonDiscountTextField({
    super.key,
    required this.controller,
    this.onTap,
    this.inputFormatters,
    this.keyboardType,
    this.validator,
    this.onChange,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      // style: TextStyle(fontSize: 4.sp),
      // validator: validator,
      cursorHeight: 18.h,
      // autofocus: true,
      decoration: InputDecoration(
        isDense: true,
        hintMaxLines: 1,
        hintStyle: TextStyle(color: AppColors.lightTextColor, fontSize: 5.sp),
        border: InputBorder.none,
      ),
      onTap: onTap,
      onChanged: onChange,
      onTapOutside: onTapOutside,
    );
  }
}
