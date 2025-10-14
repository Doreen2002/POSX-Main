import 'package:flutter/material.dart';

class SingleText extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextOverflow? overflow;
  final int? maxLine;
  final TextDecoration? decoration;
  const SingleText({
    super.key,
    required this.text,
    this.fontWeight,
    this.color, this.fontSize,
    this.overflow, this.maxLine,
    this.fontFamily, this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      type: MaterialType.canvas,
      color: Colors.transparent,
      child: Text(text,
        maxLines: maxLine,
        style: TextStyle(
            decoration: decoration,
            fontFamily: fontFamily,
            fontWeight:fontWeight,
            color: color,
            fontSize: fontSize,
            overflow: overflow
        ),
      ),
    );
  }
}
