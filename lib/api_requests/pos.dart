import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/database_conn/create_payment_tables.dart';
import 'package:offline_pos/database_conn/insert_payment.dart';
import 'package:offline_pos/database_conn/insert_pos.dart';
import 'package:offline_pos/database_conn/users.dart';
import 'package:offline_pos/models/currency_denominations_model.dart';
import 'package:offline_pos/models/mode_of_payment.dart';
import 'package:offline_pos/models/pos_profile_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/globals/global_values.dart';
Future<List<TempPOSProfileModel>> posProfileRequest(String httpType, String frappeInstance, String user) async {
  try {

    

    final response = await http.get(
      Uri.parse('$transferProtocol://$frappeInstance/api/method/offline_pos_erpnext.API.login.get_user_details?user=$user'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
      
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Check if the response contains message
      if (body is Map && body['message'] != null) {
        
        await createModeOfPaymentTable();
        List<TempPOSProfileModel> items = [];
        for (var item in body['message']) {

          if (item['default'] == 1)
          {
              await UserPreference.getInstance();
              await UserPreference.putString(PrefKeys.companyName, item['company']);
              await UserPreference.putString(PrefKeys.taxID, item['tax_id']);
              await UserPreference.putString(PrefKeys.crNO, item['cr_no']);
               await UserPreference.putString(PrefKeys.companyAddress, item['address']);
              await UserPreference.putString(PrefKeys.walkInCustomer, item['customer'] ?? "");
              await UserPreference.putString(PrefKeys.branchID, item['custom_pos_id'] ?? "");
              await UserPreference.putString(PrefKeys.currency, item['currency']);
              await UserPreference.putString (PrefKeys.currencyPrecision, item['currency_precision'].toString());
              await UserPreference.putString(PrefKeys.posProfileName, item['name']);
              await UserPreference.putString(PrefKeys.country, item['country']);
              await UserPreference.putString(PrefKeys.applyDiscountOn, item['apply_discount_on']);
              await UserPreference.putString(PrefKeys.posProfileWarehouse, item['warehouse']);
              await UserPreference.putString(PrefKeys.maxDiscountAllowed, item['custom_max_invoice_discount'].toString());
              await UserPreference.putBool(PrefKeys.enableBelowCostValidation, item['custom_enable_below_cost_validation'] == 1);
              
              // Cash Drawer Settings from ERPNext
              if (item['settings'] != null) {
                await UserPreference.putBool(
                  PrefKeys.openCashDrawer, 
                  item['settings']['open_cash_drawer'] == 1
                );
                // Set default cash drawer connection type if not already set
                final currentConnectionType = UserPreference.getString(PrefKeys.cashDrawerConnectionType);
                if (currentConnectionType == null || currentConnectionType.isEmpty) {
                  await UserPreference.putString(PrefKeys.cashDrawerConnectionType, 'printer');
                }
                
                // VFD Welcome Text from ERPNext (custom_default_display_text)
                final vfdWelcomeText = item['settings']['default_vfd_text'];
                if (vfdWelcomeText != null && vfdWelcomeText.toString().isNotEmpty) {
                  await UserPreference.putString(PrefKeys.vfdWelcomeText, vfdWelcomeText.toString());
                }
              }
              
              await UserPreference.putBool(PrefKeys.autoPressEnterOnScan, item['auto_press_enter_when_scanning'] == 1? true : false);
              await UserPreference.putBool(PrefKeys.disableBeep, item['disable_beep_sound'] == 1? true : false);
              await UserPreference.putInt(PrefKeys.delayMilliSecondsScan, item['delay_milliseconds_after_pressing_enter']);
              await UserPreference.putInt(PrefKeys.scanBarcodeLength, item['barcode_scan_length']);
              
              // Store weight scale settings from Desktop POS Setting
              await UserPreference.putBool(PrefKeys.enableWeightScale, item['enable_weight_scale'] == 1);
              await UserPreference.putInt(PrefKeys.pluMaxLength, item['plu_max_length'] ?? 3);
              await UserPreference.putString(PrefKeys.weightScalePrefix, item['weight_scale_prefix'] ?? "");
              await UserPreference.putInt(PrefKeys.scalePluLength, item['scale_plu_length'] ?? 5);
              await UserPreference.putInt(PrefKeys.scaleValueLength, item['scale_value_length'] ?? 5);
              await UserPreference.putString(PrefKeys.valueType, item['value_type'] ?? "price");
              
              final isOfflinePOSSetup = UserPreference.getBool(PrefKeys.isOfflinePOSSetup);
              item['max_sync_minutes'] == 0 ? await UserPreference.putString(PrefKeys.maxSyncMin, "5") : await UserPreference.putString(PrefKeys.maxSyncMin, item['max_sync_minutes'].toString());
              item['sync_after_every_minutes'] == 0? await UserPreference.putString(PrefKeys.syncInterval, "5") : await UserPreference.putString(PrefKeys.syncInterval, item['sync_after_every_minutes'].toString());
              if (isOfflinePOSSetup == true) {
                item['max_sync_minutes'] = 1;
              
              }

          }
          items.add(TempPOSProfileModel.fromJson(item));
          await insertTablePosProfile( d: [TempPOSProfileModel.fromJson(item)]);
          final paymentModeApiIds = (item['payment_methods'] as List)
            .map((pm) => pm['mode_of_payment'])
            .toList();

          for (var data in item['payment_methods'])
          {
            if (data['default'] == 1)
            {
              UserPreference.putString(PrefKeys.paymentMode, data['mode_of_payment']);
            }
          
            await insertTableModeOfPayment(d: [ModeOfPaymentModel.fromJson(data)]);
          }
       
          await deleteAllModeOfPayment(paymentModeApiIds);

          final CurrencyDenominationApiIds = (item['currency_denominations'] as List)
            .map((pm) => pm['currency_denomination_id'])
            .toList();
          
          for (var data in item['currency_denominations'])
          {
            await insertCurrencyDenominationTable(d: [CurrencyDenomination.fromJson(data)]);
          }
          await deleteAllCurrencyDenomination(CurrencyDenominationApiIds);
          currencyDenominationList = await  fetchFromCurrencyDenomination();
        }
        return items;
      } else {
      
        print("⚠️ No pos profile found: $body");
        return [];
      }
    } else {
      print("❌ Failed to fetch pos profile: ${response.statusCode}, body: ${response.body}");
      return [];
    }
  } catch (e) {
    print("❌ Error: $e");
    
    return [];
  }
}