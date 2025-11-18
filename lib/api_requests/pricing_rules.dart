import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:offline_pos/database_conn/insert_pricing_rules.dart';
import 'package:offline_pos/models/pricing_rule_model.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/globals/global_values.dart';
final storage = FlutterSecureStorage();

Future<List<PricingRuleModel>> pricingRulesRequest(
    String httpType, String frappeInstance, String user) async {
  try {
    final response = await http.get(
      Uri.parse('$transferProtocol://$frappeInstance/api/method/offline_pos_erpnext.API.pricing_rules.get_pricing_rules_for_pos?user=$user'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
    );

    // Check if the response status is OK (200)
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Check if the response contains data
      if (body is Map && body['message'] != null) {
        // Map the pricing rules message to PricingRuleModel objects
        List<PricingRuleModel> pricingRules = [];
        for (var rule in body['message']) {
          pricingRules.add(PricingRuleModel.fromJson(rule));
          await insertTablePricingRule(d: [PricingRuleModel.fromJson(rule)]);
          
          // Insert child table records if they exist
          if (rule['items'] != null) {
            List<PricingRuleItemModel> items = [];
            for (var item in rule['items']) {
              items.add(PricingRuleItemModel.fromJson(item));
            }
            if (items.isNotEmpty) {
              await insertTablePricingRuleItem(d: items);
            }
          }
          
          if (rule['item_groups'] != null) {
            List<PricingRuleItemGroupModel> itemGroups = [];
            for (var itemGroup in rule['item_groups']) {
              itemGroups.add(PricingRuleItemGroupModel.fromJson(itemGroup));
            }
            if (itemGroups.isNotEmpty) {
              await insertTablePricingRuleItemGroup(d: itemGroups);
            }
          }
          
          if (rule['brands'] != null) {
            List<PricingRuleBrandModel> brands = [];
            for (var brand in rule['brands']) {
              brands.add(PricingRuleBrandModel.fromJson(brand));
            }
            if (brands.isNotEmpty) {
              await insertTablePricingRuleBrand(d: brands);
            }
          }
        }
        return pricingRules;
      } else {
        logErrorToFile("⚠️ No pricing rules found: $body");
        return [];
      }
    } else {
      logErrorToFile("❌ Failed to fetch pricing rules: ${response.statusCode}, body: ${response.body}");
      return [];
    }
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}

Future<List<PricingRuleModel>> pricingRulesIncrementalRequest(
    String httpType, String frappeInstance, String user, String lastSyncTime) async {
  try {
    final response = await http.get(
      Uri.parse('$transferProtocol://$frappeInstance/api/method/offline_pos_erpnext.API.pricing_rules.get_pricing_rules_incremental?user=$user&last_sync_time=$lastSyncTime'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': UserPreference.getString(PrefKeys.cookies) ?? "",
      },
    );

    // Check if the response status is OK (200)
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Check if the response contains data
      if (body is Map && body['message'] != null) {
        // Map the pricing rules message to PricingRuleModel objects
        List<PricingRuleModel> pricingRules = [];
        for (var rule in body['message']) {
          pricingRules.add(PricingRuleModel.fromJson(rule));
          await insertTablePricingRule(d: [PricingRuleModel.fromJson(rule)]);
        }
        return pricingRules;
      } else {
        logErrorToFile("⚠️ No incremental pricing rules found: $body");
        return [];
      }
    } else {
      logErrorToFile("❌ Failed to fetch incremental pricing rules: ${response.statusCode}, body: ${response.body}");
      return [];
    }
  } catch (e) {
    logErrorToFile("❌ Error: $e");
    return [];
  }
}