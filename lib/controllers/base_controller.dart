import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

import '../models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

 List<Item> cartItems = [];





class ItemScreenController extends ChangeNotifier {
  BuildContext? context;

 
 
}


class CartItemScreenController extends ItemScreenController {
  CartItemScreenController(BuildContext buildContext) {
    context = buildContext;
  }

   Future<void> addItemsToCart(Item item) async {
    try{
      for (var cartItem in cartItems) {
      if (cartItem.itemCode == item.itemCode) {
        cartItem.qty += 1;
        cartItem.itemTotal = cartItem.newRate * cartItem.qty;
        cartItem.totalWithVatPrev = cartItem.newRate * cartItem.qty;
        notifyListeners();
        return;
      }
    }

    cartItems.add(item);
    notifyListeners();
    }
     catch(e)
  {
    logErrorToFile("error $e");
  }
    
  }

   void initialise() async{
  
    await dbSync(context, notifyListeners);
    notifyListeners();
   }

   
  int? batchTableQty;
  String? batchTableBatchNo;
 
}