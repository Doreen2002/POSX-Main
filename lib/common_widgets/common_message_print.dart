import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/common_utils/app_colors.dart';
import 'package:offline_pos/common_widgets/single_text.dart';

class CommonMessagePrint extends StatelessWidget {
  final String msg;
  final Function() onTap;
  const CommonMessagePrint({super.key, required this.msg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.errorContainerColor,
        borderRadius: BorderRadius.all(Radius.circular(10.r))
      ),
      padding: EdgeInsets.only(top: 8.h,bottom: 8.h,left: 4.w,right: 4.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.warning,size: 35.r,color: AppColors.errorStatusColor,),
          SizedBox(width : 3.w),
          SingleText(text: msg,fontSize: 5.sp,fontWeight: FontWeight.bold,maxLine: 5,overflow: TextOverflow.ellipsis,),
          SizedBox(width : 3.w),
          InkWell(
            onTap: onTap,
              child: Icon(Icons.clear,size: 30.r,))
        ],
      ),
    );
  }
}
