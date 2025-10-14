import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

import 'base_controller.dart';

class SplashController extends ItemScreenController {
  SplashController(BuildContext buildContext) {
    context = buildContext;
  }

  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

  static double? _safeAreaWidth;
  static double? _safeAreaHeight;
  static double? _safeBlockHorizontal;
  static double? _safeBlockVertical;
  static double? _textScaleFactor;

  // DBQueries mysqdb = DBQueries();

  ///<----------Net connectivity declaration---------->
  final Connectivity connectivity = Connectivity();
  List<ConnectivityResult> result = [];
  int connectionStatus = 0;
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  void initialise() {
    _mediaQueryData = MediaQuery.of(context!);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;
  
  }

  void init(BuildContext context, BoxConstraints safeAreaBox) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData?.size.width;
    screenHeight = _mediaQueryData?.size.height;


    _safeAreaWidth = safeAreaBox.maxWidth;
    _safeAreaHeight = safeAreaBox.maxHeight;
    _safeBlockHorizontal = _safeAreaWidth! / 100;
    _safeBlockVertical = _safeAreaHeight! / 100;

    _textScaleFactor = _mediaQueryData?.textScaleFactor;
  }

}