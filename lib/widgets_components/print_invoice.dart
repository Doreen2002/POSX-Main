import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import '../controllers/item_screen_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


  Future<Uint8List> generateSalesInvoicePrint(PdfPageFormat format, CartItemScreenController model,  salesInvoice) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final itemStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 4);

    pdf.addPage(

        pw.MultiPage(
        pageFormat: PdfPageFormat(48 * PdfPageFormat.mm, 300 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return [
          pw.Center(
            child: pw.Container(
            
              padding: pw.EdgeInsets.only(top: 1.h,bottom: 1.h,left: 2,right: 2),
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
                       
                       if((UserPreference.getString(PrefKeys.companyName) ?? "").isNotEmpty) pw.Text(UserPreference.getString(PrefKeys.companyName) ?? "",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                      
                        pw.SizedBox(height: 10),
                        if((UserPreference.getString(PrefKeys.crNO) ?? "").isNotEmpty) pw.Text('CR.NO: ${UserPreference.getString(PrefKeys.crNO) ?? ""}' ,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 4)),
                        if((UserPreference.getString(PrefKeys.taxID) ?? "").isNotEmpty) pw.Text('VAT: ${UserPreference.getString(PrefKeys.taxID) ?? ""}' ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                         if((UserPreference.getString(PrefKeys.companyAddress) ?? "").isNotEmpty)pw.Text(UserPreference.getString(PrefKeys.companyAddress) ?? "",style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 4)),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 5.h,),
                  pw.Container(
                      padding: pw.EdgeInsets.only(top: 3.h,bottom: 3.h),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(bottom:pw.BorderSide(color: PdfColors.grey400)),
                        color: PdfColors.black,
                      ),
                      child: pw.Center(
                        child: pw.Text('Tax Invoice',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4,color: PdfColors.white)),
                      )
                  ),
                  pw.SizedBox(height: 5.h,),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text( 'Date: ${DateFormat('dd-MM-yyyy').format(DateTime.tryParse(salesInvoice['postingDate'] ?? '') ?? DateTime.now())}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                            pw.Text('Time: ${DateFormat('hh:mm a').format(DateTime.tryParse(salesInvoice['postingDate'] ?? '') ?? DateTime.now())}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                          ]
                      ),
                      pw.SizedBox(height: 3,),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Customer : ${salesInvoice['customer']}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                            pw.Text('Customer Name: ${salesInvoice['customerName']}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4))
                          ]
                      ),
                      pw.SizedBox(height: 3,),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Served By: ${salesInvoice['served_by']}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                      pw.Text('Reference: ${salesInvoice['invoice_no']}'
                          ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                          ]
                      ),
                       
                      
          

                    ],
                  ),
                  pw.SizedBox(height: 5.h,),
                  pw.Container(
                      padding: pw.EdgeInsets.only(top: 8.h,bottom: 8.h),
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
                                  width: 10.w,
                        
                                  child: pw.Text('Item Name',textAlign: pw.TextAlign.center,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                ),
                                pw.Row(
                                    children: [
                                      pw.Container(
                                        width: 4.w,
                                  child: pw.Text('Code',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                ),
                                pw.SizedBox(width: 5,),
                                pw.Container(
                                   width: 4.w,
                                  child: pw.Text('Unit',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                ),
                                pw.SizedBox(width: 5),
                                pw.Container(
                                   width: 4.w,
                                  child: pw.Text('Qty',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                ),
                                pw.SizedBox(width: 5),
                                pw.Container(
                          
                                   width: 4.w,
                                  child: pw.Text('Price',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                ),
                                pw.SizedBox(width: 5),
                                pw.Container(
                          
                                   width: 4.w,
                                  child: pw.Text('Disc',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                ),
                                pw.SizedBox(width: 5),
                                pw.Container(
                          
                                   width: 4.w,
                                  child: pw.Text('Rate',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                ),
                                pw.SizedBox(width: 5),
                                pw.Container(
                          
                                 width: 4.w,
                                  child: pw.Text('VAT',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                ),
                                pw.SizedBox(width: 5),
                                pw.Container(
                          
                                   width: 4.w,
                                  child: pw.Text('Value',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                ),
                                    ]
                                )
                                
                              ],
                            ),
                          ]
                      )
                  ),
                  pw.SizedBox(height: 5.h),
                  ...salesInvoice['items'].map((item) {
                    double rate = double.tryParse(item['price_list_rate'].toString()) ?? 0.0;
                      double taxRate = double.tryParse(item['item_tax_rate'].toString()) ?? 0.0;

                      double taxAmount = rate * taxRate / 100;
                    return pw.Container(
                      padding: const pw.EdgeInsets.symmetric(vertical: 2),
                      child: pw.Column(
                        children: [
                          pw.Container(
                            child: pw.Text(item['item_name'] ?? "", textAlign: pw.TextAlign.left, style: itemStyle),
                            alignment: pw.Alignment.centerLeft,
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Container( child: pw.Text(item['item_code'] ?? "", style: itemStyle)),
                              pw.Container( child: pw.Text(item['stock_uom'] ?? "", style: itemStyle)),
                              pw.Container( child: pw.Text((item['qty'] ?? 0).toString(), style: itemStyle)),
                              pw.Container( child: pw.Text((item['rate'] ?? 0).toStringAsFixed(model.decimalPoints), style: itemStyle)),
                              pw.Container( child: pw.Text((item['discount_amount'] ?? 0).toStringAsFixed(model.decimalPoints), style: itemStyle)),
                              pw.Container( child: pw.Text((item['price_list_rate']).toStringAsFixed(model.decimalPoints), style: itemStyle)),
                              pw.Container( child: pw.Text((taxAmount).toStringAsFixed(model.decimalPoints), style: itemStyle)),
                              pw.Container( child: pw.Text((item['net_amount'] ?? 0).toStringAsFixed(model.decimalPoints), style: itemStyle)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),

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
                                    child: pw.Text('T-Qty : ${salesInvoice['totalQty']}',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 4)),
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
                                        pw.Container(
                                          child: pw.Text('Gross Amount',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 4)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(salesInvoice['grossTotal'].toStringAsFixed(model.decimalPoints)
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 4)),
                                        ),
                                      ]
                                  ),
                                  pw.SizedBox(height: 10.h,),
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Container(
                                          child: pw.Text('Discount',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(
                                               salesInvoice['discountAmount'].toStringAsFixed(model.decimalPoints)
                                               
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                        ),
                                      ]
                                  ),
                                  pw.SizedBox(height: 5.h,),
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Container(
                                          child: pw.Text('Amount  ${(UserPreference.getBool(PrefKeys.isVatEnabled) ?? false) ? "Excl.VAT": "" } ',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 4)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(salesInvoice['netTotal'].toStringAsFixed(model.decimalPoints),style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 4)),
                                        ),
                                      ]
                                  ),
                                  pw.SizedBox(height: 5.h,),
                                  if(UserPreference.getBool(PrefKeys.isVatEnabled) ?? false)
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                       if(UserPreference.getBool(PrefKeys.isVatEnabled) ?? false) pw.Container(
                                          child: pw.Text('VAT Amount',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 4)),
                                        ),
                                       if(UserPreference.getBool(PrefKeys.isVatEnabled) ?? false) pw.Container(
                                          child: pw.Text(salesInvoice['vatTotal'].toStringAsFixed(model.decimalPoints),style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 4)),
                                        ),
                                      ]
                                  ),
                                  pw.SizedBox(height: 3.h,),
                                  pw.Divider(color: PdfColors.black,),
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Container(
                                          child: pw.Text('SubTotal  ${(UserPreference.getBool(PrefKeys.isVatEnabled) ?? false) ? "Inc. VAT": "" } ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(salesInvoice['grandTotal'].toStringAsFixed(model.decimalPoints),style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
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
                        child: pw.Text('Payment Breakup',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4,color: PdfColors.white)),
                      )
                  ),
                  pw.SizedBox(height: 5.h,),
                  pw.Container(
                      height: salesInvoice['paymentModes'].length  * 20.h,
                    
                      child: pw.Column(
                          children: [
                            pw.ListView.builder(
                                itemCount:salesInvoice['paymentModes'].length,
                                itemBuilder: (context,index){
                                  final payments = salesInvoice['paymentModes'];
                                  return pw.Container(
                                  
                                      height: 20.h,
                                      child: pw.Row(
                                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                          
                                          children: [
                                          
                                            pw.Container(
                                              child: pw.Text(payments[index]['mode_of_payment'],style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 4)),
                                            ),
                                           
                                            pw.Container(
                                              child: pw.Text(
                                              payments[index]['amount']  
                                                  .toStringAsFixed(model.decimalPoints),
                                              style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 4),
                                            )
                                            )
                                          ]
                                      )
                                  );
                                }
                            ),
                          ]
                      )
                  ),
                  pw.SizedBox(height: 5.h,),
                  pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Container(
                              padding: pw.EdgeInsets.only(top: 8.h,bottom: 8.h),
                              decoration: const pw.BoxDecoration(
                                
                                color: PdfColors.black,
                              ),
                              child: pw.Center(
                                child: pw.Text('Change',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4,color: PdfColors.white)),
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
                                child: pw.Text(salesInvoice['change_amount'].toStringAsFixed(model.decimalPoints),style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
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
                       if(UserPreference.getString(PrefKeys.companyName)!= '') pw.Text('${UserPreference.getString(PrefKeys.companyName) ?? ""}' ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
                        if(UserPreference.getString(PrefKeys.companyAddress) != '') pw.Text(UserPreference.getString(PrefKeys.companyAddress) ?? "",style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 7)),
                        pw.Text('PLEASE REFER TO THE EXCHANGE POLICY',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                        pw.Text('PRICE INCLUDING VAT ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4)),
                        pw.Text('!!!THANK YOU!!!',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 4.sp)),
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
    return pdf.save();
  }

 