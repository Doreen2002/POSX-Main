import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../widgets_components/auto_persist.dart';
import '../data_source/local/user_preference.dart';
import '../data_source/local/pref_keys.dart';

class CashDrawerSection extends StatefulWidget {
  const CashDrawerSection({Key? key}) : super(key: key);
  @override
  State<CashDrawerSection> createState() => CashDrawerSectionState();
}

class CashDrawerSectionState extends State<CashDrawerSection> {
  bool _enabled = false;

  @override
  void initState() {
    super.initState();
    UserPreference.getInstance().then((_) => setState(() => _enabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? false));
  }

  void _test() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open cash drawer')));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cash Drawer', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 8.h),
          SwitchListTile(value: _enabled, onChanged: (v) async { setState(() => _enabled = v); await UserPreference.getInstance(); await UserPreference.putBool(PrefKeys.openCashDrawer, v); }, title: const Text('Open cash drawer on sale')),
          if (_enabled) SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _test, child: const Text('Test Cash Drawer'))),
        ]),
      ),
    );
  }
}