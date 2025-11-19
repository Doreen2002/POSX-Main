import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:offline_pos/utils/dialog_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/widgets_components/number_pad.dart';
import 'package:offline_pos/widgets_components/search_by_item_name.dart';
import 'package:oktoast/oktoast.dart';
import 'package:offline_pos/api_requests/license_details.dart';
import 'package:offline_pos/api_requests/sales.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';

import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';

import 'package:offline_pos/pages/items_cart_logic.dart';
import 'package:offline_pos/pages/hold_cart.dart';

import 'package:offline_pos/widgets_components/calculator.dart';
import 'package:offline_pos/widgets_components/cart_items.dart';

import 'package:offline_pos/widgets_components/cash_drawer_logic.dart';
import 'package:offline_pos/widgets_components/checkout_left_screen_cart.dart';
import 'package:offline_pos/widgets_components/checkout_right_screen.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/widgets_components/price_check.dart';
import 'package:offline_pos/widgets_components/single_item_discount.dart';
import 'package:offline_pos/widgets_components/top_bar.dart';

import '../common_widgets/single_text.dart';
import '../common_widgets/common_search_bar.dart';
import '../widgets_components/side_bar.dart';
import 'package:stacked/stacked.dart';
import '../models/item.dart';


class CartItemScreen extends StatefulWidget {
  final bool runInit;
  final String customer;
  final String salesPersonID;
  final List<Item> cartItems;
  final String discountAmount;
  final String discountPercent;
  final bool isSalesReturn ;
  const CartItemScreen({
    Key? key,
    this.runInit = true,
    this.isSalesReturn = false,
    this.customer = '',
    this.salesPersonID = '',
    this.cartItems = const [],
    this.discountAmount = '',
    this.discountPercent = '',
  }) : super(key: key);

  @override
  State<CartItemScreen> createState() => _CartItemScreenState();
}

class _CartItemScreenState extends State<CartItemScreen> {
  final FocusNode keyboardFocusNode = FocusNode();
  final FocusNode searchFocusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
     _debounce?.cancel();
    super.initState();
    
  }

  @override
  void dispose() {
    widget.cartItems.clear();
    super.dispose();
   
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CartItemScreenController>.reactive(
      viewModelBuilder: () => CartItemScreenController(context),
      onViewModelReady: (viewModel) {
        viewModel.initialise(widget.runInit, widget.customer, widget.cartItems);
        WidgetsBinding.instance.addPostFrameCallback((_) {});
       
        if (widget.cartItems.isNotEmpty) {
          viewModel.cartItems = List<Item>.from(widget.cartItems);
          for (var cartItem in viewModel.cartItems) {
            final match = OptimizedDataManager.getItemByCode(cartItem.itemCode);
            if (match != null) {
             
              cartItem.openingStock = match.openingStock.toInt();
              cartItem.maxDiscount = match.maxDiscount;
            }
          }
          viewModel.allItemsDiscountAmount.text = widget.discountAmount;
          viewModel.allItemsDiscountPercent.text = widget.discountPercent;
          viewModel.salesListController.text = widget.salesPersonID;
          viewModel.discountCalculation(
            viewModel.allItemsDiscountAmount.text,
            viewModel.allItemsDiscountPercent.text,
          );
          widget.cartItems.clear();
        }
        viewModel.isSalesReturn = widget.isSalesReturn;
        viewModel.initialise(widget.runInit, widget.customer, widget.cartItems);
      },
      onDispose: (viewModel) => viewModel.dispose(),
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: _getBody(viewModel),
        );
      },
    );
  }

  Widget _getBody(CartItemScreenController model) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        FocusScope.of(context).unfocus();
        model.searchFocusNode.requestFocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Stack(children: <Widget>[_getBaseContainer(model)]),
    );
  }

  OverlayEntry? showOverlay(BuildContext context) {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.2,
            child: Material(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.4,
                color: Colors.transparent,
                child: const Center(
                  child: Text('Syncing', style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(overlayEntry);

    return overlayEntry;
  }

  Widget _getBaseContainer(CartItemScreenController model) {
    return Stack(
      children: [
        Container(
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

                    checkOutLeftScreenCart(context, model),
                    SizedBox(width: 3.w),
                    singleItemDiscountScreen(
                      context,
                      model.selectedItemIndex,
                      model,
                    ),
                    Visibility(
                      visible:
                          model.isCheckOutScreen == false &&
                          model.itemDiscountVisible == false,
                   
                      child: Column(
                        children: [
                          SizedBox(
                            child: Container(
                              width: 0.3.sw / 0.5.w,
                              height: 0.41.sh,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.only(
                                top: 10.h,
                                bottom: 5.h,
                                left: 2.w,
                                right: 2.w,
                              ),
                              child: Column(
                                children: [
                                
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                     
                                      Expanded(
                                        child: CommonSearchBar(
                                          controller: model.searchController,
                                          focusNode: model.searchFocusNode,
                                          autofocus: model.autoFocusSearchItem,
                                          readonly: widget.isSalesReturn,
                                          onSubmitted: (value) async {
                                            try {
                                              
                                              searchItems(model, value);
                                              await scanItems(model, context, value);
                                            
                                            
                                              
                                            
                                            } catch (e) {
                                              logErrorToFile(
                                                "search field enter error $e",
                                              );
                                            }
                                          },

                                        ),
                                      ),
                                      SizedBox(width: 2.5.w),
                                      InkWell(
                                        onTap: () async {
                                          model.searchController.clear();
                                          await reloadItems();
                                          model.searchFocusNode.requestFocus();
                                          model.notifyListeners();
                                        },
                                        child: Container(
                                          height: 50.h,
                                          width: 15.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            border: Border.all(
                                              color: Color(0xFF2B3691),
                                              width: 1,
                                            ),
                                            color: Color(0xFF2B3691),
                                          ),
                                          child: Center(
                                            child: SingleText(
                                              text: 'C',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 5.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10.h),

                                  Expanded(
                                      child: searchByItemName( context,model, setState,model.isSalesReturn),
                                     ),

                                
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: SizedBox(
                              child: Container(
                                width: 0.3.sw / 0.5.w,
                                height: 0.447.sh,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.r),
                                  ),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.only(
                                  top: 10.h,
                                  bottom: 11.h,
                                  left: 5.w,
                                  right: 5.w,
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 3.h,
                                              crossAxisSpacing: 1.w,
                                              childAspectRatio: 1.6,
                                            ),
                                        itemCount: 8,
                                        itemBuilder: (context, index) {
                                          List<String> keys = [
                                            'Price/Stock\nCheck',
                                            'Hold Cart',
                                            'Clear Cart',
                                            'Retrieve Cart',
                                            'Calculator',
                                            
                                            model.cashDrawerEnabled
                                                ? 'Cash Drawer\nEnabled'
                                                : 'Cash Drawer\nDisabled',
                                            '',
                                            '',
                                          ];
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Color(
                                                0xFF2B3691,
                                              ), // Background color
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              onTap: () async {
                                                String value = keys[index];
                                                

                                                switch (value) {
                                                  case 'Price/Stock\nCheck':
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (
                                                        BuildContext context,
                                                      ) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  16,
                                                                ),
                                                          ),
                                                          child: StatefulBuilder(
                                                            builder: (
                                                              context,
                                                              setState,
                                                            ) {
                                                              return priceCheckModal(
                                                                context,
                                                                model,
                                                                setState,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    );

                                                    break;
                                                  case 'Cash Drawer\nEnabled':
                                                    if (model.cashDrawerEnabled) {
                                                      openCashDrawer();
                                                    } else {
                                                      showToast(
                                                        'Cash drawer is disabled. Enable in ERPNext POS Profile settings.',
                                                        backgroundColor: Colors.red,
                                                      );
                                                    }
                                                    break;
                                                  
                                                  case 'Cash Drawer\nDisabled':
                                                    showToast(
                                                      'Cash drawer is disabled. Contact system administrator to enable.',
                                                      backgroundColor: Colors.orange,
                                                    );
                                                    break;
                                                 
                                                  case 'Clear Cart':
                                                    () async {
                                                      
                                                      await DialogUtils.showConfirm(
                                                        context: context,
                                                        title: 'Are you sure?',
                                                        message: '',
                                                        confirmText: 'Yes, Clear',
                                                        cancelText: 'Cancel',
                                                        onConfirm: () async{
                                                         model.cartItems.clear();
                                                         model.refresh();
                                                        Navigator.pop(context);
                                                        },
                                                        onCancel: (){
                                                          Navigator.pop(context);
                                                        }
                                                        
                                                      );

                                                      
                                                    }();
                                                    break;

                                                  case 'Hold Cart':
                                                    if (model
                                                            .cartItems
                                                            .isNotEmpty &&
                                                        model
                                                            .customerListController
                                                            .text
                                                            .isNotEmpty) {
                                                      await holdCartItem(model);
                                                      model.cartItems.clear();
                                                      model
                                                              .customerListController
                                                              .text =
                                                          UserPreference.getString(
                                                            PrefKeys
                                                                .walkInCustomer,
                                                          ) ??
                                                          "";
                                                      model
                                                          .allItemsDiscountAmount
                                                          .text = '';
                                                      model
                                                          .allItemsDiscountPercent
                                                          .text = '';
                                                      model.totalQTy = 0;
                                                      model.grossTotal = 0;
                                                      model.netTotal = 0;
                                                      model.originalNetTotal =
                                                          0;
                                                      model.vatTotal = 0;
                                                      model.grandTotal = 0;
                                                      model.showAddDiscount =
                                                          false;
                                                      model.notifyListeners();
                                                    } else if (model
                                                        .cartItems
                                                        .isEmpty) {
                                                      DialogUtils.showWarning(
                                                        context: context,
                                                        title: "Empty Cart",
                                                        message: "Cannot hold an empty cart.",
                                                      );
                                                    } else if (model
                                                        .customerListController
                                                        .text
                                                        .isEmpty) {
                                                      DialogUtils.showWarning(
                                                        context: context,
                                                        title: "Customer Required",
                                                        message: "Cannot hold unless a customer is selected.",
                                                      );
                                                    }
                                                    break;

                                                  case 'Retrieve Cart':
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        settings:
                                                            const RouteSettings(
                                                              name:
                                                                  'HoldCartListPage',
                                                            ),
                                                        builder:
                                                            (context) =>
                                                                HoldCartListPage(),
                                                      ),
                                                    );
                                                    break;

                                                  case 'Sync Invoices':
                                                    await createInvoiceRequest();
                                                    break;

                                                  case 'Calculator':
                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (context) {
                                                        return Center(
                                                          child: Material(
                                                            color:
                                                                Colors
                                                                    .transparent,
                                                            child: Container(
                                                              width: 300,
                                                              height: 500,
                                                              decoration: BoxDecoration(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      16,
                                                                    ),
                                                              ),
                                                              child:
                                                                  CalculatorWidget(),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    break;

                                                  case 'Approvals':
                                                    showDialog(
                                                      context: context,
                                                      builder:
                                                          (_) => AlertDialog(
                                                            title: Text(
                                                              "Approvals",
                                                            ),
                                                            content: Text(
                                                              "Feature under development.",
                                                            ),
                                                          ),
                                                    );
                                                    break;

                                                  case 'Quotation':
                                                    showDialog(
                                                      context: context,
                                                      builder:
                                                          (_) => AlertDialog(
                                                            title: Text(
                                                              "Quotation",
                                                            ),
                                                            content: Text(
                                                              "Feature under development.",
                                                            ),
                                                          ),
                                                    );
                                                    break;
                                                  

                                                  default:
                                                    break;
                                                }
                                              },

                                              child: Center(
                                                child: Text(
                                                  keys[index],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12,

                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors
                                                            .white, // Text color
                                                  ),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 3.w),

                    checkOutRightSide(context, model),

                    Visibility(
                      visible: model.isCheckOutScreen == false,
                   
                      child: Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),

                          
                            Visibility(
                           
                              child: cartDesign(context, model, widget.isSalesReturn),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),

              /// <---Status Print--->
              Row(
                children: [
                  Visibility(
                   
                    child: Container(width: 3.w),
                  ),
                  Visibility(
                  
                    child: Container(width: 20.w),
                  ),
                 
                  Expanded(
                    child: Container(
                   
                      height: 25.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.r)),
                      
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.only(left: 5.w, right: 5.w),
                      child: SingleText(
                        text: "",
                        fontSize: 4.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
 
  }

}


