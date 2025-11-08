import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/create_payment_tables.dart';
import 'package:offline_pos/database_conn/create_pos_table.dart';
import 'package:offline_pos/database_conn/dbsync.dart';
import 'package:offline_pos/database_conn/sales.dart';
import 'package:offline_pos/database_conn/users.dart';
import 'package:offline_pos/pages/close_pos_entries.dart';
import 'package:offline_pos/pages/customer_list.dart';
import 'package:offline_pos/pages/hardware_settings_page.dart';
import 'package:offline_pos/pages/items_cart.dart';
import 'package:offline_pos/pages/open_pos_entires.dart';
import 'package:offline_pos/pages/pos_invoice_list.dart';
import 'package:offline_pos/widgets_components/closing_entry.dart';
import 'package:offline_pos/widgets_components/opening_entry.dart';
import '../common_widgets/single_text.dart';
import '../pages/login_screen.dart';

/// ✅ Custom route with no animation
Route _noAnimationRoute(Widget page, {String? name}) {
  return PageRouteBuilder(
    settings: name != null ? RouteSettings(name: name) : null,
    pageBuilder: (_, __, ___) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  );
}

Widget SideBar(BuildContext context, CartItemScreenController model) {
  FocusNode _focusNode = FocusNode();

  return Visibility(
    visible: true,
    child: SizedBox(
      width: 24.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // ✅ Home
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _menuItem('assets/ico/home.png', 'Home', () {
                  bool isHomePage =
                      ModalRoute.of(context)?.settings.name == 'CartItemScreen';

                  if (!isHomePage) {
                    Navigator.push(
                      context,
                      _noAnimationRoute(
                        CartItemScreen(runInit: false),
                        name: 'CartItemScreen',
                      ),
                    );
                  }
                }),
              ),

              SizedBox(height: 10.h),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _menuItem('assets/ico/open.png', 'Open POS', () async {
                  getPosOpening();
                  model.notifyListeners();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return openingEntryDialog(context, model);
                    },
                  );
                }),
              ),

              SizedBox(height: 10.h),
              // ✅ Close POS
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _menuItem('assets/ico/close.png', 'Close POS', () async {
                  getPosOpening();
                  model.notifyListeners();
                  if (posOpeningList.isNotEmpty) {
                    model.entries = await fetchSalesInvoicePaymentByName(
                      posOpeningList[0].name!,
                    );
                  }
                  currencyDenominationList =
                      await fetchFromCurrencyDenomination();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return closingEntryDialog(context, model);
                    },
                  );
                }),
              ),

              SizedBox(height: 10.h),
              // ✅ Sync Data
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _menuItem('assets/ico/sync.png', 'Sync Data', () async {
                  if (model.syncDataLoading) return;
                  model.syncDataLoading = true;
                   model.searchFocusNode.requestFocus();
                  await syncData(context, model);
                 
                  model.notifyListeners();
                   
                }),
              ),

              SizedBox(height: 10.h),
              // ✅ Customer
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _menuItem('assets/ico/user.png', 'Customers', () {
                  Navigator.push(
                    context,
                    _noAnimationRoute(
                      CustomerListPage(),
                      name: 'CustomerListPage',
                    ),
                  );
                }),
              ),

              SizedBox(height: 10.h),
              // ✅ Invoices
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _menuItem('assets/ico/purchase.png', 'Invoices', () {
                  bool isInvoicePage =
                      ModalRoute.of(context)?.settings.name ==
                      'InvoiceListPage';

                  if (!isInvoicePage) {
                    Navigator.push(
                      context,
                      _noAnimationRoute(
                        InvoiceListPage(),
                        name: 'InvoiceListPage',
                      ),
                    );
                  }
                }),
              ),

              SizedBox(height: 10.h),
              // ✅ Opening Vouchers
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _menuItem(
                  'assets/ico/voucher.png',
                  'Opening\nVouchers',
                  () {
                    Navigator.push(
                      context,
                      _noAnimationRoute(
                        OpeningEntryListPage(),
                        name: 'OpeningEntryListPage',
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 10.h),
            
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _menuItem(
                  'assets/ico/tickets.png',
                  'Closing\nVouchers',
                  () {
                    Navigator.push(
                      context,
                      _noAnimationRoute(
                        ClosingEntryListPage(),
                        name: 'ClosingEntryListPage',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
           SizedBox(height: 10.h),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: _menuItem('assets/ico/close.png', 'Settings', () {
                
                  Navigator.push(
                    context,
                    _noAnimationRoute(
                      const HardwareSettingsPage(),
                      name: 'HardwareSettingsPage',
                    ),
                  );
                }),
              ),
          
          Column(
            children: [
             

              SizedBox(height: 10.h),

              // Version Number
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: SingleText(
                  text: 'v1.0.0',
                  fontSize: 4.sp,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Icon(Icons.logout, size: 8.sp, color: Color(0xFF006A35)),
              ),

              // Logout Button
              InkWell(
                onTap: () async {
                  await deleteAllHoldCart();
                  await UserPreference.getInstance();
                  await UserPreference.putString(PrefKeys.salesPerson, '');

                  Navigator.push(
                    context,
                    _noAnimationRoute(const LoginScreen(), name: 'LoginScreen'),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF006A35),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: SingleText(
                    text: 'Logout',
                    fontSize: 5.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// ✅ Reusable Menu Item Widget
Widget _menuItem(String imagePath, String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, width: 35.r, height: 35.r, fit: BoxFit.contain),
        SizedBox(height: 3.h),
        SingleText(text: label, fontSize: 4.sp),
      ],
    ),
  );
}
