import 'package:offline_pos/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/create_payment_tables.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/database_conn/insert_pos.dart';
import 'package:offline_pos/database_conn/users.dart';
import 'package:offline_pos/models/single_invoice_data.dart';
import 'package:offline_pos/widgets_components/opening_entry.dart';
import '../common_utils/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';

List<List<Payments>> chunkPayments(List<Payments> list, int size) {
  return List.generate(
    (list.length / size).ceil(),
    (i) => list.skip(i * size).take(size).toList(),
  );
}

Widget closingEntryDialog(BuildContext context, model) {
  // Sort currencyDenominationList in descending order
  final sortedDenominationList = List.from(currencyDenominationList)
    ..sort((a, b) => b.denominationValue.compareTo(a.denominationValue));

  final List<TextEditingController> controllers = List.generate(
    sortedDenominationList.length,
    (_) => TextEditingController(),
  );
  TextEditingController commentBox = TextEditingController();
  final List<FocusNode> focusNodes = List.generate(
    sortedDenominationList.length,
    (_) => FocusNode(),
  );
  final List<double> rowTotals = List.filled(
    sortedDenominationList.length,
    0.0,
  );
  double grandTotal = 0.0;
  int? activeIndex;

  void updateTotals(StateSetter setState) {
    setState(() {
      for (int i = 0; i < sortedDenominationList.length; i++) {
        final count = int.tryParse(controllers[i].text) ?? 0;
        rowTotals[i] =
            (count * sortedDenominationList[i].denominationValue).toDouble();
      }
      grandTotal = rowTotals.fold(0.000, (sum, val) => sum + val);
    });
  }

  getPosOpening();

  bool isTapped = false;

  if (posOpeningList.isNotEmpty) {
    final chunks = chunkPayments(model.entries, 3);

    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 50.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          backgroundColor: AppColors.white,
          child: Container(
            padding: EdgeInsets.only(
              top: 5.w,
              bottom: 10.w,
              left: 15.w,
              right: 15.w,
            ),

            constraints: BoxConstraints(maxWidth: 300.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Center(
                    child: Text(
                      "POS Closing Entry",
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2B3691),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Main Content
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date and Time Info
                              _InfoRow(
                                label: "Start Date",
                                value: DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(
                                    posOpeningList[0].periodStartDate!,
                                  ),
                                ),
                                isHighlighted: true,
                              ),
                              SizedBox(height: 8.h),
                              _InfoRow(
                                label: "Start Time",
                                value: DateFormat('hh:mm a').format(
                                  DateTime.parse(
                                    posOpeningList[0].periodStartDate!,
                                  ),
                                ),
                                isHighlighted: true,
                              ),
                              SizedBox(height: 8.h),
                              _InfoRow(
                                label: "End Date",
                                value: DateFormat(
                                  'dd-MM-yyyy',
                                ).format(DateTime.now()),
                                isHighlighted: true,
                              ),
                              SizedBox(height: 8.h),
                              _InfoRow(
                                label: "End Time",
                                value: DateFormat(
                                  'hh:mm a',
                                ).format(DateTime.now()),
                                isHighlighted: true,
                              ),
                              SizedBox(height: 16.h),

                              // Payment Methods
                              Text(
                                "Payment Summary",
                                style: TextStyle(
                                  fontSize: 6.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF006A35),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              _InfoRow(
                                label: "Opening Cash",
                                value:
                                    "${UserPreference.getString(PrefKeys.currency)} ${(double.tryParse((posOpeningList[0].amount ?? '0').toString()) ?? 0) }",
                                isHighlighted: true,
                              ),
                              SizedBox(height: 8.h),

                              ...chunks.expand((rowItems) {
                                return rowItems.map((entry) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 8.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.modeOfPayment ?? "",
                                          style: TextStyle(
                                            fontSize: 4.5.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2B3691),
                                          ),
                                        ),
                                        Text(
                                          '${UserPreference.getString(PrefKeys.currency)} ${(entry.amount ?? 0.000).toStringAsFixed(model.decimalPoints)}',
                                          style: TextStyle(
                                            fontSize: 4.5.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF006A35),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList();
                              }).toList(),
                              _InfoRow(
                                label: "Closing Cash",
                                value:
                                    "${UserPreference.getString(PrefKeys.currency)} ${((double.tryParse((posOpeningList[0].amount ?? '0').toString()) ?? 0) + model.entries.where((item) => item.modeOfPayment != '').fold(0.0, (sum, item) => sum + (item.amount ?? 0.0))).toStringAsFixed(model.decimalPoints)}",
                                isHighlighted: true,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Table Header
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.h,
                                  horizontal: 8.w,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFF2B3691).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "Denomination",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2B3691),
                                          fontSize: 5.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                      child: Text(
                                        "Count",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2B3691),
                                          fontSize: 5.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Total",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2B3691),
                                          fontSize: 5.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 8.h),

                              // Denomination rows (now in descending order)
                              ...List.generate(sortedDenominationList.length, (
                                i,
                              ) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 6.h,
                                  ), // space between rows
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 8.w),

                                        // Denomination
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            sortedDenominationList[i]
                                                        .denominationValue >=
                                                    1
                                                ? '${UserPreference.getString(PrefKeys.currency)} ${sortedDenominationList[i].denominationValue.toStringAsFixed(3)}'
                                                : '${UserPreference.getString(PrefKeys.currency)} ${(sortedDenominationList[i].denominationValue.toStringAsFixed(3))}',
                                            style: TextStyle(
                                              fontSize: 4.5.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF006A35),
                                            ),
                                          ),
                                        ),

                                        // Count (narrow field)
                                        SizedBox(
                                          width:
                                              20.w, // restrict width to fit 3 chars comfortably
                                          child: TextField(
                                            controller: controllers[i],
                                            focusNode: focusNodes[i],
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                3,
                                              ),
                                            ],
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 2.w,
                                                    vertical: 6.h,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                borderSide: BorderSide(
                                                  color: Colors.grey[400]!,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFF2B3691),
                                                  width: 2.0,
                                                ),
                                              ),
                                            ),
                                            onTap:
                                                () => setState(
                                                  () => activeIndex = i,
                                                ),
                                            onChanged:
                                                (_) => updateTotals(setState),
                                          ),
                                        ),

                                        // Total
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8.w),
                                            child: Text(
                                              '${UserPreference.getString(PrefKeys.currency)} ${rowTotals[i].toStringAsFixed(3)}',
                                              style: TextStyle(
                                                fontSize: 4.5.sp,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF006A35),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),

                              // Grand Total aligned
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF2B3691,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "Total Cash:",
                                        style: TextStyle(
                                          fontSize: 5.sp,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFF2B3691),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 45.w),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${UserPreference.getString(PrefKeys.currency)} ${grandTotal.toStringAsFixed(3)}',
                                        textAlign:
                                            TextAlign
                                                .left, // aligns with row totals
                                        style: TextStyle(
                                          fontSize: 5.sp,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFF2B3691),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Write comments",
                      style: TextStyle(
                        fontSize: 4.7.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF006A35),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Comment Box
                  TextField(
                    maxLength: 80,
                    controller: commentBox,
                    decoration: InputDecoration(
                      counterText: "", // hides character counter
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(color: Colors.green[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: Color(0xFF2B3691),
                          width: 1.5,
                        ),
                      ),

                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                    ),
                    style: TextStyle(fontSize: 4.5.sp),
                  ),
                  SizedBox(height: 24.h),

                  // Action Buttons
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _ActionButton(
                          text: 'Submit',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF018644), Color(0xFF033D20)],
                          ),
                          onTap: () async {
                            if (isTapped) return;
                            isTapped = true;
                            await getPosOpening();
                            if (posOpeningList.isNotEmpty) {
                              int timestamp =
                                  DateTime.now().millisecondsSinceEpoch ~/ 1000;
                              final closingDate = DateTime.now().toString();
                              final insertEntry = await insertTablePosClosing(
                                'CV-${UserPreference.getString(PrefKeys.branchID)}-$timestamp',
                                UserPreference.getString(PrefKeys.userName),
                                posOpeningList[0].postingDate,
                                closingDate,
                                closingDate,
                                posOpeningList[0].company,
                                posOpeningList[0].posProfile,
                                posOpeningList[0].name,
                                "Cash",
                                posOpeningList[0].amount ?? 0,
                                (double.tryParse(
                                          (posOpeningList[0].amount ?? '0')
                                              .toString(),
                                        ) ??
                                        0) +
                                    model.entries
                                        .where(
                                          (item) => item.modeOfPayment != '',
                                        )
                                        .fold(
                                          0.0,
                                          (sum, item) =>
                                              sum + (item.amount ?? 0.0),
                                        ),
                                "Created",
                                grandTotal,
                                commentBox.text,
                              );
                              for (
                                int i = 0;
                                i < sortedDenominationList.length;
                                i++
                              ) {
                                if (rowTotals[i] > 0) {
                                  await insertPosClosingCurrencyDenomination(
                                    posClosing:
                                        'CV-${UserPreference.getString(PrefKeys.branchID)}-$timestamp',
                                    count:
                                        int.tryParse(controllers[i].text) ?? 0,
                                    denominationValue:
                                        sortedDenominationList[i]
                                            .denominationValue,
                                    totalDenominationValue: rowTotals[i],
                                  );
                                }
                              }

                              if (insertEntry) {
                                await updatePosOpeningStatus(
                                  posOpeningList[0].name,
                                  'CV-${UserPreference.getString(PrefKeys.branchID)}-$timestamp',
                                  context,
                                  closingDate,
                                );
                                await fetchFromPosOpening();
                                await deleteAllHoldCart();
                                await UserPreference.getInstance();
                                await UserPreference.putString(
                                  PrefKeys.salesPerson,
                                  '',
                                );
                                model.notifyListeners();
                                Navigator.pop(context);
                              }
                            }
                             model.searchFocusNode.requestFocus();
                          },
                        ),
                        SizedBox(width: 16.w),
                        _ActionButton(
                          text: 'Close',
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2B3691), Color(0xFF0E144D)],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                             model.searchFocusNode.requestFocus();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  } else {
    Future.microtask(() {
      DialogUtils.showConfirm(
        context: context,
        title: "Opening POS Entry Is Required",
        message: "You need to create a POS opening entry before closing the session.",
        confirmText: "Create POS Opening",
        cancelText: "Cancel",
        onConfirm: () {
          showDialog(
            context: context,
            builder:
                (BuildContext context) => openingEntryDialog(context, model),
          );
        },
      );
    });
    return SizedBox.shrink();
  }
}

// Helper Widget for Info Rows
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlighted;

  const _InfoRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 4.5.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2B3691),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 4.5.sp,
            fontWeight: FontWeight.w600,
            color: isHighlighted ? Color(0xFF006A35) : Color(0xFF2B3691),
          ),
        ),
      ],
    );
  }
}

// Helper Widget for Action Buttons
class _ActionButton extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.text,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 8.sp,
            ),
          ),
        ),
      ),
    );
  }
}
