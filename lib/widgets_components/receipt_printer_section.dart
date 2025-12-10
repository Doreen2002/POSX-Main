

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:printing/printing.dart';


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
        final TextEditingController _companyNameController = TextEditingController();
        final TextEditingController _mobileNoNameController = TextEditingController();
        final TextEditingController _taxIDController = TextEditingController();
        final TextEditingController _emailController = TextEditingController();
        final TextEditingController _addressController = TextEditingController();
      List<String> _available = [];
      bool _scanning = false;

      @override
      void initState() {
        super.initState();
        UserPreference.getInstance().then((_) {
          _phoneController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? '';
          _companyNameController.text = UserPreference.getString(PrefKeys.companyName) ?? '';
          _taxIDController.text = UserPreference.getString(PrefKeys.taxID) ?? '';
          _mobileNoNameController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? '';
          _emailController.text = UserPreference.getString(PrefKeys.activePosProfile) ?? '';
          _addressController.text = UserPreference.getString(PrefKeys.companyAddress) ?? '';
          setState(() {});
        });
      }

      @override
      void dispose() {
        _phoneController.dispose();
        _companyNameController.dispose();
        _mobileNoNameController.dispose();
        _taxIDController.dispose();
        _emailController.dispose();
        _addressController.dispose();
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

      Future<void> _setPrinter()
      async{
        Printer ? printer;
        await UserPreference.getInstance();
        printer = await Printing.pickPrinter(context: context);
        UserPreference.putString(PrefKeys.defaultPrinter, printer!.name);
        UserPreference.putString(PrefKeys.defaultPrinterUrl, printer.url);
        setState(() {
          
        });
      }

      void _testPrint() => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test print queued')));

      @override
      Widget build(BuildContext context) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Receipt Printer', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600)),
              SizedBox(height: 8.h),
             
              SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _scanning ? null : _scan, icon: _scanning ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.search, color: Color(0xFF2B3691),), label: Text(_scanning ? 'Scanning...' : 'Scan for Printers', style: TextStyle(color: Color(0xFF2B3691),),),)),
              SizedBox(height: 40.h),
                SizedBox(width: double.infinity,  child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   ElevatedButton.icon(onPressed: ()async{await _setPrinter();},  label: Text( 'Set Default Printer', ), style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2B3691),
              foregroundColor: Colors.white,
              
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            ),),
            Text("Default Printer : ${UserPreference.getString(PrefKeys.defaultPrinter)}", style: TextStyle(fontWeight:FontWeight.bold),)
                ],)),
                SizedBox(height: 80.h),
                SizedBox(
                  width: double.infinity,child:Text("Print Format Settings  ", textAlign: TextAlign.center)),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width:100,  child:const Text('Company Name')),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _companyNameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) async {
                                  await UserPreference.getInstance();
                                  await UserPreference.putString(PrefKeys.companyName, v);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Row(
                          children: [
                           SizedBox(width:80,  child:const Text('TAX ID')),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _taxIDController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) async {
                                  await UserPreference.getInstance();
                                  await UserPreference.putString(PrefKeys.taxID, v);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width:100,  child:const Text('Mobile No')),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _mobileNoNameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) async {
                                  await UserPreference.getInstance();
                                  await UserPreference.putString(PrefKeys.receiptPhoneNumber, v);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width:80,  child:const Text('Email')),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) async {
                                  await UserPreference.getInstance();
                                  await UserPreference.putString(PrefKeys.activePosProfile, v);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(width:100,  child:const Text('Address')),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                          onChanged: (v) async {
                            await UserPreference.getInstance();
                            await UserPreference.putString(PrefKeys.companyAddress, v);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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