import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common_utils/app_colors.dart';

class CashPaymentTextField extends StatelessWidget {
  final TextEditingController controller;
  final Widget? icon;
  final String? hintText;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onChange;
  final bool? isObsecure;
  const CashPaymentTextField({
    super.key,
    required this.controller,
    this.icon,
    this.hintText,
    this.suffixIcon,
    this.isObsecure = false,
    this.onChange,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: AppColors.cartTextColor, fontSize: 5.sp),
      cursorColor: AppColors.cartTextColor,
      obscureText: isObsecure!,
      onChanged: onChange,
      keyboardType: TextInputType.number,
      // keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: icon,
        isDense: true,
        // isCollapsed: true,
        // contentPadding: EdgeInsets.only(top: 18.h,bottom: 15.h,left: 3.w,right: 3.w),
        hintText: hintText,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.cartListColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF006A35), width: 1.r),
        ),
        labelStyle: const TextStyle(color: Color(0xFF006A35)),
        hintStyle: TextStyle(fontSize: 5.sp, color: Color(0xFF006A35)),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF006A35), width: 1.r),
        ),
      ),
    );
  }
}

class CashPayPaymentTextField extends StatelessWidget {
  final TextEditingController controller;
  final Widget? icon;
  final String? hintText;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final bool autoFocus;
  final Function(String)? onChange;
  final Function()? onTap;
  final Function(PointerDownEvent)? onTapOutside;
  final bool? isObsecure;
  const CashPayPaymentTextField({
    super.key,
    required this.controller,
    this.icon,
    this.hintText,
    this.suffixIcon,
    this.isObsecure = false,
    this.onChange,
    this.inputFormatters,
    this.onTap,
    this.focusNode,
    required this.autoFocus,
    this.onTapOutside,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autoFocus,
      style: TextStyle(
        color: Color(0xFF006A35),
        fontSize: 5.sp,
        fontWeight: FontWeight.bold,
      ),
      cursorColor: Color(0xFF006A35),
      cursorHeight: 20.h,
      obscureText: isObsecure!,
      onChanged: onChange,
      onTap: onTap,
      onTapOutside: onTapOutside,
      keyboardType: TextInputType.number,
      // keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: icon,
        isDense: true,
        // isCollapsed: true,
        // contentPadding: EdgeInsets.only(top: 18.h,bottom: 15.h,left: 3.w,right: 3.w),
        hintText: hintText,
        suffixIcon: suffixIcon,
        // filled: true,
        // fillColor: AppColors.cartListColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFF006A35), width: 1.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF006A35), width: 1.r),
        ),
        labelStyle: const TextStyle(color: Color(0xFF006A35)),
        hintStyle: TextStyle(fontSize: 5.sp, color: Color(0xFF006A35)),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF006A35), width: 1.r),
        ),
      ),
    );
  }
}
