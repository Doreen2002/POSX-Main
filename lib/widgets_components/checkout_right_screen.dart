import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/get_customer.dart';
import 'package:offline_pos/database_conn/get_payment.dart';
import 'package:offline_pos/models/type_ahead_model.dart';
import 'package:offline_pos/models/customer_list_model.dart';
import 'package:offline_pos/pages/items_cart.dart';
import 'package:offline_pos/pages/items_cart_logic.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';
import 'package:offline_pos/widgets_components/cash_drawer_logic.dart';
import 'package:offline_pos/widgets_components/generate_print.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/services/vfd_service.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:printing/printing.dart';
import '../common_utils/app_colors.dart';
import '../common_widgets/single_text.dart';

import '../common_widgets/cash_payment_textfield.dart';
import '../common_widgets/common_message_print.dart';

import '../widgets_components/decimal_input_formatter.dart';

import '../widgets_components/complete_order_dialog.dart';

import 'package:offline_pos/utils/dialog_utils.dart';

Widget checkOutRightSide(context, CartItemScreenController model) {
  return Visibility(
    visible: model.isCheckOutScreen == true,
    child: Expanded(
      flex: 1,
      child: Stack(
        children: [
          Container(
            width: 1.sw / 0.5.w,
            height: 1.sh,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              color: Colors.white,
            ),
            padding: EdgeInsets.only(
              top: 20.h,
              bottom: 10.h,
              left: 5.w,
              right: 5.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                    
                        model.isCheckOutScreen = false;
                        model.notifyListeners();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF006A35,
                        ), // Green background
                        foregroundColor: Colors.white, // White text and icon
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ), // Even larger
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 4, // Shadow for depth
                      ),
                      icon: Transform.rotate(
                        angle: 180 * (1.6 / 180), // Horizontal U-turn
                        child: Icon(Icons.u_turn_left, size: 20),
                      ),
                      label: Text("Back To Items Cart"),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                
                // Hidden text field for barcode scanning (customer QR detection)
                Opacity(
                  opacity: 0.0, // Hidden but functional
                  child: SizedBox(
                    height: 0.1, // Minimal height
                    child: TextField(
                      controller: model.paymentBarcodeController,
                      focusNode: model.paymentBarcodeFocusNode,
                      autofocus: true, // Auto-focus to capture barcode scans
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          await _handlePaymentPageBarcodeScan(context, model, value);
                          model.paymentBarcodeController.clear();
                          // Return focus to the barcode field
                          Future.delayed(Duration(milliseconds: 100), () {
                            model.paymentBarcodeFocusNode.requestFocus();
                          });
                        }
                      },
                    ),
                  ),
                ),
                
                SingleText(
                  text: "Enter Amount",
                  fontSize: 5.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 15.h),
                // Visibility(visible: model.selectedPaymentMode != '',child: SizedBox(height: 10.h,)),
                ///<----------Payment Container--------->
                Expanded(
                  child: SizedBox(
                    height: 1.sh,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                           
                              final paymentMode = model.paymentModes[index];
                              updatePayment(model, paymentMode);

                              return InkWell(
                                onTap: () {
                                  try {
                                   

                                    paymentMode.controller.text = (model
                                                        .grandTotal -
                                                    model.paidAmount >=
                                                0
                                            ? model.grandTotal -
                                                model.paidAmount
                                            : 0)
                                        .toStringAsFixed(model.decimalPoints);
                                    

                                    updatePayment(model, paymentMode);
                                    model.notifyListeners();
                                  } catch (e) {
                                    logErrorToFile("error $e");
                                  }
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.basic,
                                  child: Container(
                                    // width: 55.w,
                                    height: 40,
                                    padding: EdgeInsets.only(
                                      left: 5.w,
                                      right: 5.w,
                                      top: 1.h,
                                      bottom: 1.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      // border: Border.all(
                                      //   color: const Color(0xFF006A35),
                                      //   width: 1.5,
                                      // ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SingleText(
                                              text: paymentMode.name,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 5.sp,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 45.h,
                                                  width: 50.w,
                                                  child: CashPayPaymentTextField(
                                                    controller:
                                                        paymentMode.controller,

                                                    autoFocus: true,
                                                    focusNode:
                                                        paymentMode.focusNode,
                                                    hintText: '${model.currency}. ${0.toStringAsFixed(model.decimalPoints)}',
                                                    inputFormatters: <
                                                      TextInputFormatter
                                                    >[
                                                      DecimalTextInputFormatter(
                                                        decimalRange: 3,
                                                      ), // Allow 2 decimal places
                                                      LengthLimitingTextInputFormatter(
                                                        10,
                                                      ), // Limit to 10 characters
                                                    ],
                                                    suffixIcon: InkWell(
                                                      onTap: () {
                                                        paymentMode
                                                            .controller
                                                            .text = '';
                                                        updatePayment(
                                                          model,
                                                          paymentMode,
                                                        );
                                                        model.notifyListeners();
                                                      },
                                                      child: Container(
                                                        height: 30.h,
                                                        width: 5.w,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8.r,
                                                              ),
                                                          border: Border.all(
                                                            color: Color(
                                                              0xFF2B3691,
                                                            ),
                                                            width: 1,
                                                          ),
                                                          color: Color(
                                                            0xFF2B3691,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: SingleText(
                                                            text: 'C',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 5.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onChange: (value) {
                                                      
                                                      if (model
                                                              .paymentModes[index]
                                                              .name ==
                                                          "Loyalty Points") {
                                                        final loyaltyPointsAmount =
                                                            (model
                                                                    .customerData
                                                                    .loyaltyPointsAmount ??
                                                                0) *
                                                            (model
                                                                    .customerData
                                                                    .conversionRate ??
                                                                0);
                                                        final enteredValue =
                                                            double.tryParse(
                                                              value ?? '0',
                                                            ) ??
                                                            0.0;
                                                        if (enteredValue >
                                                            loyaltyPointsAmount) {
                                                          DialogUtils.showLoyaltyPointsError(
                                                            context: context,
                                                            message: "You cannot use more loyalty points than available.",
                                                            width: MediaQuery.of(context).size.width * 0.4,
                                                          );

                                                          return;
                                                        }
                                                      }
                                                      model.notifyListeners();
                                                      paymentCalculation(
                                                        value,
                                                        modeOfPaymentList[index],
                                                        modeOfPaymentList,
                                                      );
                                                      updatePayment(
                                                        model,
                                                        paymentMode,
                                                      );

                                                      model.notifyListeners();
                                                    },
                                                    onTap: () {},
                                                    onTapOutside: (event) {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    SizedBox(height: 15.h),
                            itemCount: model.paymentModes.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(15.r),
                  width: 1.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                    color: AppColors.cartListColor,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SingleText(
                                  text: 'Outstanding',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.sp,
                                  color: const Color(0xFFFF8800),
                                ),
                                SingleText(
                                  text: (model.grandTotal >= model.paidAmount
                                          ? (model.grandTotal -
                                              model.paidAmount)
                                          : 0.0)
                                      .toStringAsFixed(3),

                                  fontSize: 5.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      VerticalDivider(
                        color: Colors.grey,
                        thickness: 1,
                        width: 2.w,
                      ),
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SingleText(
                                  text: 'Paid',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.sp,
                                  color: const Color(0xFF009124),
                                ),
                                SingleText(
                                  text:(model.isSalesReturn ? '-':'').toString()+ model
                                      .roundToDecimals(
                                        model.paidAmount,
                                        model.decimalPoints,
                                      )
                                      .toStringAsFixed(model.decimalPoints),

                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.sp,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const VerticalDivider(color: Colors.grey),
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SingleText(
                                  text: 'Change',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.sp,
                                  color: const Color(0xFFFF3402),
                                ),
                                SingleText(
                                  // text: "${UserPreference.getString(PrefKeys.changeValue)}",
                                  text:
                                      model.paidAmount > model.grandTotal
                                          ? (model.paidAmount! -
                                                  model.grandTotal)
                                              .toStringAsFixed(3)
                                          : '0.000',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.sp,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Shortcuts(
                  shortcuts: <LogicalKeySet, Intent>{
                    LogicalKeySet(LogicalKeyboardKey.f12):
                        const ActivateIntent(),
                  },
                  child: Actions(
                    actions: <Type, Action<Intent>>{
                      // Define the action for the ActivateIntent
                      ActivateIntent: CallbackAction<ActivateIntent>(
                        onInvoke: (Intent intent) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return completeOrderDialog(context, model);
                            },
                          );

                          return null;
                        },
                      ),
                    },
                    child: Focus(
                      autofocus: true,
                      child: GestureDetector(
                        onTap: () async {},
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Row(
                            children: [
                              // Submit & Print Receipt Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    try {
                                      if (model.submitPrintClicked) {
                                        return;
                                      }

                                      await UserPreference.getInstance();
                                    if (UserPreference.getString(PrefKeys.defaultPrinterUrl) == "") {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const Dialog(
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text("Please set your default printer"),
                                      ),
                                    ),
                                  );
                                }
                                      
                                      model.submitPrintClicked = true;
                                      model.printSalesInvoice = true;
                                      model.notifyListeners();
                                      await _showDialog(context, model);
                                      model.submitPrintClicked = false;
                                      model.submitNoPrintClicked = false;
                                      model.notifyListeners();

                                    } catch (e) {
                                     logErrorToFile("Error in submit & print: $e");
                                    } finally {
                                      
                                      openCashDrawer();
                                    }

                                  },
                                  child: Container(
                                    height: 100.h,
                                    padding: EdgeInsets.all(15.r),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.r),
                                        bottomLeft: Radius.circular(8.r),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF06572E),
                                          Color(0xFF018644),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      color:
                                          model.cartItems.isNotEmpty
                                              ? const Color(0xFF006A35)
                                              : const Color(0xFF56D194),
                                    ),
                                    child: Center(
                                      child: SingleText(
                                        text: model.isSalesReturn ?'Submit & Print Return Receipt ' : 'Submit & Print Receipt ',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4.5.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Submit - No Print Receipt Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    try {
                                      if (model.submitNoPrintClicked) return;
                                      model.submitNoPrintClicked = true;
                                      model.printSalesInvoice = false;
                                      model.notifyListeners();
                                      await _showDialog(context, model);
                                     
                                    } catch (e) {
                                      logErrorToFile("Error in submit & no print: $e");
                                    } finally {
                                      model.submitPrintClicked = false;
                                      model.submitNoPrintClicked = false;
                                      model.notifyListeners();
                                      openCashDrawer();
                                    }
                                  },
                                  child: Container(
                                    height: 100.h,
                                    padding: EdgeInsets.all(15.r),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8.r),
                                        bottomRight: Radius.circular(8.r),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF2B3691),
                                          Color.fromARGB(255, 16, 22, 78),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      color:
                                          model.cartItems.isNotEmpty
                                              ? const Color(0xFF2B3691)
                                              : const Color(0xFF4F5CCA),
                                    ),
                                    child: Center(
                                      child: SingleText(
                                        text:model.isSalesReturn ? 'Submit - No Return Receipt Print': 'Submit - No Receipt Print',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4.5.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Visibility(
              visible:
                  model.paymentNotSelectionMsg != '' &&
                  model.paymentmsgTimeOut == true,
              child: CommonMessagePrint(
                msg: model.paymentNotSelectionMsg,
                onTap: () {
                  model.paymentNotSelectionMsg = '';
                  model.paymentmsgTimeOut = false;
                  model.notifyListeners();
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _showDialog(BuildContext context, model) async {
  try {
    model.notifyListeners();
    double paid = double.parse(
      model
          .roundToDecimals(model.paidAmount, model.decimalPoints)
          .toStringAsFixed(model.decimalPoints),
    );
    double total = double.parse(
      model
          .roundToDecimals(model.grandTotal, model.decimalPoints)
          .toStringAsFixed(model.decimalPoints),
    );
    if (model.customerListController.text.isEmpty) {
      DialogUtils.showWarning(
        context: context,
        title: "Customer Missing",
        message: "Please select a customer before submitting.",
        width: MediaQuery.of(context).size.width * 0.4,
      );
      return;
    }

    if (paid >= total) {
      for (var pay in model.paymentModes) {
        if (pay.name == "Loyalty Points") {
          final loyaltyPointsAmount =
              (model.customerData.loyaltyPointsAmount ?? 0) *
              (model.customerData.conversionRate ?? 0);
          final enteredValue =
              double.tryParse((pay.controller.text ?? '0') ?? '0') ?? 0.0;
          if (enteredValue > loyaltyPointsAmount) {
            DialogUtils.showLoyaltyPointsError(
              context: context,
              message: "You cannot use more loyalty points than available.",
              width: MediaQuery.of(context).size.width * 0.4,
            );

            return;
          }
        }

        if (pay.name == "Loyalty Points") {
          final enteredValue =
              double.tryParse((pay.controller.text ?? '0') ?? '0') ?? 0.0;
          if (enteredValue >= model.grandTotal) {
            DialogUtils.showWarning(
              context: context,
              title: "Invoice Cannot Be Paid with Loyalty Points Only",
              message: "Please use another payment method in addition to Loyalty Points.",
              width: MediaQuery.of(context).size.width * 0.4,
            );
            return;
          }
        }
      }

      model.isCompleteOrderTap = true;
      final invoiceno = await createInvoice(model);

      // Complete transaction and reset state IMMEDIATELY (before printing)
      model.isCompleteOrderTap = false;
      model.isCheckOutScreen = false;
      model.customerListController.clear();
      model.customerListController.text =
          UserPreference.getString(PrefKeys.walkInCustomer) ?? "";
      model.allItemsDiscountAmount.text = '';
      model.allItemsDiscountPercent.text = '';
      
      // ✅ VFD: Show thank you message with total amount
      try {
        VFDService.instance.showThankYou(
          totalSalesAmount: model.grandTotal,
          currency: model.currency,
        );
      } catch (e) {
        debugPrint('[VFD] Error showing thank you: $e');
      }
      
     

      // Navigate to home screen IMMEDIATELY
      Navigator.push(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: 'CartItemScreen'),
          builder: (context) => CartItemScreen(runInit: false),
        ),
      );

     
      if (model.printSalesInvoice) {
        
              
        await Printing.directPrintPdf(
          printer: Printer(url: UserPreference.getString(PrefKeys.defaultPrinterUrl) ?? "") ,
          name: 'Invoice_$invoiceno',
          onLayout: (PdfPageFormat format) async =>
              generateNewPrintFormatPdf(format, model, invoiceno),
        );
      }
       model.totalQTy = 0;
      model.grossTotal = 0.0;
      model.netTotal = 0.0;
      model.vatTotal = 0.0;
      model.grandTotal = 0.0;
      model.showAddDiscount = false;
      await fetchFromCustomer();
      model.notifyListeners();
      model.notifyListeners();
    } else if (paid < total) {
      model.paymentmsgTimeOut = true;
      model.notifyListeners();

      DialogUtils.showWarning(
        context: context,
        title: "Payment!",
        message: "Outstanding amount must be ZERO.",
        width: MediaQuery.of(context).size.width * 0.4,
      );
    }
  } catch (e) {
    logErrorToFile("$e");
  }
}

void updatePayment(model, paymentMode) {
  model.paidAmount = 0.0;
  model.paidAmount = model.paymentModes.fold(0.0, (sum, mode) {
    String text = mode.controller.text;
    double amount = double.tryParse(text) ?? 0.0;
    return sum + amount;
  });


}

void paymentCalculation(
  String value,
  PaymentModeTypeAheadModel currentModel,
  modeOfPaymentList,
) {
  double inputValue = double.tryParse(value) ?? 0.0;

  if (inputValue <= 0) return;

  // Step 1: Find another payment model that already has a non-zero amount and is NOT the one currently being edited
  final previousAmountModel = modeOfPaymentList.firstWhere(
    (item) =>
        item != currentModel &&
        (double.tryParse(item.controller?.text ?? '') ?? 0.0) > 0,
    orElse: () => PaymentModeTypeAheadModel(),
  );

  // Step 2: Subtract input from previous amount
  if (previousAmountModel != null) {
    double prevValue =
        double.tryParse(previousAmountModel.controller?.text ?? '') ?? 0.0;
    double newValue = prevValue - inputValue;

    // Prevent negative value
    if (newValue >= 0) {
      previousAmountModel.controller?.text = newValue.toStringAsFixed(3);
    } else {
      previousAmountModel.controller?.text = '0.000';
      // Put remaining in current field
      currentModel.controller?.text = (inputValue - prevValue).toStringAsFixed(
        3,
      );
      return;
    }
  }

  // Step 3: Set value in the current model
  currentModel.controller?.text = inputValue.toStringAsFixed(3);
}

/// Handle barcode scan on payment page (for customer QR detection)
Future<void> _handlePaymentPageBarcodeScan(
  BuildContext context,
  CartItemScreenController model,
  String scannedValue,
) async {
  try {
    logErrorToFile('Payment page barcode scanned: $scannedValue');

    // PRIORITY 1: Check if scanned value is a customer QR code
    final customerQRResult = await detectCustomerQR(scannedValue);
    
    if (customerQRResult != null) {
      // Customer QR detected - switch customer
      logErrorToFile('Customer QR detected on payment page: ${customerQRResult.customerName}');
      
      // Play beep sound
      await model.playBeepSound();
      
      // Update customer in the model
      model.customerListController.text = customerQRResult.customerName ?? '';
      model.customerData = customerQRResult;
      model.notifyListeners();
      
      // Show success dialog with auto-dismiss
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // Auto-dismiss after 1.5 seconds
          Future.delayed(Duration(milliseconds: 1500), () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          });
          
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Customer Switched',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    customerQRResult.customerName ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
      
      logErrorToFile('Customer switched to: ${customerQRResult.customerName}');
      return; // Exit early - customer QR processed
    }
    
    // If not a customer QR, log and ignore (payment page only handles customer QR)
    logErrorToFile('Not a customer QR code on payment page, ignoring: $scannedValue');
    
  } catch (e) {
    logErrorToFile('Error handling payment page barcode scan: $e');
  }
}
