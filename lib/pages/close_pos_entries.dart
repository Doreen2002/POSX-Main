import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/common_widgets/single_text.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/widgets_components/checkout_left_screen_cart.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/widgets_components/print_pos_closing.dart';
import 'package:offline_pos/widgets_components/side_bar.dart';
import 'package:offline_pos/widgets_components/single_item_discount.dart';
import 'package:offline_pos/widgets_components/top_bar.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class ClosingEntryListPage extends StatefulWidget {
  const ClosingEntryListPage({super.key});

  @override
  _ClosingEntryListPageState createState() => _ClosingEntryListPageState();
}

class _ClosingEntryListPageState extends State<ClosingEntryListPage> {
  @override
  void initState() {
    super.initState();
    _loadClosingEntrys();
  }

  void _loadClosingEntrys() async {
    try {
      allPosClosingList = await fetchAllFromPosClosing();
      setState(() {});
    } catch (e) {
      logErrorToFile('Error fetching holdcart: $e');
    }
  }

  

  

  @override
  Widget build(BuildContext context) {
    final CartItemScreenController model = CartItemScreenController(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 5.h, left: 4.w, right: 4.w),
        color: const Color(0xFFFAFAFA),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopBar(model: model),
            SizedBox(height: 10.h),

            Expanded(
              child: Row(
                children: [
                  SideBar(context, model),
                  Expanded(child: checkOutLeftScreenCart(context, model)),
                  const SizedBox(width: 3),
                  Expanded(
                    child: singleItemDiscountScreen(
                      context,
                      model.selectedItemIndex,
                      model,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    flex: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF018644), Color(0xFF033D20)],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Closing Vouchers List',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Table Header
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: const [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'PosX ID',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'ERPNext ID',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Opening Date',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Opening Time',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Opening Amount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Closing Amount',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 30),

                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Sync Status',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 2,
                                  ),
                                  itemCount: allPosClosingList.length,
                                  itemBuilder: (context, index) {
                                    final closed = allPosClosingList[index];
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 20,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                closed.name.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF006A35),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                closed.erpnextID ?? '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF006A35),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                DateFormat('dd-MM-yyyy').format(
                                                  DateTime.parse(
                                                    closed.postingDate
                                                        .toString(),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 30),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                DateFormat('hh:mm a').format(
                                                  DateTime.parse(
                                                    closed.postingDate
                                                        .toString(),
                                                  ),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 35),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                '${UserPreference.getString(PrefKeys.currency)} ${(closed.openingEntryAmount ?? 0).toStringAsFixed(model.decimalPoints)}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 25),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                '${UserPreference.getString(PrefKeys.currency)} ${(closed.closingAmount ?? 0).toStringAsFixed(model.decimalPoints)}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 2),

                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                closed.syncStatus.toString(),
                                                style: TextStyle(
                                                  color: () {
                                                    switch ((closed
                                                                .syncStatus ??
                                                            'Not synced')
                                                        .toLowerCase()) {
                                                      case 'not synced':
                                                        return const Color(
                                                          0xFF2B3691,
                                                        );
                                                      case 'synced':
                                                        return const Color(
                                                          0xFF006A35,
                                                        );
                                                      default:
                                                        return Colors
                                                            .black; // or any default color you prefer
                                                    }
                                                  }(),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),

                                            IconButton(
                                              icon: const Icon(
                                                Icons.print,
                                                color: Color(0xFF2B3691),
                                              ),
                                              onPressed: () async {
                                                final closingEntry =
                                                    await fetchClosingEntryToPrint(
                                                      closed.posOpeningEntry ??
                                                          "",

                                                      closed.name ?? "",
                                                    );
                                                Printing.layoutPdf(
                                                  onLayout:
                                                      (
                                                        PdfPageFormat format,
                                                      ) async =>
                                                          await generateClsoingEntryPrint(
                                                            format,
                                                            model,
                                                            closingEntry,
                                                          ),
                                                ).then((value) async {});
                                              },
                                              tooltip: 'Print',
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  const SizedBox(width: 3),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: const SingleText(
                        text: "",
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
