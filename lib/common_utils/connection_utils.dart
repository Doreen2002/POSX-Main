
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CommonUtils {
  static String username="";
  static Future<bool> isConnected() async {
    bool connectivityResult = await  InternetConnection().hasInternetAccess;
    if (!connectivityResult) {
      return false;
    } else {
      return true;
    }
  }


  static Future<bool> checkConnected() async {
    bool connectivityResult = await  InternetConnection().hasInternetAccess;
    if (!connectivityResult) {
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