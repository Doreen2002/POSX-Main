import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import '../controllers/item_screen_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


  Future<Uint8List> generateClsoingEntryPrint(PdfPageFormat format, CartItemScreenController model,  closingEntry) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final itemStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6);

    pdf.addPage(

        pw.MultiPage(
        pageFormat: PdfPageFormat((UserPreference.getDouble(PrefKeys.printFormatWidth.toString()) ?? 60).toDouble() * PdfPageFormat.mm, 300 * PdfPageFormat.mm),
        build: (pw.Context context) {
          return [
          pw.Center(
            child: pw.Container(
              
              width: 1.sw,
              padding: pw.EdgeInsets.only(top: 20.h,bottom: 20.h,left: 2,right: 2),
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
                        // pw.Text('INVOICE',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 8)),
                        // pw.SizedBox(height: 5),
                        pw.Text(UserPreference.getString(PrefKeys.companyName) ?? "",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 12)),
                      
                        
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 10,),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                    pw.Text( 'Start Date Time: ${DateFormat('dd-MM-yyyy').format(DateTime.tryParse(closingEntry['startDate'] ?? '') ?? DateTime.now())} ${DateFormat('hh:mm a').format(DateTime.tryParse(closingEntry['startDate'] ?? '') ?? DateTime.now())}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 6)),
                    pw.SizedBox(height: 3),
                    pw.Text( 'End Date Time: ${DateFormat('dd-MM-yyyy').format(DateTime.tryParse(closingEntry['endDate'] ?? '') ?? DateTime.now())} ${DateFormat('hh:mm a').format(DateTime.tryParse(closingEntry['endDate'] ?? '') ?? DateTime.now())}',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 6)),
                    pw.SizedBox(height: 3),
                    pw.Text( 'Cashier: ${closingEntry['cashier'] }',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 6)),
                    pw.SizedBox(height: 3),
                    pw.Text('Document: ${closingEntry['closingEntryName'] } ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 6)),
  
                    ],
                  ),
                  pw.SizedBox(height: 10,),
                  


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
                                  pw.Column(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Divider(color: PdfColors.black,),
                                        pw.Container(
                                          child: pw.Text('Sales Report ',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        pw.Divider(color: PdfColors.black,),
                                         
                                         pw.Container(
                                        height: closingEntry['paymentModes'].length  * 20.h,
                                        // color: PdfColors.blue,
                                        child: pw.Column(
                                            children: [
                                              pw.ListView.builder(
                                                  itemCount:closingEntry['paymentModes'].length,
                                                  itemBuilder: (context,index){
                                                    final payments = closingEntry['paymentModes'];
                                                    return pw.Container(
                                                      // color: PdfColors.pink,
                                                        height: 20.h,
                                                        child: pw.Row(
                                                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                            // crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                            children: [
                                                            
                                                              pw.Container(
                                                                child: pw.Text(payments[index]['mode_of_payment'],style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                                              ),
                                                             
                                                              pw.Container(
                                                                child: pw.Text(
                                                                payments[index]['amount']  
                                                                    .toStringAsFixed(model.decimalPoints),
                                                                style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 6),
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
                                pw.Divider(color: PdfColors.black,),
                                  pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Container(
                                          child: pw.Text('Net Sales',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(
                                               closingEntry['netTotal'].toStringAsFixed(model.decimalPoints)
                                               
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 6)),
                                        ),
                                      ]
                                  ),
                                  pw.Divider(color: PdfColors.black,),
                                   pw.Row(
                                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Container(
                                          child: pw.Text('TAX Total',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(closingEntry['vatTotal'].toStringAsFixed(model.decimalPoints),style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                      ]
                                  ),
                                   pw.Divider(color: PdfColors.black,),
                                    pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('Grand Sales ',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(closingEntry['grandTotal'].toStringAsFixed(model.decimalPoints)
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        ]
                                    ),
                                    pw.Divider(color: PdfColors.black,),
                                    pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('Cash Report ',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        
                                        ]
                                    ),
                                    pw.Divider(color: PdfColors.black,),
                                     pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('OPENING CASH',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(closingEntry['openingAmount'].toStringAsFixed(model.decimalPoints)
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        ]
                                    ),
                                    pw.Divider(color: PdfColors.black,),
                                    pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('CLOSING CASH ',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(closingEntry['closingAmount'].toStringAsFixed(model.decimalPoints)
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        ]
                                    ),
                                    pw.Divider(color: PdfColors.black,),
                                    pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('DISCOUNT',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(closingEntry['invoiceDiscount'].toStringAsFixed(model.decimalPoints)
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        ]
                                    ),
                                    pw.Divider(color: PdfColors.black,),
                                    pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('QUANTITY SOLD',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(closingEntry['totalQTy'].toStringAsFixed(model.decimalPoints)
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        ]
                                    ),
                                    pw.Divider(color: PdfColors.black,),
                                    pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('TOTAL INVOICES',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(closingEntry['totalInvoices'].toStringAsFixed(model.decimalPoints)
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        ]
                                    ),
                                    pw.Divider(color: PdfColors.black,),
                                    pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('AVG SALES/ INVOICES',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(closingEntry['averageSales'].toStringAsFixed(model.decimalPoints)
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        ]
                                    ),
                                    pw.Divider(color: PdfColors.black,),
                                    closingEntry['denominations'] != null && closingEntry['denominations'].isNotEmpty ?
                                    pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('POS CLOSING CURRENCY DENOMINATION',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        
                                        ]
                                    ) : pw.Container(),
                                    closingEntry['denominations'] != null && closingEntry['denominations'].isNotEmpty ?
                                    pw.Divider(color: PdfColors.black,) : pw.Container(),
                                    closingEntry['denominations'] != null && closingEntry['denominations'].isNotEmpty ?
                                    pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('Denomination Value',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text('Count',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text('Total',style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                        ),
                                        
                                        ]
                                    ): pw.Container(),
                                    closingEntry['denominations'] != null && closingEntry['denominations'].isNotEmpty ? pw.Divider(color: PdfColors.black,) : pw.Container(),
                                    closingEntry['denominations'] != null && closingEntry['denominations'].isNotEmpty ?
                                     pw.Container(
                                        height: closingEntry['denominations'].length  * 20.h,
                                        // color: PdfColors.blue,
                                        child: pw.Column(
                                            children: [
                                              pw.ListView.builder(
                                                  itemCount:closingEntry['denominations'].length,
                                                  itemBuilder: (context,index){
                                                    final denominations = closingEntry['denominations'];
                                                    return pw.Container(
                                                      // color: PdfColors.pink,
                                                        height: 20.h,
                                                        child: pw.Row(
                                                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                                            // crossAxisAlignment: pw.CrossAxisAlignment.start,
                                                            children: [
                                                            
                                                              pw.Container(
                                                                child: pw.Text(denominations[index]['denomination_value'].toStringAsFixed(model.decimalPoints),style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                                              ),
                                                              pw.SizedBox(width: 30.w,),
                                                              pw.Container(
                                                                child: pw.Text(denominations[index]['count'].toString(),style: pw.TextStyle(fontWeight: pw.FontWeight.normal,fontSize: 6)),
                                                              ),
                                                              pw.SizedBox(width: 30.w,),
                                                              pw.Container(
                                                                child: pw.Text(
                                                                denominations[index]['total_denomination_value']  
                                                                    .toStringAsFixed(model.decimalPoints),
                                                                style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 6),
                                                              )
                                                              )
                                                            ]
                                                        )
                                                        
                                                    );
                                                  }
                                              ),
                                            ]
                                        )) : pw.Container(),
                                        
                                      ]
                                  ),
                                   closingEntry['denominations'] != null && closingEntry['denominations'].isNotEmpty ? pw.Divider(color: PdfColors.black,) : pw.Container(),
                                    closingEntry['denominations'] != null && closingEntry['denominations'].isNotEmpty ?
                                   pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('Total ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(closingEntry['totalDenominations'].toStringAsFixed(model.decimalPoints)
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 6)),
                                        ),
                                        ]
                                   ) : pw.Container(),
                                     closingEntry['denominations'] != null && closingEntry['denominations'].isNotEmpty ? pw.Divider(color: PdfColors.black,) : pw.Container(),
                                    
                                  closingEntry['comment'] != null && closingEntry['comment'].toString().isNotEmpty ?
                                   pw.Row(
                                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Container(
                                          child: pw.Text('Comment ',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 6)),
                                        ),
                                        pw.Container(
                                          child: pw.Text(closingEntry['comment']
                                              ,style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 6)),
                                        ),
                                        ]
                                   ) : pw.Container(),
                                 
                                  

                                 
                                  
                                ]
                            )
                        ),
                      ]
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

 