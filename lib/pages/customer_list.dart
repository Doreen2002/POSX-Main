import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:offline_pos/common_widgets/single_text.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/database_conn/dbsync.dart' as customerDataList;
import 'package:offline_pos/database_conn/get_customer.dart';
import 'package:offline_pos/models/hold_cart.dart';
import 'package:offline_pos/widgets_components/checkout_left_screen_cart.dart';
import 'package:offline_pos/widgets_components/customer_creation.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/widgets_components/side_bar.dart';
import 'package:offline_pos/widgets_components/single_item_discount.dart';
import 'package:offline_pos/widgets_components/top_bar.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  @override
  void initState() {
    super.initState();
    _loadHoldCarts();
  }

  void _loadHoldCarts() async {
    try {
      customerDataList.customerDataList = await fetchFromCustomer();
      setState(() {});
    } catch (e) {
      logErrorToFile('Error fetching customer: $e');
    }
  }

  void _deleteHoldCart(int index) {
    setState(() {});
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
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Customer  List',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 700,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search ...',
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  onChanged: (value) {
                                  
                                    setState(() {
                                      customerDataList.customerDataList =
                                          customerDataList.customerDataList
                                              .where(
                                                (item) =>
                                                    (item.customerName
                                                                ?.toLowerCase() ??
                                                            '')
                                                        .contains(
                                                          value.toLowerCase(),
                                                        ) ||
                                                    (item.emailId
                                                                ?.toLowerCase() ??
                                                            '')
                                                        .contains(
                                                          value.toLowerCase(),
                                                        ) ||
                                                    (item.mobileNo
                                                                ?.toLowerCase() ??
                                                            '')
                                                        .contains(
                                                          value.toLowerCase(),
                                                        ),
                                              )
                                              .toList();
                                    });
                                    if (value.isEmpty) {
                                      _loadHoldCarts();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2B3691),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(Icons.add),
                                label: const Text('Add Customer'),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: SizedBox(
                                          width: 800, // adjust as needed
                                          height: 600,
                                          child: CustomerCreateForm(
                                            onSubmit: (data) {
                                             
                                              // Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
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
                                      flex: 1,
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
                                      flex: 2,
                                      child: Text(
                                        'Customer Name',
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
                                        'Mobile No',
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
                                        'Email',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                    ), // Reserve space for Edit button
                                  ],
                                ),
                              ),

                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  itemCount:
                                      customerDataList.customerDataList.length,
                                  itemBuilder: (context, index) {
                                    final customer =
                                        customerDataList
                                            .customerDataList[index];
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
                                              flex: 1,
                                              child: Text(
                                                customer.name.toString(),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF006A35),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                customer.customerName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                customer.mobileNo ?? "",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                customer.emailId?.toString() ??
                                                    "",
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 60, // Matches header width
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Color(0xFF2B3691),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              CustomerCreateForm(
                                                                onSubmit:
                                                                    (data) {},
                                                                customer:
                                                                    customer,
                                                                isEdit: true,
                                                              ),
                                                    ),
                                                  );
                                                },
                                                tooltip: 'Edit',
                                              ),
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
