import 'package:offline_pos/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:offline_pos/common_widgets/single_text.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/database_conn/get_item_queries.dart' as batchData;
import 'package:offline_pos/database_conn/holdcart.dart';
import 'package:offline_pos/database_conn/sales.dart';
import 'package:offline_pos/models/batch_list_model.dart';
import 'package:offline_pos/models/hold_cart.dart';
import 'package:offline_pos/models/item.dart';
import 'package:offline_pos/models/item_model.dart';
import 'package:offline_pos/pages/items_cart.dart';
import 'package:offline_pos/widgets_components/checkout_left_screen_cart.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/widgets_components/price_check.dart';
import 'package:offline_pos/widgets_components/side_bar.dart';
import 'package:offline_pos/widgets_components/single_item_discount.dart';
import 'package:offline_pos/widgets_components/top_bar.dart';

class HoldCartListPage extends StatefulWidget {
  const HoldCartListPage({super.key});

  @override
  _HoldCartListPageState createState() => _HoldCartListPageState();
}

class _HoldCartListPageState extends State<HoldCartListPage> {
  @override
  void initState() {
    super.initState();
    _loadHoldCarts();
  }

  void _loadHoldCarts() async {
    try {
      holdcartList = await fetchFromHoldCart();
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
                    flex: 30,
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
                            color: const Color(0xFF006A35),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Hold Cart  List',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        'ID',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const Expanded(
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
                                    const Expanded(
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
                                    const Expanded(
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
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        'QTY',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Total Amount',
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
                                    vertical: 8,
                                  ),
                                  itemCount: holdcartList.length,
                                  itemBuilder: (context, index) {
                                    final holdcart = holdcartList[index];
                                    DateTime date = DateTime.parse(
                                      holdcart.date,
                                    );
                                    String formattedDate = DateFormat(
                                      'dd-MM-yyyy',
                                    ).format(date);
                                    String formattedTime = DateFormat(
                                      'hh:mm a',
                                    ).format(date);
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: InkWell(
                                        onTap: () async {
                                          try {
                                            await fetchFromHoldCartItem();
                                            await fetchFromHoldCart();
                                            final holdCartSelected =
                                                holdcartList
                                                    .where(
                                                      (item) =>
                                                          item.name ==
                                                          holdcart.name,
                                                    )
                                                    .toList();
                                            final discountAmount =
                                                holdCartSelected[0]
                                                    .discountAmount ??
                                                0.0;
                                            final discountPercent =
                                                holdCartSelected[0]
                                                    .discountPercent ??
                                                0.0;
                                            final holdcartName = holdcart.name;
                                            final holdCartItemSelected =
                                                holdcartItemList
                                                    .where(
                                                      (item) =>
                                                          item.parentId ==
                                                          holdcart.name,
                                                    )
                                                    .toList();

                                            for (var item
                                                in holdCartItemSelected) {
                                              String itemCode =
                                                  item.itemCode ?? '';
                                              String itemName =
                                                  item.itemName ?? '';
                                              String itemGroup =
                                                  item.itemGroup ?? '';
                                              String stockUom =
                                                  item.stockUom ?? '';
                                              int vatValue = item.vat ?? 0;
                                              int qty = item.qty?.toInt() ?? 0;
                                              double itemTotal =
                                                  (item.rate?.toDouble() ??
                                                      0.0);
                                              double newRate =
                                                  (item.rate?.toDouble() ??
                                                      0.0) -
                                                        (item.discountAmount ??
                                                            0);
                                              double totalWithVatPrev =
                                                  (newRate * qty) +
                                                  ((newRate *
                                                      vatValue /
                                                      100)*qty);
                                              
                                                final matchItem = await itemListdata
                                                    .firstWhere(
                                                      (mitem) =>
                                                          mitem.name ==
                                                          item.itemCode,
                                                      orElse: () => TempItem(itemCode:'', name:'' ),
                                                      
                                                    );
                                                  final matchbatch =  batchData.batchListdata
                                                    .firstWhere(
                                                      (mitem) =>
                                                          mitem.batchId ==
                                                          item.batchNo,
                                                          orElse: () => BatchListModel(batchId: '',  batchQty: 0, expiryDate: ''),
                                                      
                                                    );
                                                if (((item.qty ?? 0) >
                                                    matchItem.openingStock && matchItem.hasBatchNo == 0) || ((item.qty ?? 0) >
                                                    (matchbatch.batchQty ?? 0 )&& matchItem.hasBatchNo == 1)) {
                                                  DialogUtils.showError(
                                                    context: context!,
                                                    title: 'Insufficient Stock',
                                                    message:
                                                        'You cannot set quantity greater than available stock.\nAvailable stock: ${item.openingStock}',
                                                  );
                                                  continue; // Skip this item and continue with next
                                                }
                                                await model.addItemsToCart(
                                                  from_hold: true,
                                                  Item(
                                                    name: itemCode,
                                                    itemCode: itemCode,
                                                    itemName: itemName,
                                                    itemGroup: itemGroup,
                                                    stockUom: stockUom,
                                                    hasBatchNo:( (item.batchNo ?? "").isNotEmpty) ? 1 : 0,
                                                    batchQty: matchItem.batchQty,
                                                    batchNumberSeries: item.batchNo,
                                                    image: '',
                                                    qty: qty,
                                                    itemTotal:newRate * qty,
                                                    newRate:
                                                        newRate ,
                                                    newNetRate: (item.rate?.toDouble() ??
                                                      0.0) ,
                                                    vatValue: item.vat,
                                                    totalWithVatPrev:
                                                        totalWithVatPrev,
                                                    singleItemDiscAmount:
                                                        item.discountAmount,
                                                    singleItemDiscPer:
                                                        item.discountPercent,
                                                  ),
                                                );
                                              }
                                            
                                            await deleteFromHoldCartItem(
                                              holdcartName,
                                            );
                                           
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                settings: const RouteSettings(
                                                  name: 'CartItemScreen',
                                                ),
                                                builder:
                                                    (context) => CartItemScreen(
                                                      runInit: false,
                                                      cartItems:
                                                          model.cartItems,
                                                      customer:
                                                          holdcart.customer,
                                                      discountAmount:
                                                          discountAmount
                                                              .toStringAsFixed(
                                                                model
                                                                    .decimalPoints,
                                                              ),
                                                      discountPercent:
                                                          discountPercent
                                                              .toString(),
                                                    ),
                                              ),
                                            );
                                          } catch (e) {
                                            print('Error retrieving items: $e');
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 20,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  (index + 1).toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF006A35),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  holdcart.customer,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  formattedDate,
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  formattedTime,
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  holdcart.totalQty.toString(),
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  ' ${UserPreference.getString(PrefKeys.currency)} ${holdcart.totalAmount.toStringAsFixed(model.decimalPoints)} ',
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Color(0xFF2B3691),
                                                ),
                                                onPressed: () async {
                                                  await deleteFromHoldCartItem(
                                                    holdcart.name,
                                                  );
                                                  _loadHoldCarts();
                                                },
                                                tooltip: 'Delete ',
                                              ),
                                            ],
                                          ),
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
