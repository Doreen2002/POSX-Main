import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/models/item.dart';
import 'package:offline_pos/pages/items_cart.dart';
import 'package:printing/printing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:offline_pos/common_widgets/single_text.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/sales.dart';
import 'package:offline_pos/models/sales_invoice_model.dart';
import 'package:offline_pos/widgets_components/checkout_left_screen_cart.dart';
import 'package:offline_pos/widgets_components/print_invoice.dart';
import 'package:offline_pos/widgets_components/side_bar.dart';
import 'package:offline_pos/widgets_components/single_item_discount.dart';
import 'package:offline_pos/widgets_components/top_bar.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';

class InvoiceListPage extends StatefulWidget {
  const InvoiceListPage({super.key});

  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  String? selectedSort;
  String? selectedFilter;
  String searchQuery = '';
  bool _isRefreshing = false;
  Timer? _refreshTimer;


late BuildContext savedContext;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  savedContext = context;
}

  @override
  void initState() {
    super.initState();
    _loadInvoices();
    _startAutoRefresh();
  }

  @override
  void dispose() {
       if (mounted) {
    _refreshTimer?.cancel();
       }
    super.dispose();
  }

  void _startAutoRefresh() {
    // Refresh every 10 seconds
    _refreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        _loadInvoices();
      }
    });
  }

  Future<void> _loadInvoices() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      await fetchFromSalesInvoice();
      await fetchFromSalesInvoiceItem();
      setState(() {
        salesInvoiceData =
            salesInvoiceData
                .where((invoice) => invoice.invoiceStatus != "Cancelled")
                .toList();
        
      });
    } catch (e) {
 
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _deleteInvoice(int index) async {
    await fetchFromSalesInvoice();
    if (salesInvoiceData[index].status == "Created") {
      await updateCancelledInvoice(salesInvoiceData[index].name, "Cancelled");
      await _loadInvoices(); // Refresh after delete
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF2B3691),
          content: Text(
            'Invoices that are synced or currently syncing cannot be cancelled.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }
  }

  void _printInvoice(TempSalesInvoiceModel invoice) {

  }

  @override
  Widget build(BuildContext context) {
    final CartItemScreenController model = CartItemScreenController(context);

    // Filter and sort logic before the widget tree
    List<TempSalesInvoiceModel> filteredList = List.from(salesInvoiceData);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final invoiceNames = salesInvoiceItemModelList
    .where((invoiceitem) => invoiceitem.itemCode.toLowerCase().contains(searchQuery.toLowerCase()))
    .map((invoiceitem) => invoiceitem.name.toLowerCase()) 
    .toList();
      filteredList =
          filteredList.where((invoice) {
            return (invoice.id?.toLowerCase().contains(searchQuery) ?? false) ||
            ( invoiceNames.contains(invoice.id?.toLowerCase())) ||
                (invoice.erpnextID?.toLowerCase().contains(searchQuery) ??
                    false) ||
                (invoice.customer.toLowerCase().contains(searchQuery));
                
          }).toList();
      
    }

    // Apply status filter
    if (selectedFilter != null) {
      filteredList =
          filteredList
              .where(
                (invoice) =>
                    invoice.status.toLowerCase() ==
                    selectedFilter!.toLowerCase(),
              )
              .toList();
    }

    // Apply sorting
    if (selectedSort != null) {
      switch (selectedSort) {
        case 'Date Ascending':
          filteredList.sort((a, b) => a.postingDate.compareTo(b.postingDate));
          break;
        case 'Date Descending':
          filteredList.sort((a, b) => b.postingDate.compareTo(a.postingDate));
          break;
        case 'Amount Ascending':
          filteredList.sort((a, b) => a.grandTotal.compareTo(b.grandTotal));
          break;
        case 'Amount Descending':
          filteredList.sort((a, b) => b.grandTotal.compareTo(a.grandTotal));
          break;
      }
    }

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
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Invoice List',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search ...',
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value.toLowerCase();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Refresh Button - ADDED HERE
                              _isRefreshing
                                  ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    ),
                                  )
                                  : IconButton(
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: _loadInvoices,
                                    tooltip: 'Refresh Invoices',
                                  ),
                              const SizedBox(width: 8),

                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF006A35),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                onPressed: () {
                                  showMenu(
                                    context: context,
                                    position: const RelativeRect.fromLTRB(
                                      1000,
                                      80,
                                      16,
                                      0,
                                    ),
                                    items: const [
                                      PopupMenuItem(
                                        value: 'Date Ascending',
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Date Ascending'),
                                            Icon(Icons.arrow_upward, size: 16),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Date Descending',
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Date Descending'),
                                            Icon(
                                              Icons.arrow_downward,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Amount Ascending',
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Amount Ascending'),
                                            Icon(Icons.arrow_upward, size: 16),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Amount Descending',
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Amount Descending'),
                                            Icon(
                                              Icons.arrow_downward,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() => selectedSort = value);
                                    }
                                  });
                                },
                                icon: const Icon(Icons.sort),
                                label: const Text('Sort'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF006A35),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                onPressed: () {
                                  showMenu(
                                    context: context,
                                    position: const RelativeRect.fromLTRB(
                                      1000,
                                      80,
                                      16,
                                      0,
                                    ),
                                    items: const [
                                      PopupMenuItem(
                                        value: 'Synced',
                                        child: Text('Synced'),
                                      ),
                                      PopupMenuItem(
                                        value: 'sent',
                                        child: Text('Sent'),
                                      ),
                                      PopupMenuItem(
                                        value: 'failed',
                                        child: Text('Failed'),
                                      ),
                                      PopupMenuItem(
                                        value: 'created',
                                        child: Text('Created'),
                                      ),
                                    ],
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() => selectedFilter = value);
                                    }
                                  });
                                },
                                icon: const Icon(Icons.filter_list),
                                label: const Text('Filter'),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF006A35),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedSort = null;
                                    selectedFilter = null;
                                  });
                                },
                                child: const Text("Clear Filters"),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 6,
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
                                        'POSX ID',
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
                                        'Customer',
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
                                        'Amount',
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
                                        'Date',
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
                                        'Time',
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
                                        'Status',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                    ), // Fixed width for action buttons
                                  ],
                                ),
                              ),

                              Expanded(
                                child:
                                    _isRefreshing
                                        ? const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF006A35),
                                                ),
                                          ),
                                        )
                                        : ListView.builder(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 4,
                                          ),
                                          itemCount: filteredList.length,
                                          itemBuilder: (context, index) {
                                            final invoice = filteredList[index];
                                            final isSynced =
                                                invoice.status.toLowerCase() !=
                                                'created';

                                            return Column(
                                              children: [
                                                Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          1,
                                                        ),
                                                  ),
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 2,
                                                      ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 2,
                                                          horizontal: 20,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            invoice.id ?? '',
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                    0xFF006A35,
                                                                  ),
                                                                ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Text(
                                                            invoice.erpnextID ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                    0xFF2B3691,
                                                                  ),
                                                                ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            invoice.customer,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            '${UserPreference.getString(PrefKeys.currency)} ${invoice.grandTotal.toStringAsFixed(model.decimalPoints)}',
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            DateFormat(
                                                              'dd-MM-yyyy',
                                                            ).format(
                                                              DateTime.parse(
                                                                invoice
                                                                    .postingDate,
                                                              ),
                                                            ),
                                                            style: const TextStyle(
                                                              color:
                                                                  Colors
                                                                      .black87,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            DateFormat(
                                                              'hh:mm a',
                                                            ).format(
                                                              DateTime.parse(
                                                                invoice
                                                                    .postingDate,
                                                              ),
                                                            ),
                                                            style: const TextStyle(
                                                              color:
                                                                  Colors
                                                                      .black87,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 80,
                                                          child: Text(
                                                            invoice.status,
                                                            style: TextStyle(
                                                              color: () {
                                                                switch (invoice
                                                                    .status
                                                                    .toLowerCase()) {
                                                                  case 'synced':
                                                                    return const Color(
                                                                      0xFF006A35,
                                                                    );
                                                                  case 'in progress':
                                                                    return const Color(
                                                                      0xFF2B3691,
                                                                    );
                                                                  case 'error':
                                                                    return Colors
                                                                        .red;
                                                                  case 'created':
                                                                  default:
                                                                    return Colors
                                                                        .orange;
                                                                }
                                                              }(),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              250, // Matches header width
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: const Icon(
                                                                  Icons.search,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: const Icon(
                                                                  Icons
                                                                      .download,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon: const Icon(
                                                                  Icons.print,
                                                                  color: Color(
                                                                    0xFF2B3691,
                                                                  ),
                                                                ),
                                                                onPressed: () async {
                                                                  final salesInvoice =
                                                                      await fetchSalesInvoiceToPrint(
                                                                        invoice
                                                                            .name,
                                                                      );
                                                                  Printing.layoutPdf(
                                                                    onLayout:
                                                                        (
                                                                          PdfPageFormat
                                                                          format,
                                                                        ) async => await generateSalesInvoicePrint(
                                                                          format,
                                                                          model,
                                                                          salesInvoice,
                                                                        ),
                                                                  );
                                                                },
                                                                tooltip:
                                                                    'Print Invoice',
                                                              ),
                                                              if (!isSynced)
                                                                IconButton(
                                                                  icon: const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                  onPressed:
                                                                      () => _deleteInvoice(
                                                                        index,
                                                                      ),
                                                                  tooltip:
                                                                      'Delete Invoice',
                                                                ),
                                                              if (invoice.status
                                                                      .toLowerCase() ==
                                                                  'error')
                                                                IconButton(
                                                                  icon: const Icon(
                                                                    Icons
                                                                        .replay,
                                                                    color: Color(
                                                                      0xFF2B3691,
                                                                    ),
                                                                  ),
                                                                  onPressed: () async {
                                                                    await updateErrorRetryInvoice(
                                                                      invoice
                                                                          .name,
                                                                      'Sent',
                                                                    );
                                                                    _loadInvoices();
                                                                  },
                                                                  tooltip:
                                                                      'Retry Sync',
                                                                ),
                                                                if(invoice.isReturn != "Yes")
                                                                IconButton(
                                                                  icon: const Icon(
                                                                    Icons
                                                                        .undo,
                                                                    color: Color(
                                                                      0xFF2B3691,
                                                                    ),
                                                                  ),
                                                                  onPressed: () async {
                                                                   returnInvoice ( savedContext,invoice.name, model);
                                                                    _loadInvoices();
                                                                  },
                                                                  tooltip:
                                                                      'Return Invoice',
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible:
                                                      invoice.status
                                                          .toLowerCase() ==
                                                      'error',
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          left: 24,
                                                          right: 24,
                                                          bottom: 4,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            invoice
                                                                .messageStatus,
                                                            style:
                                                                const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .red,
                                                                  fontSize: 13,
                                                                  fontStyle:
                                                                      FontStyle
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
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


Future<dynamic>  returnInvoice (BuildContext context,String invoice, model)
async{
  try{
    dynamic invoiceDetails = await fetchSalesInvoiceDetailsToReturn(invoice);
    List<Item> invoiceItemDetails = await fetchSalesInvoiceItemDetailsToReturn(invoice);
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final conn = await getDatabase();
    final invoiceNo = 'Return-INV-${UserPreference.getString(PrefKeys.branchID)}-${timestamp}';
    
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CartItemScreen(returnAgainst:invoiceDetails['name'],salesPersonID:invoiceDetails['sales_person'], customer:invoiceDetails['customer_name'], runInit: false, cartItems: invoiceItemDetails, isSalesReturn: true,)),
  );
  
  // return await insertTableSalesInvoice(
  //   id: invoiceNo ,
  //   name: invoiceNo,
  //   customer: invoiceDetails['customer'],
  //   customerName : invoiceDetails['customer_name'],
  //   posProfile: invoiceDetails['pos_profile'],
  //   company: invoiceDetails['company'],
  //   postingDate: DateTime.now().toString(),
  //   postingTime: DateTime.now().toString(),
  //   paymentDueDate: DateTime.now().toString(),
  //   netTotal: invoiceDetails['net_total'] * -1,
  //   grandTotal: invoiceDetails['grand_total'] * -1,
  //   grossTotal: invoiceDetails['gross_total'] * -1,
  //   changeAmount: invoiceDetails['change_amount'] * -1,
  //   status: invoiceDetails['status'],
  //   invoiceStatus: "Submitted",
  //   salesPerson: invoiceDetails['sales_person'], 
  //   vat: invoiceDetails['vat'] * -1,
  //   openingName: invoiceDetails['opening_name'],
  //   additionalDiscountPer: invoiceDetails['additional_discount_percentage'],
  //   discount: invoiceDetails['discount'] * -1,
  //   isReturn: "Yes",
  //   returnAgainst: invoiceDetails['name'],
  // );

  }
  catch(e){
    print("Error in returning invoice: $e");
  }

}