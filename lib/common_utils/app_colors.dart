
import 'package:flutter/material.dart';

class AppColors{
  static const Color appbarGreen = Color.fromARGB(182, 89, 175, 246);
  static const Color lightBlue = Color.fromARGB(182, 170, 213, 246);
  static const Color bottomIconColor = Color.fromARGB(182, 29, 71, 105);
  static const Color lightTextColor = Color.fromARGB(218, 195, 191, 191);
  static const Color shadowColor = Color.fromARGB(39, 5, 5, 5);
  static const Color textColor = Color.fromARGB(38, 154, 162, 152);
  static const Color invoiceStatusColor = Color.fromARGB(255, 232, 239, 232);
  static const Color errorContainerColor = Color.fromARGB(255, 250, 237, 204);
  static const Color errorStatusColor = Color.fromARGB(255, 196, 161, 66);
  static const Color errorColor = Color(0xffc52b2b);
  static const Color successColor = Colors.green;
  static const Color darkGreenColor = Color.fromARGB(255, 67, 122, 68);

  static const Color white = Colors.white;
  static const Color cartListColor = Color(0xffeaeaee);
  static const Color circularColor = Color(0xfffafafc);
  static const Color invoiceItemColor = Color(0xfff5f5f6);
  static const Color cartTextColor = Color(0xff8b8b8f);
  static const Color mediumGreyColor = Color(0xff828285);


// 238, 238, 238
}


  final Color blueColor = Color(0xFF2490EF);

  final Color yellowColor = Color(0xFFFFF9C4); 


 // soft yellow
  Widget buildButton(String text, 
      {Color? bgColor,  double? width, double? height,  double?fontSize,  Color textColor = const Color.fromARGB(255, 250, 249, 249), VoidCallback? onPressed}) {
      
    return Container(
      height: height,
      width: width,
      // margin: const EdgeInsets.all(2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor ?? Colors.white,
          foregroundColor: textColor,
          // fixedSize: const Size(2, 2),
          // padding: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(color: Colors.grey),
          ),
        ),
        onPressed: onPressed ?? () {},
        child: Text(text, style:TextStyle(fontSize: fontSize), textAlign: TextAlign.center,),
      ),
    );
  }