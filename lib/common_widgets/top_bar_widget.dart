import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:offline_pos/common_widgets/single_text.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

class TopBarWidget extends StatefulWidget {
  final Widget? warehouseName;
  const TopBarWidget({super.key, this.warehouseName});

  @override
  State<TopBarWidget> createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends State<TopBarWidget> {
  int connectionStatus = 0;

  Future<void> initConnectivity() async {
    try {
      bool hasInternet = await InternetConnection().hasInternetAccess;
      updateConnectionStatus(hasInternet);
    } on PlatformException catch (e) {
      logErrorToFile('$e');
    }
  }

  void updateConnectionStatus(bool hasInternet) {
    setState(() {
      connectionStatus = hasInternet ? 0 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InternetStatus>(
      stream: InternetConnection().onStatusChange,
      builder: (context, snapshot) {
        bool isOnline = false;

        if (snapshot.hasData) {
          isOnline = snapshot.data == InternetStatus.connected;
        }

        return Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleText(
                    text: "Point Of Sale",
                    fontSize: 6.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(width: 3.w),
                  Container(child: widget.warehouseName),
                ],
              ),
              Row(
                children: [
                  isOnline
                      ? Row(
                          children: [
                            Icon(Icons.wifi, size: 20.r),
                            SizedBox(width: 1.w),
                            SingleText(
                              text: 'Online',
                              fontWeight: FontWeight.bold,
                              fontSize: 3.sp,
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Icon(Icons.wifi_off, size: 20.r),
                            SizedBox(width: 1.w),
                            SingleText(
                              text: "Offline",
                              fontWeight: FontWeight.bold,
                              fontSize: 3.sp,
                            ),
                          ],
                        ),
                  SizedBox(width: 5.w),
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors.pink[50],
                    child: SingleText(
                      text: "BS",
                      fontWeight: FontWeight.bold,
                      fontSize: 3.sp,
                      color: Colors.pink[300],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
