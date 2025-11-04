import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../widgets_components/auto_persist.dart';
import '../data_source/local/user_preference.dart';
import '../data_source/local/pref_keys.dart';

class VFDDisplaySection extends StatelessWidget {
  const VFDDisplaySection({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('VFD Customer Display', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          Row(children: [
            const Expanded(child: Text('Enable VFD')),
            AutoPersist<bool>(prefKey: PrefKeys.vfdEnabled, defaultValue: false, builder: (ctx, val, onChanged) => Switch(value: val, onChanged: onChanged)),
          ]),
        ]),
      ),
    );
  }
}