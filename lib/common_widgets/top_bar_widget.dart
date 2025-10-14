import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/common_widgets/single_text.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

class TopBarWidget extends StatefulWidget {
  final Widget? warehouseName;
  const TopBarWidget({super.key, this.warehouseName});

  @override
  State<TopBarWidget> createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends State<TopBarWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final Connectivity connectivity = Connectivity();
  List<ConnectivityResult> result = [];
  var connectionStatus = 0;

  Future<void>initConnectivity() async {
    try{
      result = await connectivity.checkConnectivity();
      setState(() {

      });
      
    }on PlatformException catch(e){
      logErrorToFile('$e');
    }
    // notifyListeners();
    return updateConnectionStatus(result);
  }

  @override
  void updateConnectionStatus(List<ConnectivityResult> result){
    switch(result){
      case [ConnectivityResult.none]:
        connectionStatus = 0;
        setState(() {

        });
       
        break;

      default:
        connectionStatus = 1;
        setState(() {

        });
        break;
    }
    // notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
        stream: connectivity.onConnectivityChanged,
        builder: (_,snapshot) {
          return Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SingleText(text: "Point Of Sale",fontSize: 6.sp,fontWeight: FontWeight.bold,),
                    SizedBox(width: 3.w,),
                    Container(child: widget.warehouseName),
                  ],
                ),
                Row(
                  children: [
                    InternetConnectivityWidget(
                      snapshot: snapshot,
                      widget: Row(
                        children: [
                          Icon(Icons.wifi,size: 20.r,),
                          SizedBox(width: 1.w,),
                          SingleText(text: 'Online',fontWeight: FontWeight.bold,fontSize: 3.sp,),
                        ],
                      ),
                    ),
                    SizedBox(width: 5.w,),
                    CircleAvatar(
                      radius: 25.r,
                      backgroundColor: Colors.pink[50],
                      child: SingleText(text: "BS",fontWeight: FontWeight.bold,fontSize: 3.sp,color: Colors.pink[300],),
                    ),
                  ],
                )
              ],
            ),
          );
        }
    );
  }
}


class InternetConnectivityWidget extends StatelessWidget {
  final AsyncSnapshot<List<ConnectivityResult>> snapshot;
  final Widget widget;
  const InternetConnectivityWidget({super.key, required this.snapshot, required this.widget});

  @override
  Widget build(BuildContext context) {
    switch(snapshot.connectionState){
      case ConnectionState.active:
        final state = snapshot.data!;

        switch(state){
          case [ConnectivityResult.none]:
           
            return Row(
              children: [
                Icon(Icons.wifi_off,size: 20.r),
                SizedBox(width: 1.w,),
                SingleText(text: "offline_pos",fontWeight: FontWeight.bold,fontSize: 3.sp,),
              ],
            );
          default:
            
            return widget;
        }
      default:
      
        return const Text("Check Connection");
    }

  }
}