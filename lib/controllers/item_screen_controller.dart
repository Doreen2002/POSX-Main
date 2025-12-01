import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:offline_pos/globals/global_values.dart';
import 'package:offline_pos/models/item_price.dart';
import 'package:offline_pos/utils/dialog_utils.dart';
import 'package:offline_pos/api_requests/customer.dart';
import 'package:offline_pos/api_requests/items.dart';
import 'package:offline_pos/api_requests/post_pos_entry.dart';
import 'package:offline_pos/api_requests/pricing_rules.dart';
import 'package:offline_pos/api_requests/sales.dart';
import 'package:offline_pos/controllers/base_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/database_conn/get_customer.dart' as getCustomer;
import 'package:offline_pos/database_conn/get_item_queries.dart' as fetchItemQueries;
import 'package:offline_pos/database_conn/get_payment.dart'
    as modeOfPaymentListData;
    import 'package:flutter_libserialport/flutter_libserialport.dart';
     import 'dart:math' as math;
import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/database_conn/sales.dart';
import 'package:offline_pos/services/optimized_data_manager.dart';
import 'package:offline_pos/models/batch_list_model.dart';
import 'package:offline_pos/models/customer_list_model.dart';
import 'package:offline_pos/models/item_model.dart';
import 'package:offline_pos/models/type_ahead_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/services/pricing_rule_evaluation_service.dart';
import 'package:offline_pos/services/vfd_service.dart';
import '../models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:offline_pos/database_conn/get_payment.dart' as getPayment;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _audioPlayer = AudioPlayer();



class ItemScreenController extends ChangeNotifier {
  BuildContext? context;
}
bool isSyncing = false;
class CartItemScreenController extends ItemScreenController {

  Future<void> playBeepSound() async {
  try {
    await UserPreference.getInstance();
    bool  _playSound  = UserPreference.getBool(PrefKeys.disableBeep) ?? false;
    if(!_playSound)
    {
       await _audioPlayer.stop();
    await Future.delayed(const Duration(milliseconds: 50)); 
    await _audioPlayer.play(AssetSource('sounds/barcode_beep.wav'));
    }
   
  } catch (e) {
    logErrorToFile('Error playing beep sound: $e');
  }
}

  //is sales invoice return 
  bool isSalesReturn = false;
  String returnAgainst = '';

  //pricing rule
  String pricingRuleName = '';
  //keboardshortcuts
   bool isProcessingKey = false;
  //key pad
  FocusNode focusInputNode = FocusNode();
  TextEditingController focusInput = TextEditingController();
  bool autoFocusSearchItem = true;
  
  // Payment page barcode scanning for customer QR
  FocusNode paymentBarcodeFocusNode = FocusNode();
  TextEditingController paymentBarcodeController = TextEditingController();
  // needs BuildContext
  DateTime printFormateDate = DateTime.now();
  String printCurrDate = DateTime.now().toString();
  String printCurrTime = DateTime.now().toString();
  //closing and opening pos config
  String openingStartDate = DateTime.now().toString();
  String closingPeriodEndDate = DateTime.now().toString();
  String currency = UserPreference.getString(PrefKeys.currency) ?? '';
  TextEditingController timecontroller = TextEditingController();
  List entries = [];

  ///single item calculation side bar
  bool itemDiscountVisible = false;
  TextEditingController singleqtyController = TextEditingController();
  FocusNode singleqtyfocusNode = FocusNode();
  TextEditingController singlerateController = TextEditingController();
  FocusNode singleratefocusNode = FocusNode();
  TextEditingController singlediscountAmountController =
      TextEditingController();
        TextEditingController singleItemdiscountAmountController =
      TextEditingController();
  FocusNode singlediscountAmountfocusNode = FocusNode();
  TextEditingController singlediscountPercentController =
      TextEditingController();
    FocusNode singleItemdiscountAmountfocusNode = FocusNode();
  TextEditingController singleuomController = TextEditingController();
  FocusNode singleuomfocusNode = FocusNode();
  String singlediscountMaxPercent = '0';
  String singlediscountMaxAmount = '0.000';
  String singleItemdiscountAmount = '0.000';
  FocusNode singlediscountPercentfocusNode = FocusNode();
  final decimalPoints = int.tryParse(
    UserPreference.getString(PrefKeys.currencyPrecision) ?? "3",
  ) ?? 3;

  //vdf and cash drawer
  bool cashDrawerEnabled = UserPreference.getBool(PrefKeys.openCashDrawer) ?? false;

  ///<<<-----------------Payment List Calculation------------------->>>
  ///
FocusNode searchFocusNode = FocusNode();
  bool syncDataLoading = false;
  bool submitPrintClicked = false;
  bool submitNoPrintClicked = false;
  String paymentNotSelectionMsg = '';
  bool paymentmsgTimeOut = false;
  double paidAmount = 0;
  bool paymentUpdated = false;
  List<PaymentMode> paymentModeData = [];
  List<PaymentMode> _paymentModes = [];
  List<PaymentMode> get paymentModes => _paymentModes;
Future<void>  initializePaymentModes(List<PaymentModeTypeAheadModel> jsonData) async {
  customerDataList = await getCustomer.fetchFromCustomer();
  _paymentModes = jsonData.map((e) {

    final controller = TextEditingController();
    
    
    if (e.name == UserPreference.getString(PrefKeys.paymentMode)) {
     
      controller.text =roundToDecimals( grandTotal,decimalPoints) .toStringAsFixed(decimalPoints);
      paidAmount =  roundToDecimals( grandTotal, decimalPoints);
    }
    if(customerListController.text.isEmpty){
      customerListController.text = UserPreference.getString(PrefKeys.walkInCustomer) ?? "";
    }
    
    if(customerListController.text.isNotEmpty)
    {
      
      customerData = OptimizedDataManager.getCustomerByName(customerListController.text) ?? TempCustomerData();
      notifyListeners();
    }
    
    if (customerData.loyaltyPoints == 0 && e.name == 'Loyalty Points') {
      return null; 
    }
    
    notifyListeners();
    return PaymentMode(
      name: e.name ?? "",
      controller: controller,
      focusNode: FocusNode(),
    );
  })
  .where((mode) => mode != null) 
  .cast<PaymentMode>()
  .toList();

  paymentModeData = _paymentModes;
 
}

  void increaseAllItemsOpeningStock(String targetCode, int amount) {
    final item = OptimizedDataManager.getItemByCode(targetCode);
    if (item == null) {
      throw Exception('Item not found');
    }

    item.openingStock += amount;
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
       
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  //serial Item Logic
  final serialItem = {};

  //selected item for Single Item Details
  int selectedItemIndex = -1;
  List filteredItems = [];
  TextEditingController searchController = TextEditingController();

  int totalQTy = 0;
  double grossTotal = 0;
  double netTotal = 0;
  double originalNetTotal = 0;
  double vatTotal = 0;
  double grandTotal = 0;
  bool showAddDiscount = false;
  bool isCheckOutScreen = false;
  String isCheckOutScreenText = '';
  bool isCompleteOrderTap = false;
  TextEditingController allItemsDiscountPercent = TextEditingController();
  TextEditingController allItemsDiscountAmount = TextEditingController();
  FocusNode allItemsDiscountAmountFocusNode = FocusNode();
  FocusNode allItemsDiscountPercentFocusNode = FocusNode();
  bool allItemDiscountValidated = false;
  final customerListController = TextEditingController();
  TempCustomerData customerData = TempCustomerData();
  final ScrollController scrollController = ScrollController();
  final ScrollController allItemsScrollController = ScrollController();
  String customerNotSelectionMsg = '';
  String openAmount = UserPreference.getString(PrefKeys.openingAmount) ?? '';
  final companyName = TextEditingController();
  final posProfileController = TextEditingController();
  final openingEntryPaymentController = TextEditingController();
  final posOpeningAmount = TextEditingController();

  //item batch

  final batchController = TextEditingController();

  //salesinvoice submission
  bool printSalesInvoice = false;

  //sales person
  final salesListController = TextEditingController();
  String salePersonID = '';
  List modelSalesPersonList = [];
  bool setSalesPerson = false;

  ///<<<-----------------Payment List Calculation------------------->>>
  List paymentMode = [];

  bool msgTimeOut = false;
  DateTime currentYear = DateTime.now();
  List<Item> cartItems = [];

  CartItemScreenController(BuildContext buildContext) {
    context = buildContext;
  }

  Future<List<Item>> addItemsToCart(Item item, {from_hold=false}) async {
    try {
      totalQTy = 0;
      grossTotal = 0;
      netTotal = 0;
      vatTotal = 0;
      grandTotal = 0;
      originalNetTotal = 0;
      bool itemExists = false;
      if(item.openingStock == null)
      {
      final itemData = OptimizedDataManager.getItemByCode(item.itemCode);
      item.openingStock = itemData?.openingStock?.toInt() ?? 0;
      }
      if (item.batchQty == null)
      {
        final batchData = OptimizedDataManager.getBatchByCode(item.batchNumberSeries ?? '');
        item.batchQty = batchData?.batchQty ?? 0;
      }
      item.singleItemDiscAmount = (item.newNetRate ?? 0) * (item.singleItemDiscPer ?? 0)/100 ;
      item.ItemDiscAmount = (item.singleItemDiscAmount ?? 0) * item.qty;
      
      for (var cartItem in cartItems) {
        if(customerData.defaultPriceList != null)
      {
      
        await fetchItemQueries.fetchFromItemPrice();
        final itemPricingRuleRate = fetchItemQueries.itemPriceListdata.firstWhere(
          (price) => price.itemCode == cartItem.itemCode && price.priceList == customerData.defaultPriceList,
          orElse: () => ItemPrice(itemCode: cartItem.itemCode,name: cartItem.itemCode, UOM:cartItem.stockUom, priceList: customerData.defaultPriceList!, priceListRate: cartItem.standardRate ?? 0.0)
        ).priceListRate;
         cartItem.standardRate = itemPricingRuleRate;
         cartItem.newRate = itemPricingRuleRate;
         cartItem.newNetRate = itemPricingRuleRate;
      }
        if ((cartItem.itemCode == item.itemCode && cartItem.hasBatchNo == 0 && cartItem.qty < (item.openingStock ?? 0)) || (cartItem.itemCode == item.itemCode && cartItem.hasBatchNo == 1 && cartItem.batchNumberSeries == item.batchNumberSeries && cartItem.qty < (item.batchQty ?? 0))) {
         
          if(cartItem.hasBatchNo != 1)
          {
            itemExists = true;
             cartItem.qty += 1;
             playBeepSound();
          }
          if(cartItem.hasBatchNo == 1)
          {
            if(item.batchNumberSeries == cartItem.batchNumberSeries)
            {
              itemExists = true;
               cartItem.qty += 1;
                playBeepSound();
               
            }
            
          }
         
          // cartItem.openingStock = (cartItem.openingStock ?? 0) - 1;
          
          
          cartItem.newRate= ((cartItem.newNetRate ?? 0 ) - (cartItem.singleItemDiscAmount ?? 0)) ;
          double totalAmount = 
              (cartItem.newRate * cartItem.qty) ;
       

          if (cartItem.vatValue != 0) {
            item.vatValueAmount = roundToDecimals((totalAmount * (cartItem.vatValue! / 100)), decimalPoints)  ;
            totalAmount += roundToDecimals(totalAmount , decimalPoints) * roundToDecimals((cartItem.vatValue! / 100), decimalPoints);
            
            
          }
        
          cartItem.itemTotal = roundToDecimals((cartItem.newRate * cartItem.qty), decimalPoints) ;
        
          cartItem.totalWithVatPrev = roundToDecimals(totalAmount, decimalPoints); 
          cartItem.singleItemDiscAmount = (cartItem.newNetRate ?? 0) * (cartItem.singleItemDiscPer ?? 0)/100 ;
          cartItem.ItemDiscAmount = (cartItem.singleItemDiscAmount ?? 0) * cartItem.qty;
          
        }
       else  if ((cartItem.itemCode == item.itemCode && cartItem.hasBatchNo == 0 && cartItem.qty >= (item.openingStock ?? 0))|| (cartItem.itemCode == item.itemCode && cartItem.hasBatchNo == 1 && cartItem.batchNumberSeries == item.batchNumberSeries && cartItem.qty >= (item.batchQty ?? 0))) {
             await DialogUtils.showError(
              context: context!,
              title: 'Insufficient Stock',
              message:
              'You cannot set quantity greater than available stock.\nAvailable stock: ${ item.hasBatchNo != 1? item.openingStock : item.batchQty }',
                );
                discountCalculation(allItemsDiscountAmount.text, allItemsDiscountPercent.text);
                notifyListeners();
                  return cartItems;
                }
              }


      if (!itemExists) {
      //   if(customerData.defaultPriceList != null)
      // {
      
      //   await fetchItemQueries.fetchFromItemPrice();
      //   final itemPricingRuleRate = fetchItemQueries.itemPriceListdata.firstWhere(
      //     (price) => price.itemCode == item.itemCode && price.priceList == customerData.defaultPriceList,
      //     orElse: () => ItemPrice(itemCode: item.itemCode,name: item.itemCode, UOM:item.stockUom, priceList: customerData.defaultPriceList!, priceListRate: item.standardRate ?? 0.0)
      //   ).priceListRate;
      //    item.standardRate = itemPricingRuleRate;
      //    item.newRate = itemPricingRuleRate;
      //    item.newNetRate = itemPricingRuleRate;
      // }
        if (from_hold)
        {
          cartItems.add(item);
        }
        if(!from_hold)
        {
          cartItems.insert(0, item);
        }
        
        // ✅ NEW: Evaluate pricing rules for newly added item
        if (!from_hold) {
          try {
            Item updatedItem = await PricingRuleEvaluationService.evaluatePricingRulesForItem(cartItems[0]);
            cartItems[0] = updatedItem;
          } catch (e) {
            logErrorToFile("Error evaluating pricing rules for new item: $e");
          }
        }
        
         playBeepSound();
      } else {
        // ✅ NEW: Re-evaluate pricing rules for existing item with updated quantity
        try {
          for (int i = 0; i < cartItems.length; i++) {
            if (cartItems[i].itemCode == item.itemCode) {
              Item updatedItem = await PricingRuleEvaluationService.evaluatePricingRulesForItem(cartItems[i]);
              cartItems[i] = updatedItem;
              break;
            }
          }
        } catch (e) {
          logErrorToFile("Error re-evaluating pricing rules for existing item: $e");
        }
      }

      totalQTy = cartItems.fold(0, (sum, i) => sum + i.qty);
      netTotal = cartItems.fold(0, (sum, i) => sum + roundToDecimals( i.itemTotal,decimalPoints ));
      
      grossTotal = cartItems.fold(0, (sum, i) => sum + roundToDecimals( i.itemTotal,decimalPoints ));
      
      // ✅ VFD: Show item on customer display
      try {
        if (cartItems.isNotEmpty) {
          final lastItem = cartItems[0]; // Most recently added item
          VFDService.instance.showItem(
            itemName: lastItem.itemName ?? 'Unknown Item',
            qty: lastItem.qty,
            itemTotal: lastItem.totalWithVatPrev ?? 0.0,
            totalQty: totalQTy,
            cartTotal: grandTotal,
          );
        }
      } catch (e) {
        debugPrint('[VFD] Error showing item: $e');
      }
      
      // if (allItemsDiscountAmount.text.isNotEmpty) {
      //   netTotal = netTotal - double.parse(allItemsDiscountAmount.text);
      // }
      // if (allItemsDiscountPercent.text.isNotEmpty) {
      //   netTotal =
      //       netTotal -
      //       double.parse(allItemsDiscountPercent.text) / 100 * netTotal;
      // }
      // vatTotal = cartItems.fold(
      //   0,
      //   (sum, i) => sum + i.vatValue! / 100 * i.valuationRate,
      // );
      // vatTotal = double.parse(vatTotal.toStringAsFixed(decimalPoints));
      // grandTotal = netTotal + vatTotal;
      // cartItems = cartItems.where((item) => item.qty != 0).toList();
     
      // originalNetTotal = netTotal;
      
      discountCalculation(allItemsDiscountAmount.text, allItemsDiscountPercent.text);
      // searchFocusNode.requestFocus();
      // notifyListeners();
      
      
     
      return cartItems;
    } catch (e) {
      logErrorToFile("error $e");
      return <Item>[];
    }
  }
  bool _isInitialized = false;
 String hasFocus = '';
  void initialise(runInit, customer,  customcartItems) async {
    searchFocusNode.requestFocus();
    

    try {
         FocusManager.instance.addListener(() {
          final currentFocus = FocusManager.instance.primaryFocus;
      if (currentFocus != null) {
        for(var focusNode in paymentModes) {
          if (focusNode.focusNode.hasFocus) {
           
            hasFocus = focusNode.name;
            
          }
        }
        if (singleqtyfocusNode.hasFocus) {
          
          hasFocus = 'QTY';
         
        }
        if(singleItemdiscountAmountfocusNode.hasFocus)
        {
          hasFocus = 'singleItemdiscountAmountfocusNode';
        }
        if( singlediscountPercentfocusNode.hasFocus) {
         
          hasFocus = 'DISCOUNTPERCENT';
         
        }
        
        if (singlediscountAmountfocusNode.hasFocus)
        {
          
          hasFocus = 'DISCOUNTAMOUNT';
          
        }

       if(allItemsDiscountAmountFocusNode.hasFocus)
       {
        hasFocus = 'allItemsDiscountAmount';
       }
       if(allItemsDiscountPercentFocusNode.hasFocus)
       {
          hasFocus = 'allItemsDiscountPercent';
       }
       if(searchFocusNode.hasFocus)
       {
        hasFocus = 'searchFocusNode';
         
       }
        
        
      }
      else {
        hasFocus = '';
 
        searchFocusNode.requestFocus();
      }
    });

        if (_isInitialized) return;

        _isInitialized = true;
      await fetchFromPosOpening();
      if (posOpeningList.isEmpty) {
        await UserPreference.getInstance();
        await UserPreference.putString(PrefKeys.openingEntry, '');
        await UserPreference.putString(PrefKeys.openingAmount, '');
        openAmount = '';
      }
      if (posOpeningList.isNotEmpty) {
        final namingSeries = posOpeningList[0].namingSeries;
        final amount = posOpeningList[0].amount;

        await UserPreference.putString(
          PrefKeys.openingEntry,
         namingSeries != null && namingSeries.isNotEmpty ? namingSeries : ''

        );

        await UserPreference.putString(
          PrefKeys.openingAmount,
          amount?.toString() ?? '0',
        );
      }
     

      Future.delayed(const Duration(seconds: 365), () {
        if(customerListController.text.isEmpty){
          customerListController.text = UserPreference.getString(PrefKeys.walkInCustomer) ?? "";
        }
        if(customerListController.text.isNotEmpty)
        {
          customerData = OptimizedDataManager.getCustomerByName(customerListController.text) ?? TempCustomerData();
           WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
      });
        }
        initializePaymentModes(modeOfPaymentListData.modeOfPaymentList);
        getPosOpening();
         WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
      });
       
      });
      if (runInit) {
        await dbSync(context, notifyListeners);
      }
      repeatSync(context);
      getPosOpening();
      if(customerListController.text.isEmpty){
      customerListController.text = UserPreference.getString(PrefKeys.walkInCustomer) ?? "";
    }
      if(customerListController.text.isNotEmpty)
      {
        customerData = OptimizedDataManager.getCustomerByName(customerListController.text) ?? TempCustomerData();
        notifyListeners();
      }
  
      initializePaymentModes(modeOfPaymentListData.modeOfPaymentList);

      autoFocusSearchItem = true;
     
      if (customer.isNotEmpty)
      {
        customerListController.text = customer;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
      });
    } catch (e) {
      logErrorToFile("Error during initialization: $e");
    }
     WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
      });

      
  }

  void listenToFocus(focusNodeParam, controllerParam) {
    focusNodeParam.addListener(() {
      if (focusNodeParam.hasFocus) {
        focusInputNode = focusNodeParam;
        focusInput = controllerParam;
       
      }
    });
  }

 double truncateToDecimals(double value, int decimals) {
  double mod = math.pow(10.0, decimals) as double;
  return (value * mod).truncate() / mod;
}



double roundToDecimals(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}
  Future<void> discountCalculation(String amount, String percent) async {
    await UserPreference.getInstance();
    

    final applyDiscountOn = UserPreference.getString(PrefKeys.applyDiscountOn);
    
    // ✅ NEW: Separate items with and without pricing rules
    List<Item> itemsWithoutPricingRules = cartItems.where((item) => 
      item.discountSource != 'pricing_rule' && 
      !(item.hasPricingRuleApplied ?? false)
    ).toList();
    
    List<Item> itemsWithPricingRules = cartItems.where((item) => 
      item.discountSource == 'pricing_rule' || 
      (item.hasPricingRuleApplied ?? false)
    ).toList();
    
    // ✅ Calculate totals ONLY for items without pricing rules (eligible for invoice discount)
    double eligibleNetTotal = itemsWithoutPricingRules.fold(0, (sum, i) => sum + roundToDecimals(i.itemTotal, decimalPoints));
    double eligibleGrossTotal = itemsWithoutPricingRules.fold(
      0,
      (sum, i) => sum + i.itemTotal + double.parse((i.vatValue! / 100 * i.itemTotal).toStringAsFixed(decimalPoints)),
    );
    
    // ✅ Calculate totals for pricing rule items (not eligible for invoice discount)  
    double pricingRuleNetTotal = itemsWithPricingRules.fold(0, (sum, i) => sum + roundToDecimals(i.itemTotal, decimalPoints));
    double pricingRuleGrossTotal = itemsWithPricingRules.fold(
      0,
      (sum, i) => sum + i.itemTotal + double.parse((i.vatValue! / 100 * i.itemTotal).toStringAsFixed(decimalPoints)),
    );
    
    // ✅ Update totals to reflect both eligible and pricing rule items
    netTotal = eligibleNetTotal + pricingRuleNetTotal;
    originalNetTotal = netTotal;
    grossTotal = eligibleGrossTotal + pricingRuleGrossTotal;
    grandTotal = roundToDecimals(grossTotal, decimalPoints);
    vatTotal = 0;
    vatCalculation();

    if (applyDiscountOn == 'Grand Total') {
      if (eligibleGrossTotal > 0) {  // ✅ Only apply to eligible items
         if (percent.isNotEmpty && percent != '0' && percent != '0.0') {
          allItemsDiscountAmount.text = truncateToDecimals( (double.parse(percent) /
                  100 *
                  eligibleGrossTotal), decimalPoints)  // ✅ Apply only to eligible gross total
              .toString();
          grandTotal = (eligibleGrossTotal - (double.parse(percent) / 100 * eligibleGrossTotal)) + pricingRuleGrossTotal;
        }
         
         else if (amount.isNotEmpty) {
          allItemsDiscountPercent.text = '0';
          grandTotal = (eligibleGrossTotal - double.parse(amount)) + pricingRuleGrossTotal;
        }
      } else if (eligibleGrossTotal == 0 && amount.isNotEmpty || percent.isNotEmpty) {
        // ✅ Show warning if trying to apply invoice discount when all items have pricing rules
        showInvoiceDiscountWarning();
      }
      notifyListeners();
    } else if (applyDiscountOn == 'Net Total') {
      if (eligibleNetTotal > 0) {  // ✅ Only apply to eligible items
        if (percent.isNotEmpty && percent != '0' && percent != '0.0') {
          allItemsDiscountAmount.text = truncateToDecimals((double.parse(percent) / 100 * eligibleNetTotal)
          , decimalPoints).toString();
          netTotal = (eligibleNetTotal - (double.parse(percent) / 100 * eligibleNetTotal)) + pricingRuleNetTotal;
          grandTotal = roundToDecimals((netTotal + vatTotal), decimalPoints);
        }
        else if (amount.isNotEmpty) {
           allItemsDiscountPercent.text = '0';
          netTotal = (eligibleNetTotal - double.parse(amount)) + pricingRuleNetTotal;
          grandTotal = roundToDecimals((netTotal + vatTotal), decimalPoints);
        }
      } else if (eligibleNetTotal == 0 && (amount.isNotEmpty || percent.isNotEmpty)) {
        // ✅ Show warning if trying to apply invoice discount when all items have pricing rules
        showInvoiceDiscountWarning();
      }
      
       notifyListeners();
    }
   
    totalQTy = cartItems.fold(0, (sum, i) => sum + i.qty);
    notifyListeners();
    await initializePaymentModes(getPayment.modeOfPaymentList);
    notifyListeners();
  }

  // ✅ NEW: Show warning when trying to apply invoice discount to pricing rule items
  void showInvoiceDiscountWarning() {
    // Show SnackBar warning
    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(
            "Cannot apply invoice discount - all items have pricing rules applied",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
    }
    
    // Clear the discount input fields
    allItemsDiscountAmount.clear();
    allItemsDiscountPercent.clear();
    notifyListeners();
  }



  void discountItem(String name, String amount, String percent) {
    vatTotal = 0;
    vatCalculation();
    var item = cartItems.firstWhere((item) => item.name == name);
    double originalRate = item.itemTotal;
    try {
      if (amount.isEmpty && percent.isEmpty) {
       
        item.totalWithVatPrev =
            originalRate + (item.vatValue! / 100 * originalRate);
      } else {
        item.totalWithVatPrev = originalRate;
      }

      if (amount.isNotEmpty || amount != '0.000') {
        originalRate -= double.parse(amount);
        // item.totalWithVatPrev = originalRate + (item.vatValue! / 100 * originalRate);
        singlediscountPercentController.text =
            (double.parse(amount) / originalRate * 100).toStringAsFixed(3);
        item.singleItemDiscAmount = double.parse(amount);
      }

      if (percent.isNotEmpty || percent == "0.0") {
        originalRate -= (double.parse(percent) / 100 * originalRate);
        // item.totalWithVatPrev = originalRate + (item.vatValue! / 100 * originalRate);
      }
    } catch (e) {
     
      logErrorToFile('Item not found: $name');
    } finally {
     
      vatCalculation();
      netTotal = cartItems.fold(0, (sum, i) => sum + i.itemTotal);
      originalNetTotal = netTotal;
      grossTotal = netTotal + vatTotal;
      totalQTy = cartItems.fold(0, (sum, i) => sum + i.qty);
      grandTotal = grossTotal;
      notifyListeners();
    }
  }

  void vatCalculation() async {
    double _amount = 0;
      await UserPreference.getInstance();
    
    originalNetTotal = cartItems.fold(0, (sum, i) => sum + i.itemTotal);

    final applyDiscountOn = UserPreference.getString(PrefKeys.applyDiscountOn);
    if(applyDiscountOn == 'Grand Total')
    {
      _amount = grossTotal ;
       if (allItemsDiscountAmount.text.isNotEmpty) {
      netTotal =  cartItems.fold(
            0,
            (sum, i) =>
                sum +
      
          ((i.itemTotal ?? 0) -(i.itemTotal ?? 0)*  (double.parse(allItemsDiscountAmount.text) / grossTotal )) 
         
          );
      vatTotal = cartItems.fold(
            0,
            (sum, i) =>
                sum +
      
          ( (i.itemTotal ?? 0) -(i.itemTotal ?? 0)*  (double.parse(allItemsDiscountAmount.text) / grossTotal ))  *  i.vatValue! /
          100  ,
          );
           grandTotal = netTotal +vatTotal;
       }
    }
    else if(applyDiscountOn == 'Net Total')
    {
      _amount = originalNetTotal;
      if (allItemsDiscountAmount.text.isNotEmpty) {
      netTotal =  cartItems.fold(
            0,
            (sum, i) =>
                sum +
      
          ((i.itemTotal ?? 0) -(i.itemTotal ?? 0)*  (double.parse(allItemsDiscountAmount.text) / originalNetTotal )) 
         
          );
      vatTotal = cartItems.fold(
            0,
            (sum, i) =>
                sum +
      
          ( (i.itemTotal ?? 0) -(i.itemTotal ?? 0)*  (double.parse(allItemsDiscountAmount.text) / originalNetTotal ))  *  i.vatValue! /
          100  ,
          );
           grandTotal = netTotal +vatTotal;
      }
    }
    // if (allItemsDiscountAmount.text.isNotEmpty && allItemsDiscountAmount.text != '0' && allItemsDiscountAmount.text != '0.0') {
    //   vatTotal = cartItems.fold(
    //     0,
    //     (sum, i) =>
    //         sum +
            
    //             (((i.valuationRate ?? 0)/ double.parse(allItemsDiscountAmount.text)) / i.qty ) * i.qty *  i.vatValue! /
    //             100  ,
    //   );
    // }  if (allItemsDiscountPercent.text.isNotEmpty  && allItemsDiscountPercent.text != '0' && allItemsDiscountPercent.text != '0.0') {
    //   vatTotal = cartItems.fold(
    //     0,
    //     (sum, i) =>
    //         sum +
    //         i.vatValue! /
    //             100 *
    //             ((i.newNetRate ?? 0)-
    //                 double.parse(allItemsDiscountPercent.text) /
    //                     100 *
    //                    (i.newNetRate ?? 0)),
    //   );
    // } 
     if (allItemsDiscountPercent.text.isEmpty &&
        allItemsDiscountAmount.text.isEmpty) {
      vatTotal = cartItems.fold(
        0,
        (sum, i) => sum + i.vatValue! / 100 * i.itemTotal,
      );
    }
  vatTotal = double.parse(vatTotal.toStringAsFixed(decimalPoints));
  //  if(applyDiscountOn == 'Net Total')
  //   {
  // grandTotal = vatTotal + netTotal;
  //   }
    notifyListeners();
  }

  void refresh() async {
    // cartItems = [];
    await reloadItems();
    allItemsDiscountAmount.text = '';
    allItemsDiscountPercent.text = '';
    totalQTy = 0;
    grossTotal = 0;
    // customerListController.clear();
    netTotal = 0;
    vatTotal = 0;
    grandTotal = 0;
    showAddDiscount = false;
    notifyListeners();
  }

  int? batchTableQty;
  String? batchTableBatchNo;
}

Future <void> getPosOpening() async {
  await fetchFromPosOpening();
  if (posOpeningList.isEmpty) {
    await UserPreference.getInstance();
    await UserPreference.putString(PrefKeys.openingEntry, '');
    await UserPreference.putString(PrefKeys.openingAmount, '');
  }
  if (posOpeningList.isNotEmpty) {
    await UserPreference.getInstance();
    await UserPreference.putString(
      PrefKeys.openingEntry,
      posOpeningList[0].name!.toString(),
    );
    await UserPreference.putString(
      PrefKeys.openingAmount,
      posOpeningList[0].amount!.toString(),
    );
  }
}

Future<void> repeatSync(context) async {
  try{
    bool hasInternet = await InternetConnection().hasInternetAccess;
    final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());
    Timer.periodic(Duration(minutes: 20), (Timer timer) async{
    if (hasInternet) {
          await submitInvoiceRequest() ;
          await errorInvoiceRequest();
        }});
  Timer.periodic(Duration(minutes: 20), (Timer timer) async{
    if (hasInternet) {
      if (isSyncing) return; 
      isSyncing = true;
      
      await createopeningEntry();
      await fetchFromPosOpening();
        await createCustomerRequest(
      "$transferProtocol",
      UserPreference.getString(PrefKeys.baseUrl)!,
    );
      await createInvoiceRequest();
     await  closePOSTOERPnext();
      await submitInvoiceRequest() ;
      await errorInvoiceRequest();
      await itemRequest("$transferProtocol",
      UserPreference.getString(PrefKeys.baseUrl)!,
      UserPreference.getString(PrefKeys.userName)!);
      await batchRequest("$transferProtocol",
      UserPreference.getString(PrefKeys.baseUrl)!,
      UserPreference.getString(PrefKeys.userName)!);
      await pricingRulesRequest(
      "$transferProtocol", 
      UserPreference.getString(PrefKeys.baseUrl)!,
      UserPreference.getString(PrefKeys.userName)!);
      await fetchItemQueries.fetchFromItem();
      await fetchItemQueries.fetchFromBatch();

    }
  });
  }
  catch(e)
  {
    logErrorToFile("error $e");
  }
  finally {
    isSyncing = false;
  }
  
}

Future<void> createopeningEntry() async {
  try{
    await fetchFromNotSyncedPosOpening();
  if (posOpeningNotSyncedList.isNotEmpty) {
   for(var pos in posOpeningNotSyncedList)
   {
    await openPosRequest(
        UserPreference.getString(PrefKeys.httpType)!,
        UserPreference.getString(PrefKeys.baseUrl)!,
        false,
        {
          'pos_profile': UserPreference.getString(PrefKeys.posProfileName)!,
          'company': UserPreference.getString(PrefKeys.companyName)!,
          'user': UserPreference.getString(PrefKeys.userName)!,
          'naming_series': '${pos.name} ',
          'period_start_date': DateTime.now().toString(),
          'balance_details': [
            {
              "mode_of_payment": "Cash",
              "opening_amount": pos.amount.toString(),
            },
           
          ],
        },
      );
   }
      
    }
  }
  catch(e)
  {
    logErrorToFile("$e");
  }
  
  
}
