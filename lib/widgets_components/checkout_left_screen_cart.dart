import 'package:flutter/material.dart';
import '../widgets_components/cart_design_checkout_screen.dart';


 Widget checkOutLeftScreenCart(BuildContext context, model){
 
    return Visibility(
      visible: model.isCheckOutScreen == true ,
      child: Expanded(
        flex: 2,
        child: Column(
          children: [
            cartDesignCheckOutScreen(context,model),
           
          ],
        ),
      ),
    );
  }