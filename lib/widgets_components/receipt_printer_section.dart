

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../widgets_components/auto_persist.dart';
import '../data_source/local/user_preference.dart';
import '../data_source/local/pref_keys.dart';


class ReceiptPrinterSection extends StatefulWidget {
      const ReceiptPrinterSection({Key? key}) : super(key: key);
      @override
      State<ReceiptPrinterSection> createState() => _ReceiptPrinterSectionState();
    }

    class _ReceiptPrinterSectionState extends State<ReceiptPrinterSection> {
      final TextEditingController _phoneController = TextEditingController();
      List<String> _available = [];
      bool _scanning = false;

      @override
      void initState() {
        super.initState();
        UserPreference.getInstance().then((_) {
          _phoneController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? '';
          setState(() {});
        });
      }

      @override
      void dispose() {
        _phoneController.dispose();
        super.dispose();
      }

      Future<void> _scan() async {
        setState(() => _scanning = true);
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
          _available = ['Default Printer', 'Epson TM-T20', 'Star TSP143'];
          _scanning = false;
        });
      }

      void _testPrint() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test print queued')));

      @override
      Widget build(BuildContext context) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Receipt Printer', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _scanning ? null : _scan, icon: _scanning ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.search), label: Text(_scanning ? 'Scanning...' : 'Scan for Printers'))),
              SizedBox(height: 12.h),
              if (_available.isNotEmpty)
                AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) {
                  return DropdownButton<String>(value: val, isExpanded: true, items: _available.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => onChanged(v));
                }),
              SizedBox(height: 12.h),
              AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Silent Print'))),
              AutoPersist<bool>(prefKey: PrefKeys.autoPrintReceipt, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Auto-print on payment'))),
              SizedBox(height: 12.h),
              TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone for receipts'), keyboardType: TextInputType.phone, onChanged: (v) async { await UserPreference.getInstance(); await UserPreference.putString(PrefKeys.receiptPhoneNumber, v); }),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _testPrint, child: const Text('Test Print'))),
            ]),
          ),
        );
      }
    }