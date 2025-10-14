import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:offline_pos/common_widgets/single_text.dart';
import 'package:oktoast/oktoast.dart';

import '../constants/common_const.dart';
import '../data_source/network/exception_handle.dart';
import '../data_source/network/log_utils.dart';
import 'common_loader.dart';

mixin BaseCommonWidget {


  Widget getProgressBar(ViewState viewState) {
    if (viewState == ViewState.busy) {
      return Container(
        color: Colors.white.withAlpha(204),
        child: const Center(
          child: ColorLoader5(
            dotOneColor: Colors.blue,
            dotTwoColor: Colors.lightBlue,
            dotThreeColor: Colors.lightBlueAccent,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  static void showOkMessage(String message, bool isError) {
    try {
      showToast(
        "message",
        position: ToastPosition.bottom,
        backgroundColor: Colors.red,
        radius: 13.0,
        textStyle: const TextStyle(fontSize: 18.0,color:Colors.white),
        // animationBuilder: Miui10AnimBuilder(),
      );
    } on BaseException catch (e) {
      LogUtils.writeLog(message: e.message, tag: "showErrorMessage");
    }
  }



  Widget getMessage(String message, bool isError) {
    if (message != '') {
      return Container(
          height: 25.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            color: isError == true ? Colors.red : Colors.green,
          ),
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: SingleText(
            text: message,
            fontSize: 4.sp,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ));
    } else {
      return Container();
    }
  }

  static void getMessageBar(String message, bool isError) {
      try {
        Container(
            height: 25.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              color: isError == true ? Colors.red : Colors.green,
            ),
            padding: EdgeInsets.only(left: 5.w, right: 5.w),
            child: SingleText(
              text: message,
              fontSize: 4.sp,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ));
      } on BaseException {
        // LogUtils.writeLog(message: e.message, tag: "showErrorMessage");
      }
  }

  Widget getCommonText({
    required String text,
    TextStyle? style,
    TextOverflow? overflow,
    TextAlign? textAlign,
    int? maxLines,
    bool? softWrap,
    Color? textColor,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
  }) {
    return Text(
      text,
      style: style ??
          TextStyle(
            fontWeight: fontWeight,
            color: textColor,
            fontSize: fontSize,
            fontFamily: fontFamily,
          ),
      overflow: overflow,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
    );
  }

}