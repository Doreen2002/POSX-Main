import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class CommonUtils {
  static String username="";
  static Future<bool> isConnected() async {
    var connectivityResult = await  Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }


  static Future<bool> checkConnected() async {
    var connectivityResult = await  Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  // static showToast({
  //   @required String? message,
  //   Toast toastLength = Toast.LENGTH_LONG,
  //   Color backgroundColor = AppColors.appbarGreen,
  // }) {
  //   Fluttertoast.showToast(
  //       msg: message!,
  //       backgroundColor: backgroundColor,
  //       toastLength: toastLength);
  // }
}