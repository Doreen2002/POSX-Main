import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';

import '../common_utils/app_colors.dart';

class CommonSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Widget? suffix;
  final FocusNode? focusNode; // <-- Add focusNode
  final bool autofocus; // <-- Add autofocus
  final bool readonly;

  const CommonSearchBar({
    super.key,
    required this.controller,
    this.onSubmitted,
    this.onChanged,   
    this.suffix,
    this.focusNode, // <-- Accept focusNode
    this.autofocus = false, // <-- Accept autofocus
    this.readonly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFFFFF),
      child: SizedBox(
        height: 50.h,
        width: 70.w,
        child: TextField(
          maxLines: 1,
          controller: controller,
          focusNode: focusNode, // <-- Pass to TextField
          autofocus: autofocus, // <-- Pass to TextField
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          readOnly: readonly,
          cursorHeight: 25.h,
          cursorColor: const Color(0xFF2B3691),
          style: TextStyle(
            fontSize: 5.sp,
            color: const Color(0xFF2B3691),
            overflow: TextOverflow.ellipsis,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Search by item code, serial number or batch',
            hintMaxLines: 1,
            hintStyle: TextStyle(
              color: AppColors.lightTextColor,
              fontSize: 5.sp,
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2B3691)),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF0D6B31)),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2B3691)),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            suffixIcon: suffix,
            suffixIconColor: const Color(0xFF006A35),
          ),
        ),
      ),
    );
  }
}

class CommonItemGroupSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Widget? suffixIcon;
  const CommonItemGroupSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40.h,
          width: 50.w,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cartListColor),
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: AppColors.cartListColor,
          ),
          child: TextField(
            controller: controller,
            // style: TextStyle(color: AppColors.lightTextColor,fontSize: 5.sp),
            cursorColor: AppColors.cartTextColor,
            cursorHeight: 20.h,
            onChanged: onChanged,
            decoration: InputDecoration(
              // isCollapsed: true,
              // contentPadding: EdgeInsets.only(top: 2.h,bottom: 10.h,left: 3.w,right: 3.w),
              contentPadding: EdgeInsets.all(22.r),
              hintText: 'Item Group',
              // filled: true,
              // fillColor: AppColors.cartListColor,
              suffixIcon: suffixIcon,
              labelStyle: const TextStyle(color: AppColors.cartTextColor),
              hintStyle: TextStyle(
                fontSize: 4.sp,
                color: AppColors.lightTextColor,
              ),
              border: InputBorder.none,
            ),
          ),
          // decoration: BoxDecoration(
          //   border: Border.all(color: AppColors.cartListColor),
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(10.r),
          //   ),
          //   color: AppColors.cartListColor,
          // ),
          // child: TextField(
          //   maxLines: 1,
          //   clipBehavior: Clip.none,
          //   controller: controller,
          //   decoration: InputDecoration(
          //     hintText: 'Select item group',
          //     hintMaxLines: 1,
          //     hintStyle: TextStyle(color: AppColors.lightTextColor,fontSize: 4.sp),
          //     border: InputBorder.none,
          //     contentPadding: EdgeInsets.all(20.r),
          //     // suffixIcon: Icon(Icons.search,color: AppColors.lightTextColor,size: 28.r,),
          //   ),
          //   onChanged: onChanged,
          // ),
        ),
      ),
    );
  }
}

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final bool? readOnly;
  final Function(PointerDownEvent)? onOutSideTap;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final String hintText;
  final FocusNode? focusNode;
  final Widget? suffix;
  final TextInputType? keyboardType;
  const CommonTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onTap,
    required this.hintText,
    this.focusNode,
    this.keyboardType,
    this.onOutSideTap,
    this.suffix,
    this.inputFormatters,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.cartListColor),
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            readOnly: readOnly ?? false,
            style: TextStyle(
              color: AppColors.bottomIconColor,
              fontSize: 5.sp,
              fontWeight: FontWeight.bold,
            ),
            cursorColor: AppColors.cartTextColor,
            cursorHeight: 20.h,
            onChanged: onChanged,
            onTapOutside: onOutSideTap,

            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blueAccent, // Color when focused
                  width: 2.0,
                ),
              ),
              isDense: true,
              hintText: hintText,
              filled: true,
              suffix: suffix,
              fillColor: AppColors.white,
              labelStyle: const TextStyle(color: AppColors.cartTextColor),
              hintStyle: TextStyle(
                fontSize: 5.sp,
                color: AppColors.bottomIconColor,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
