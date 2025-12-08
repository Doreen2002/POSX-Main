import 'package:offline_pos/database_conn/get_item_queries.dart' as fetchQueries;
import 'package:offline_pos/models/item_price.dart';
import 'package:offline_pos/utils/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:offline_pos/database_conn/get_payment.dart'
    as modeOfPaymentListData;
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';
import 'package:offline_pos/database_conn/users.dart';
import 'package:offline_pos/models/customer_list_model.dart';
import 'package:offline_pos/models/sales_person.dart';
import 'package:offline_pos/pages/customer_list.dart';
import 'package:offline_pos/pages/hold_cart.dart';
import 'package:offline_pos/pages/items_cart.dart'
    show CartItemScreen;
    
import 'package:offline_pos/pages/items_cart_logic.dart' show holdCartItem;
import 'package:offline_pos/widgets_components/customer_creation.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/widgets_components/online_offfline.dart';
import 'package:offline_pos/widgets_components/price_check.dart';
import '../common_widgets/single_text.dart';

class TopBar extends StatefulWidget {
  final CartItemScreenController model;
  const TopBar({super.key, required this.model});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    super.initState();
    _focusNode = FocusNode();
    widget.model.customerListController.addListener(_onCustomerTextChanged);
    if(widget.model.salesListController.text.isEmpty)
    {

      widget.model.salesListController.text =  UserPreference.getString(PrefKeys.salesPerson) ?? "";
    }
    
    if (widget.model.salesListController.text.isNotEmpty) {
      widget.model.setSalesPerson = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.model.notifyListeners();
      });
    }
    if (customerDataList.isNotEmpty) {
      widget.model.customerListController.text =
          UserPreference.getString(PrefKeys.walkInCustomer) ?? "";
      final match = OptimizedDataManager.getCustomerByName(
        widget.model.customerListController.text
      ) ?? TempCustomerData();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          widget.model.customerData = match;
        });
      });
    } else {
      widget.model.customerListController.text = "";
      widget.model.customerData = TempCustomerData();
    }
    widget.model.customerListController.text =
        UserPreference.getString(PrefKeys.walkInCustomer) ?? "";
    widget.model.salesListController.text =
        UserPreference.getString(PrefKeys.salesPerson) ?? "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.model.notifyListeners();
    });
  }

  void _onCustomerTextChanged() {
    final text = widget.model.customerListController.text;
    final match = OptimizedDataManager.getCustomerByName(text) ?? TempCustomerData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        widget.model.customerData = match;
      });
      widget.model.notifyListeners();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.model.customerListController.removeListener(_onCustomerTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildTopBarContent(context, widget.model, setState, _focusNode);
  }
}

Widget buildTopBarContent(
  BuildContext context,
  CartItemScreenController model,
  void Function(void Function()) setState,
  FocusNode focusNode,
) {
  return RawKeyboardListener(
    focusNode: focusNode,
    autofocus: true, // Ensure it listens for keyboard events
    onKey: (event) async {
      if (event is RawKeyDownEvent) {
        final key = event.logicalKey;

        if (model.isProcessingKey) return;
        model.isProcessingKey = true;
        model.notifyListeners();
        try {
          if (key == LogicalKeyboardKey.f1) {
        
            await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: priceCheckModal(context, model, setState),
                );
              },
            );
          }
          if (key == LogicalKeyboardKey.f2) {
            if (model.cartItems.isNotEmpty &&
                model.customerListController.text.isNotEmpty) {
              holdCartItem(model);
              model.cartItems.clear();
              model.customerListController.text =
                  UserPreference.getString(PrefKeys.walkInCustomer) ?? "";
              model.allItemsDiscountAmount.text = '';
              model.allItemsDiscountPercent.text = '';
              model.totalQTy = 0;
              model.grossTotal = 0;
              model.netTotal = 0;
              model.vatTotal = 0;
              model.grandTotal = 0;
              model.showAddDiscount = false;
              model.notifyListeners();
            } else if (model.cartItems.isEmpty) {
              await DialogUtils.showError(
                context: context,
                title: "Empty Cart",
                message: "Cannot hold an empty cart.",
                width: MediaQuery.of(context).size.width * 0.4,
              );
            } else if (model.customerListController.text.isEmpty) {
              await DialogUtils.showError(
                context: context,
                title: "Customer Required",
                message: "Cannot hold unless a customer is selected.",
                width: MediaQuery.of(context).size.width * 0.4,
              );
            }
          }
          if (key == LogicalKeyboardKey.f3) {
            final shouldRefresh = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    content: const Text(
                      "You are about to clear your cart. Proceed?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Yes, Clear"),
                      ),
                    ],
                  ),
            );

            if (shouldRefresh == true) {
              model.refresh();
            }
          }
          if (key == LogicalKeyboardKey.f4) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: 'HoldCartListPage'),
                builder: (context) => HoldCartListPage(),
              ),
            );
          } else if (key == LogicalKeyboardKey.f5) {
            if (model.allItemsDiscountAmount.text.isNotEmpty ||
                model.allItemsDiscountPercent.text.isNotEmpty) {
              model.showAddDiscount = true;
            } else {
              // Toggle only if both fields are empty
              model.showAddDiscount = !model.showAddDiscount;
            }
            model.notifyListeners();
          } else if (key == LogicalKeyboardKey.f6) {
            await sync();
          } else if (key == LogicalKeyboardKey.f7) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: 'CustomerListPage'),
                builder: (context) => CustomerListPage(),
              ),
            );
          }
          if (key == LogicalKeyboardKey.f8) {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (currentRoute != 'CartItemScreen') {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: 'CartItemScreen'),
                  builder: (context) => CartItemScreen(runInit: false),
                ),
              );
            }
          }
          if (key == LogicalKeyboardKey.f9) {
            if (!model.isCheckOutScreen) {
              if (model.customerListController.text.isNotEmpty &&
                  model.cartItems.isNotEmpty) {
                model.isCheckOutScreenText = 'Edit Cart';
                model.isCheckOutScreen = true;
                model.itemDiscountVisible = false;
                model.hasFocus = '';
                model.notifyListeners();
              } else if (model.cartItems.isEmpty) {
                await DialogUtils.showError(
                  context: context,
                  title: "Empty Cart",
                  message: "Please add items to the cart before proceeding.",
                );

                return;
              }
              if (model.salesListController.text.isNotEmpty) {
                await DialogUtils.showError(
                  context: context,
                  title: "Select Sales Person",
                  message: "Please select a sales person before proceeding.",
                );

                return;
              }
              if (model.customerListController.text.isEmpty) {
                await DialogUtils.showWarning(
                  context: context,
                  title: "Customer Missing",
                  message: "Please select a customer before submitting.",
                );

                return;
              }
            } else if (model.isCheckOutScreen &&
                model.isCheckOutScreenText == 'Edit Cart') {
              model.isCheckOutScreen = false;
              model.notifyListeners();
            }
          } else if (key == LogicalKeyboardKey.f10) {
            if (model.isCheckOutScreen) {
              model.printSalesInvoice = false;
              model.notifyListeners();
            }
          } else if (key == LogicalKeyboardKey.f11) {
            if (model.isCheckOutScreen) {
              model.printSalesInvoice = false;
              model.notifyListeners();
            }
          } else if (key == LogicalKeyboardKey.f12) {
           
          }
        } catch (e, stackTrace) {
          
          logErrorToFile("Key event error: $e");
          
        } finally {
          model.isProcessingKey = false;
          model.notifyListeners();
        }
      }
    },

    /// ✅ Correct placement of the child
    child: Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Menu and Company
          Row(
            children: [
              // GestureDetector(
              //   onTap: () {},
              //   child: Container(
              //     padding: EdgeInsets.all(6.r),
              //     child: Icon(Icons.menu, size: 30.r),
              //   ),
              // ),
              // SizedBox(width: 8.w),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6.r)),
                  color: Color(0xFF006A35),
                ),
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: Row(
                  children: [
                    Icon(Icons.store, color: const Color(0xFFFFFFFF)),
                    SizedBox(width: 2.w),
                    SingleText(
                      text:
                          UserPreference.getString(PrefKeys.posProfileName) ??
                          '',
                      fontSize: 5.sp,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          // Customer and Sales Person Selection
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              child: Row(
                children: [
                  // Customer
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 40.h,
                      child: TypeAheadField(
                    
                        controller: model.customerListController,
                        builder:
                            (context, controller, focusNode) => TextField(
                              controller: controller,
                              focusNode: focusNode,
                              autofocus: false,
                              
                              
                              style: TextStyle(
                                fontSize: 5.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2B3691),
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF006A35),
                                  ),
                                ),
                                label: SingleText(
                                  text: "Customer",
                                  fontSize: 4.sp,
                                  color: Color(0xFF006A35),
                                ),
                                suffixIcon: Visibility(
                                  visible:
                                      model
                                          .customerListController
                                          .text
                                          .isNotEmpty,
                                  child: InkWell(
                                    onTap:
                                        () =>
                                            model.customerListController
                                                .clear(),
                                    child: Icon(
                                      Icons.clear,
                                      size: 25.r,
                                      color: Color(0xFF006A35),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        decorationBuilder:
                            (context, child) => Material(
                              type: MaterialType.card,
                              elevation: 4,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                              color: Color(0xFFFFFFFF),
                              child: child,
                            ),
                        itemBuilder: (context, suggestion) {
                          TempCustomerData value =
                              suggestion as TempCustomerData;
                          return ListTile(
                            title: Text(
                              value.customerName ?? '',
                              style: TextStyle(fontSize: 5.sp),
                            ),
                          );
                        },
                        onSelected: (suggestion) async{
                          
                          TempCustomerData value =
                              suggestion as TempCustomerData;
                          model.customerData = value;
                          model.customerListController.text =
                              value.customerName ?? '';
                          model.initializePaymentModes(
                            modeOfPaymentListData.modeOfPaymentList,
                          );
                          model.searchFocusNode.requestFocus();
                        if(model.cartItems.isNotEmpty)
                        {
                          List<Future> futures = model.cartItems.map((item) {
                            return setItemPrice(item, model, model.customerData.defaultPriceList);
                          }).toList();
                        await Future.wait(futures);
                        }
                          model.notifyListeners();
                        },
                        suggestionsCallback: (pattern) async {
                          
                          return customerDataList
                              .where(
                                (item) =>
                                    (item.customerName?.toLowerCase() ?? '')
                                        .contains(pattern.toLowerCase()) ||
                                    (item.emailId?.toLowerCase() ?? '')
                                        .contains(pattern.toLowerCase()) ||
                                    (item.mobileNo?.toLowerCase() ?? '')
                                        .contains(pattern.toLowerCase()),
                              )
                              .take(20)
                              .toList();
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(
                            name: 'customerCreateDialog',
                          ),
                          builder:
                              (context) => CustomerCreateForm(
                                onSubmit: (data) {
                                
                                },
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B3691),
                      padding: EdgeInsets.zero, // Remove extra space
                      minimumSize: const Size(40, 40), // Square size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          6,
                        ), // Slight rounding
                      ),
                    ),
                    child: const Icon(Icons.add, size: 20, color: Colors.white),
                  ),

                  // Loyalty Points Amount
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50.h,
                      child: Column(
                        children: [
                          SingleText(
                            text: "Loyalty Points",
                            fontSize:3.5.sp,
                            color: Color(0xFF006A35),
                            fontWeight: FontWeight.bold,
                          ),
                          SingleText(
                            text:
                                "  ${UserPreference.getString(PrefKeys.currency).toString()}  ${(model.customerData.loyaltyPointsAmount == null || model.customerData.loyaltyPointsAmount!.isNaN) ? "0.00" : model.customerData.loyaltyPointsAmount!.toStringAsFixed(model.decimalPoints)}",

                            fontSize:3.5.sp,
                            color: Color.fromARGB(255, 14, 15, 14),
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50.h,
                      child: Column(
                        children: [
                          SingleText(
                            text: "Loyalty Points",
                            fontSize: 3.5.sp,
                            color: Color(0xFF006A35),
                            fontWeight: FontWeight.bold,
                          ),
                          SingleText(
                            text:
                                (model.customerData.loyaltyPoints == null ||
                                        model.customerData.loyaltyPoints!.isNaN)
                                    ? "0"
                                    : model.customerData.loyaltyPoints!
                                        .toString(),
                            fontSize: 3.5.sp,
                            color: Color.fromARGB(255, 14, 15, 14),
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 40.h,
                      child: TypeAheadField(
                        controller: model.salesListController,
                        builder:
                            (context, controller, focusNode) => TextField(
                              controller: controller,
                              focusNode: focusNode,
                              autofocus: false,
                              style: TextStyle(
                                fontSize: 5.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2B3691),
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF006A35),
                                  ),
                                ),
                                label: SingleText(
                                  text: "Set Sales Person",
                                  fontSize: 3.5.sp,
                                  color: Color(0xFF006A35),
                                ),
                                suffixIcon: Visibility(
                                  visible:
                                      model.salesListController.text.isNotEmpty,
                                  child: InkWell(
                                    onTap:
                                        () => model.salesListController.clear(),
                                    child: Icon(
                                      Icons.clear,
                                      size: 25.r,
                                      color: Color(0xFF006A35),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        decorationBuilder:
                            (context, child) => Material(
                              type: MaterialType.card,
                              elevation: 4,
                              borderRadius: BorderRadius.all(
                                Radius.circular(6.r),
                              ),
                              color: Color(0xFFFFFFFF),
                              child: child,
                            ),
                        itemBuilder: (context, suggestion) {
                          SalesPerson value = suggestion as SalesPerson;

                          return ListTile(
                            title: Text(
                              value.fullName ?? '',
                              style: TextStyle(fontSize: 5.sp),
                            ),
                          );
                        },
                        onSelected: (suggestion) {
                          SalesPerson value = suggestion as SalesPerson;
                          model.salesListController.text = value.fullName ?? '';
                          model.salePersonID = value.name;
                          model.autoFocusSearchItem = true;
                          model.notifyListeners();
                          return model.searchFocusNode.requestFocus();
                        },
                        suggestionsCallback: (pattern) async {
                          final allSalesPeople = await fetchFromSalesPerson();

                          return allSalesPeople
                              .where(
                                (item) => item.fullName.toLowerCase().contains(
                                  pattern.toLowerCase(),
                                ),
                              )
                              .take(20)
                              .toList();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Row(
                      children: [
                        Checkbox(
                          value: model.setSalesPerson,
                          activeColor: const Color(0xFF006A35),
                          onChanged: (val) async {
                            model.setSalesPerson = val ?? false;
                            if (val == true) {
                              if (model.salesListController.text.isEmpty) {
                                await DialogUtils.showWarning(
                                  context: context,
                                  title: "Sales Person Required",
                                  message: "Please select a sales person.",
                                );
                                model.setSalesPerson = false;
                                return;
                              }
                              await UserPreference.getInstance();
                              UserPreference.putString(
                                PrefKeys.salesPerson,
                                model.salesListController.text,
                              );
                            }
                            
                            model.notifyListeners();
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
          IsOnline(),
        ],
      ),
    ),
  );
}


Future<void> setItemPrice(item,model,priceList)
async{
await fetchQueries.fetchFromItemPrice();
try{
item.newNetRate = fetchQueries.itemPriceListdata.firstWhere(
(itemprice) =>
itemprice.priceList.toLowerCase() == priceList.toLowerCase()  &&
itemprice.UOM.toLowerCase()  == item.stockUom.toLowerCase()  &&
itemprice.itemCode.toLowerCase()  == item.itemCode.toLowerCase() ,
orElse: () => ItemPrice(name: '', itemCode: '', UOM: '', priceList: priceList, priceListRate: item.newRate)
).priceListRate;

item.singleItemDiscAmount = (item.singleItemDiscPer ?? 0)/100 * (item.newNetRate ?? 0);
item.newRate =
(item.newNetRate ?? 0) -
(item.singleItemDiscAmount ?? 0);
item.itemTotal = (item.newRate * item.qty);
item.totalWithVatPrev =
item.itemTotal +
(item.itemTotal *
(item.vatValue ?? 0) /
100);
item.ItemDiscAmount =  item.singleItemDiscAmount;

await model.discountCalculation(
model.allItemsDiscountAmount.text,
model.allItemsDiscountPercent.text,
);
model.notifyListeners();
}
catch(e)
{
logErrorToFile("error $e");
}

}