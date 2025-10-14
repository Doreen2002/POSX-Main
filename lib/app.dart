import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'pages/database_sign_up_login.dart';
import 'package:oktoast/oktoast.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) {
        return OverlaySupport.global(
          child: OKToast(
            child: MaterialApp(
              title: "PosX By 9T9 Information Technology",
              debugShowCheckedModeBanner: false,
              theme: ThemeData(textTheme: GoogleFonts.robotoTextTheme()),
              home: InitialScreen(),
            ),
          ),
        );
      },
      designSize: const Size(430, 932),
    );
  }
}