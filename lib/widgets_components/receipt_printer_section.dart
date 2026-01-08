



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/widgets_components/decimal_input_formatter.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';


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
        final TextEditingController  _cprController = TextEditingController();
        final TextEditingController  _printFormatWidth = TextEditingController();
        final TextEditingController  _currencyPrecision = TextEditingController();
        bool? _isVatEnabled ;
      List<String> _available = [];
      bool _scanning = false;

      @override
      void initState() {
        
        super.initState();
        double  _printWidth =(UserPreference.getDouble(PrefKeys.printFormatWidth) ?? 0) > 0 ? (UserPreference.getDouble(PrefKeys.printFormatWidth.toString())  ?? 60).toDouble() : 60;
        int _currPrecision =
            UserPreference.getInt(PrefKeys.currencyPrecision) ?? 2;


        UserPreference.getInstance().then((_) {
          
          _companyNameController.text = UserPreference.getString(PrefKeys.companyName) ?? '';
          _taxIDController.text = UserPreference.getString(PrefKeys.taxID) ?? '';
          _mobileNoNameController.text = UserPreference.getString(PrefKeys.receiptPhoneNumber) ?? '';
          _emailController.text = UserPreference.getString(PrefKeys.companyEmail) ?? '';
          _addressController.text = UserPreference.getString(PrefKeys.companyAddress) ?? '';
           _cprController.text = UserPreference.getString(PrefKeys.crNO) ?? '';
          _isVatEnabled = UserPreference.getBool(PrefKeys.isVatEnabled) ?? false;
          _printFormatWidth.text = _printWidth.toString();
          
          _currencyPrecision.text = _currPrecision.toString();
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
        _cprController.dispose();
        _printFormatWidth.dispose();
        _currencyPrecision.dispose();
       
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

        Future<void> _savePrintFormatSettings()
        async{
        
        await UserPreference.getInstance();
        await UserPreference.putString(PrefKeys.companyName, _companyNameController.text);
        await UserPreference.putString(PrefKeys.taxID, _taxIDController.text);
        await UserPreference.putString(PrefKeys.receiptPhoneNumber, _mobileNoNameController.text);
        await UserPreference.putString(PrefKeys.companyEmail, _emailController.text);
        await UserPreference.putString(PrefKeys.companyAddress, _addressController.text);
        await UserPreference.putString(PrefKeys.crNO, _cprController.text);
        await UserPreference.putBool(PrefKeys.isVatEnabled,  _isVatEnabled ?? false);
        await UserPreference.putDouble(PrefKeys.printFormatWidth,  double.parse(_printFormatWidth.text ));
        await UserPreference.putInt(PrefKeys.currencyPrecision,int.tryParse(_currencyPrecision.text ) ?? 2 );
       
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
                  width: double.infinity,child:Text("Print Format Settings  ", textAlign: TextAlign.center,  style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.w600))),
                 SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width:100,  child:const Text('Company Name', style: TextStyle(fontWeight: FontWeight.bold))),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _companyNameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) async {
                                
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
                           SizedBox(width:80,  child:const Text('TAX ID', style: TextStyle(fontWeight: FontWeight.bold))),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _taxIDController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) async {
                                  
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
                            SizedBox(width:100,  child:const Text('Mobile No', style: TextStyle(fontWeight: FontWeight.bold))),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _mobileNoNameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) async {
                                
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
                            SizedBox(width:80,  child:const Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) async {
                                  
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
                      Expanded(child: Row(children: [
                        SizedBox(width:100,  child:const Text('CPR NO', style: TextStyle(fontWeight: FontWeight.bold),)),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          controller: _cprController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        
                          onChanged: (v) async {
                           
                          },
                        ),
                      ),
                      ],)),
                      SizedBox(width: 12.w),
                      Expanded(child: Row(children: [
                      SizedBox(width:100,  child:const Text('Address', style: TextStyle(fontWeight: FontWeight.bold),)),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                          onChanged: (v) async {
                           
                          },
                        ),
                      ),
                      ],))
                      
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                 
                 SizedBox(   width: double.infinity,
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  
                  Expanded(
                      flex: 2,child: Row(children: [
                    SizedBox(width:110,  child:const Text('Is Vat Enabled', style: TextStyle(fontWeight: FontWeight.bold))),
                  Checkbox(value:_isVatEnabled ?? false, onChanged: (value){
                    setState(() {
                       _isVatEnabled = value ?? false;
                    });
                  })
                  ],)),
                  Expanded(
                    flex: 2,
                        child: Row(
                          children: [
                            SizedBox(width:180,  child:const Text('Currency Precision', style: TextStyle(fontWeight: FontWeight.bold))),
                            SizedBox(width: 2.w),
                            SizedBox(
                              width:  30.w,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _currencyPrecision,
                                inputFormatters: [
                                DecimalTextInputFormatter(decimalRange: 0),
                                LengthLimitingTextInputFormatter(5),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) async {
                                
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  Expanded(
                    flex: 2,
                        child: Row(
                          children: [
                            SizedBox(width:180,  child:const Text('Print Format Width (mm)', style: TextStyle(fontWeight: FontWeight.bold))),
                             SizedBox(width: 2.w),
                             SizedBox(
                              width:  30.w,
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _printFormatWidth,
                                inputFormatters: [
                                DecimalTextInputFormatter(decimalRange: 2),
                                LengthLimitingTextInputFormatter(5),
                                ],
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (v) async {
                                
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                     ElevatedButton.icon(onPressed: ()async{await _savePrintFormatSettings();},  label: Text( 'Save', ), style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF2B3691),
              foregroundColor: Colors.white,
              
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            ),), 
                    

                  
                ],),),
                   SizedBox(height: 40.h),
              if (_available.isNotEmpty)
                AutoPersist<String?>(prefKey: PrefKeys.receiptPrinterUrl, defaultValue: null, builder: (ctx, val, onChanged) {
                  return DropdownButton<String>(value: val, isExpanded: true, items: _available.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(), onChanged: (v) => onChanged(v));
                }),
              SizedBox(height: 12.h),
              AutoPersist<bool>(prefKey: PrefKeys.silentPrintEnabled, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Silent Print'))),
              AutoPersist<bool>(prefKey: PrefKeys.autoPrintReceipt, defaultValue: false, builder: (ctx, val, onChanged) => SwitchListTile(value: val, onChanged: (v) => onChanged(v), title: const Text('Auto-print on payment'))),
              SizedBox(height: 12.h),
              TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone for receipts'), keyboardType: TextInputType.phone, onChanged: (v) async {  }),
              SizedBox(height: 12.h),
              SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _testPrint, child: const Text('Test Print'))),
            ]),
          ),
        );
      }
    }