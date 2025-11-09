import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/widgets_components/all_items.dart';


  final TextEditingController _controller = TextEditingController();

  String? selectedItem;


  Widget SearchByItemName( context,  model, setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypeAheadField<String>(
          controller: _controller,
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              style: TextStyle(fontSize: 5.sp, color: Colors.black),
              decoration: InputDecoration(
                labelText: "Search by Item Name",
                
                labelStyle: TextStyle(color: Color.fromRGBO(43, 54, 145, 1)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: const BorderSide(color: Color(0xFF2B3691)),
                ),
                suffixIcon: Visibility(
                  visible: controller.text.isNotEmpty,
                  child: InkWell(
                    onTap: () {
                      controller.clear();
                      selectedItem = null;
                    },
                    child: Icon(
                      Icons.clear,
                      size: 30.r,
                      color: Color(0xFF2B3691),
                    ),
                  ),
                ),
              ),
            );
          },
          decorationBuilder:
              (context, child) => Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(6.r),
                child: child,
              ),
          suggestionsCallback: (pattern) async {
            if (pattern.trim().isEmpty) {
              return []; 
            }
            return itemListdata
                .where(
                  (item) =>
                      (item.itemName ?? "").toLowerCase().contains(
                        pattern.toLowerCase(),
                      )
                )
                .map((item) => item.itemName.toString())
                .take(4)
                .toList();
          },

          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion, style: TextStyle(fontSize: 5.sp)),
            );
          },
          onSelected: (suggestion) async{
            setState(() {
              selectedItem = suggestion;
              _controller.text = suggestion;
            });
            try {
              final item = itemListdata.firstWhere(
                (item) => item.itemName == suggestion,
                orElse: () => throw Exception('Item not found'),
              );
              await getPosOpening();
              if (posOpeningList.isEmpty) {
              await  showOpeningPOSDialog(context, model, item);
              }
              if (posOpeningList.isNotEmpty) {
              model.searchController.text = item.itemCode;
              await addItemsToCartTable(model, context, item);
              }
            } catch (e) {
              print("Error processing selection: $e");
            }
            finally
            {
              model.searchController.clear();
              selectedItem = null;
              _controller.clear();
            }
            

          },
         
        ),
      ]);
}