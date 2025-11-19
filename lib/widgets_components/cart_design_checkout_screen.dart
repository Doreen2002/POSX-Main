import 'package:flutter/material.dart';
import 'dart:async';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/widgets_components/cart_items.dart';

Widget cartDesignCheckOutScreen(BuildContext context, CartItemScreenController model){

    Timer? debounceCal;
    void onTextChang(String value) {
      if (debounceCal?.isActive ?? false) {
       
        debounceCal?.cancel();
      }
      debounceCal = Timer(const Duration(seconds: 2), () {
        
      });
    }
    return cartDesign(context, model, false);
  }