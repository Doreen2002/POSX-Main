import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/common_widgets/single_text.dart';

class CustomDrawerBox extends StatelessWidget {
  final Function()? routeCustomer;
  // final Function()? routeHistoryTransaction;
  // final Function()? routeReportScreen;
  // final Function()? routeManageStore;
  // final Function()? routeAccountScreen;
  // final Function()? routePlaceOrderScreen;
  const CustomDrawerBox({super.key,
    // this.routeHistoryTransaction,
    this.routeCustomer,
    // this.routeReportScreen,
    // this.routeManageStore,
    // this.routeAccountScreen,
    // this.routePlaceOrderScreen
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20.h,
        left: 3.w,
        right: 3.w,
      ),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleText(
                text:'POS',fontSize: 6.sp,
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          GestureDetector(
            onTap: routeCustomer,
            child: Container(
              child: Row(
                children: [
                  Icon(Icons.person_add_alt_sharp,size: 30.r,),
                  SizedBox(width: 3.w,),
                  SingleText(text: 'Customer',fontSize: 3.sp,)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          Container(
            child: Row(
              children: [
                Icon(Icons.person_add_alt_sharp,size: 30.r,),
                SizedBox(width: 3.w,),
                SingleText(text: 'Customer',fontSize: 3.sp,)
              ],
            ),
          )

        ],
      ),
    );
  }
}