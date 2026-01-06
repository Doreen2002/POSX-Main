import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/services/vfd_service.dart';
import '../controllers/item_screen_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart';


  Future<Uint8List> generateNewPrintFormatPdf(PdfPageFormat format, CartItemScreenController model, invoice_no) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final itemStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7);
    double  _printWidth =(UserPreference.getDouble(PrefKeys.printFormatWidth) ?? 0) > 0 ? (UserPreference.getDouble(PrefKeys.printFormatWidth.toString())  ?? 60).toDouble() : 60;
    pdf.addPage(

        pw.MultiPage(
        pageFormat: PdfPageFormat(_printWidth * PdfPageFormat.mm, 300 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return [
          pw.Center(
            child: pw.Container(
           
              width: _printWidth * PdfPageFormat.mm * 0.9,
              padding: pw.EdgeInsets.only(top: 3.h,bottom: 3.h,left: 2,right: 2),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(10.r)),
                color: PdfColors.white,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        // pw.Text('INVOICE',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                        // pw.SizedBox(height: 5),
                        pw.Container(child:pw.Text(UserPreference.getString(PrefKeys.companyName) ?? "",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7))),
                        
                        // Phone Number from Settings
                        if (UserPreference.getString(PrefKeys.receiptPhoneNumber)?.isNotEmpty ?? false)
                        
                          pw.Container(child:pw.Text(
                            'Tel: ${UserPreference.getString(PrefKeys.receiptPhoneNumber)}',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7),
                          )),
                        if (UserPreference.getString(PrefKeys.companyEmail)?.isNotEmpty ?? false)
                        pw.Container(child:pw.Text(
                            'Email: ${UserPreference.getString(PrefKeys.companyEmail)}',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7),
                          )),
                        pw.SizedBox(height: 5.h),
                        if (UserPreference.getString(PrefKeys.crNO)?.isNotEmpty ?? false)
                        pw.Container(child:pw.Text('CR.NO: ${UserPreference.getString(PrefKeys.crNO) ?? ""}' ,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7))),
                        if (UserPreference.getString(PrefKeys.taxID)?.isNotEmpty ?? false)
                
                        pw.Container(child:pw.Text('VAT: ${UserPreference.getString(PrefKeys.taxID) ?? ""}' ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7))),
                        if (UserPreference.getString(PrefKeys.companyAddress)?.isNotEmpty ?? false)
                        pw.Container(child:pw.Text(UserPreference.getString(PrefKeys.companyAddress) ?? "",style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7))),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 5.h,),
                  pw.Container(
                      padding: pw.EdgeInsets.only(top: 6,bottom: 6),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(bottom:pw.BorderSide(color: PdfColors.grey400)),
                        color: PdfColors.black,
                      ),
                      child: pw.Center(
                        child: pw.Text('TAX INVOICE',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7,color: PdfColors.white)),
                      )
                  ),
                  pw.SizedBox(height: 5.h),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                           pw.Expanded(child: pw.Text('Date: ${DateFormat('dd-MM-yyyy').format(now)}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7))),
                           pw.Expanded(child: pw.Text('Time: ${DateFormat('hh:mm a').format(now)}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7))),
                          ]
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                           pw.Expanded(child: pw.Text('Customer  : ${model.customerData.name}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7))),
                            pw.Expanded(child: pw.Text('Customer Name : ${model.customerListController.text}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7))),
                          ]
                      ),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(child:pw.Text('Served By: ${model.salesListController.text}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7))),
                      pw.Expanded(child:pw.Text('Reference: $invoice_no'
                          ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7))),
                          ]
                      ),
                       
                     
                      // pw.Text('Customer Mobile : ${model.getCustomerToPref()}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),

                    ],
                  ),
                  pw.SizedBox(height: 5.h),
                  pw.Container(
                      padding: pw.EdgeInsets.only(top: 8.h,bottom: 8.h,left: 3.w,right: 3.w),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(bottom:pw.BorderSide(color: PdfColors.grey400)),
                        color: PdfColors.grey200,
                      ),
                      child: pw.Column(
                          children: [
                            
                            pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                 pw.Container(
                               
                                 
                                  child: pw.Text('Item Name',textAlign: pw.TextAlign.center,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                ),
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                     pw.Expanded(
                               flex:2,
                                  child: pw.Text('Code',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                ),
                            
                                pw.Expanded(
                               flex:2,
                                  child: pw.Text('Unit',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                ),
                               
                                pw.Expanded(
                               flex:2,
                                  child: pw.Text('Qty',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                ),
                               
                                pw.Expanded(
                               flex:2,
                                  // width: 20.w,
                                  child: pw.Text('Price',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                ),
                               
                                pw.Expanded(
                               flex:2,
                                  // width: 20.w,
                                  child: pw.Text('Disc',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                ),
                               
                                pw.Expanded(
                               flex:2,
                                  // width: 20.w,
                                  child: pw.Text('Rate',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                ),
                               
                                if (UserPreference.getBool(PrefKeys.isVatEnabled) ?? false)
                                pw.Expanded(
                               flex:2,
                                  // width: 20.w,
                                  child: pw.Text('VAT ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                ),
                               
                                pw.Expanded(
                               flex:2,
                                  // width: 20.w,
                                  child: pw.Text('Value',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                ),
                                    ]
                                )
                                
                              ],
                            ),
                          ]
                      )
                  ),
                  pw.SizedBox(height: 5.h),
                  ...model.cartItems.map((item) {
                    item.vatValueAmount = item.vatValue != null || item.vatValue == 0? ((item.newRate ?? 0) * item.qty   * (item.vatValue ?? 0) / 100) : 0.0;
                    return pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      
                      child: pw.Column(
                        
                        children: [
                          pw.Container( child: pw.Text(item.itemName ?? "", textAlign: pw.TextAlign.left,style: itemStyle), alignment: pw.Alignment.centerLeft),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children:[
                            
                              pw.Expanded(flex:2, child: pw.Text(item.itemCode ?? "", style: itemStyle)),
                          pw.Expanded(flex:2, child: pw.Text(item.stockUom ?? "", style: itemStyle)),
                          pw.Expanded(flex:1, child: pw.Text(item.qty.toString(), style: itemStyle)),
                          pw.Expanded(flex:2, child: pw.Text((item.newNetRate ?? 0).toStringAsFixed(model.decimalPoints), style: itemStyle)),
                          pw.Expanded(flex:2,  child: pw.Text((item.singleItemDiscAmount ?? 0).toStringAsFixed(model.decimalPoints), style: itemStyle)),
                          pw.Expanded(flex:2, child: pw.Text(item.itemTotal.toStringAsFixed(model.decimalPoints), style: itemStyle)),
                          if (UserPreference.getBool(PrefKeys.isVatEnabled) ?? false) pw.Expanded(flex:2, child: pw.Text((item.vatValueAmount ?? 0).toStringAsFixed(model.decimalPoints), style: itemStyle)),
                          pw.Expanded(flex:2, child: pw.Text((item.totalWithVatPrev ?? 0).toStringAsFixed(model.decimalPoints), style: itemStyle)),
                          ] ),
                        
                        ],
                      ),
                    );
                  }),

                  pw.Divider(color: PdfColors.black,),
                  pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Expanded(
                            child: pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Container(
                                    child: pw.Text('T-Qty : ${model.totalQTy}',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7)),
                                  ),
                                ]
                            )
                        ),
                        pw.Expanded(
                            child: pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                         pw.Expanded(
                                          child: pw.Text('Gross Amount',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7)),
                                        ),
                                         pw.Expanded(
                                          child: pw.Text(model.grossTotal.toStringAsFixed(model.decimalPoints)
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7)),
                                        ),
                                      ]
                                  ),
                                  pw.SizedBox(height: 5.h,),
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Expanded(
                                          child: pw.Text('Discount',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                        ),
                                        pw.Expanded(
                                          child: pw.Text(
                                               model.allItemsDiscountAmount.text.isNotEmpty
                                                  ? ' ${double.parse(model.allItemsDiscountAmount.text).toStringAsFixed(model.decimalPoints)}'
                                                  : model.allItemsDiscountPercent.text.isNotEmpty ?  '${double.parse(model.allItemsDiscountAmount.text).toStringAsFixed(model.decimalPoints)}' : '0.000'
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                        ),
                                      ]
                                  ),
                                  pw.SizedBox(height: 5.h,),
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                         pw.Expanded(
                                          child: pw.Text('Amount ${(UserPreference.getBool(PrefKeys.isVatEnabled) ?? false) ? "Excl. VAT": "" } ',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7)),
                                        ),
                                         pw.Expanded(
                                          child: pw.Text(model.netTotal.toStringAsFixed(model.decimalPoints),style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7)),
                                        ),
                                      ]
                                  ),
                                  pw.SizedBox(height: 5.h,),
                                    
                                  if (UserPreference.getBool(PrefKeys.isVatEnabled) ?? false) pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Expanded(
                                          child: pw.Text('VAT Amount',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7)),
                                        ),
                                        pw.Expanded(
                                          child: pw.Text(model.vatTotal.toStringAsFixed(model.decimalPoints),style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7)),
                                        ),
                                      ]
                                  ),
                                  if (UserPreference.getBool(PrefKeys.isVatEnabled) ?? false) pw.SizedBox(height: 5.h,),
                                  pw.Divider(color: PdfColors.black,),
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                         pw.Expanded(
                                          child: pw.Text('SubTotal ${(UserPreference.getBool(PrefKeys.isVatEnabled) ?? false) ? "Inc. VAT": "" }',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                        ),
                                         pw.Expanded(
                                          child: pw.Text(model.grandTotal.toStringAsFixed(model.decimalPoints),style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                                        ),
                                      ]
                                  ),
                                ]
                            )
                        ),
                      ]
                  ),
                  pw.SizedBox(height: 5.h,),
                  pw.Container(
                      padding: pw.EdgeInsets.only(top: 8.h,bottom: 8.h),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(bottom:pw.BorderSide(color: PdfColors.grey400)),
                        color: PdfColors.black,
                      ),
                      child: pw.Center(
                        child: pw.Text('Payment Breakup',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7,color: PdfColors.white)),
                      )
                  ),
                
                  pw.Container(
                      // height: model.paymentModes.where((item)=> (double.tryParse( item.controller.text) ?? 0) > 0).toList().length  * 20.h,
                      // color: PdfColors.blue,
                      child: pw.Column(
                          children: [
                            pw.ListView.builder(
                                itemCount:model.paymentModes.where((item)=> (double.tryParse( item.controller.text) ?? 0) > 0).toList().length,
                                itemBuilder: (context,index){
                                  final payments = model.paymentModes.where((item)=> (double.tryParse( item.controller.text) ?? 0) > 0).toList();
                                  return pw.Container(
                                  
                                      height: 10.h,
                                      child: pw.Row(
                                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                          // crossAxisAlignment: pw.CrossAxisAlignment.start,
                                          children: [
                                          
                                           pw.Expanded(
                                              child: pw.Text(payments[index].name,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7)),
                                            ),
                                            
                                           pw.Expanded(
                                              child: pw.Text(
                                              (double.tryParse(payments[index].controller.text) ?? 0.0)
                                                  .toStringAsFixed(model.decimalPoints),
                                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 7),
                                            )
                                            )
                                          ]
                                      )
                                  );
                                 
                                }
                            ),
                          ]
                      ),
                     
                  ),
                
                  pw.Divider(color: PdfColors.grey400,),
                  // Total Paid Row
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          child: pw.Text('Total Paid',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            model.paidAmount.toStringAsFixed(model.decimalPoints),
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7),
                          ),
                        ),
                      ]
                  ),
                
                  pw.Divider(color: PdfColors.black,),
              
                  pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.only(top: 8.h,bottom: 8.h),
                              decoration: const pw.BoxDecoration(
                                // border: pw.Border(bottom:pw.BorderSide(color: PdfColors.grey400)),
                                color: PdfColors.black,
                              ),
                              child: pw.Center(
                                child: pw.Text('Change',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7,color: PdfColors.white)),
                              )
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.only(top: 8.h,bottom: 8.h),
                              decoration: const pw.BoxDecoration(
                                border: pw.Border(bottom:pw.BorderSide(color: PdfColors.black),
                                    top: pw.BorderSide(color: PdfColors.black)
                                ),
                                // color: PdfColors.black,
                              ),
                              child: pw.Center(
                                child: pw.Text(((model.paidAmount - model.grandTotal ) > 0 ? (model.paidAmount - model.grandTotal ) : 0).toStringAsFixed(model.decimalPoints),style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                              )
                          ),
                        ),
                      ]
                  ),
                  pw.SizedBox(height: 5.h,),
                  pw.Align(
                    alignment: pw.Alignment.topCenter,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                      if(UserPreference.getString(PrefKeys.taxID) != '')  pw.Text('VAT: ${UserPreference.getString(PrefKeys.taxID) ?? ""}' ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                        if(UserPreference.getString(PrefKeys.companyAddress) != '') pw.Text(UserPreference.getString(PrefKeys.companyAddress) ?? "",style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7)),
                        pw.Text('PLEASE REFER TO THE EXCHANGE POLICY',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                        pw.Text('PRICE INCLUDING VAT ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                        pw.Text('!!!THANK YOU!!!',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ),
          )
          ];
        },
      ),
    );
    model.cartItems.clear();
    
    // ✅ VFD: Return to welcome message after cart is cleared
    try {
      VFDService.instance.showWelcome();
    } catch (e) {
      debugPrint('[VFD] Error showing welcome after cart clear: $e');
    }
    
    model.notifyListeners();
    return pdf.save();
 
  }

 