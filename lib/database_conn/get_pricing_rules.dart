import 'dart:async';
import 'package:offline_pos/models/pricing_rule_model.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';

List<PricingRuleModel> pricingRuleListdata = [];
List<PricingRuleItemModel> pricingRuleItemListdata = [];
List<PricingRuleItemGroupModel> pricingRuleItemGroupListdata = [];
List<PricingRuleBrandModel> pricingRuleBrandListdata = [];

Future<List<PricingRuleModel>> fetchFromPricingRules() async {
  try {
    final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM PricingRules WHERE disabled = 0 ORDER BY priority DESC;");

    pricingRuleListdata = queryResult
        .map((row) => PricingRuleModel.fromJson(row.fields))
        .toList()
        .cast<PricingRuleModel>();

    await conn.close();
    return pricingRuleListdata;
  } catch (e) {
    logErrorToFile("Error fetching data from PricingRules Table: $e");
    return [];
  }
}

Future<List<PricingRuleItemModel>> fetchFromPricingRuleItems() async {
  try {
    final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM PricingRuleItems;");

    pricingRuleItemListdata = queryResult
        .map((row) => PricingRuleItemModel.fromJson(row.fields))
        .toList()
        .cast<PricingRuleItemModel>();

    await conn.close();
    return pricingRuleItemListdata;
  } catch (e) {
    logErrorToFile("Error fetching data from PricingRuleItems Table: $e");
    return [];
  }
}

Future<List<PricingRuleItemGroupModel>> fetchFromPricingRuleItemGroups() async {
  try {
    final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM PricingRuleItemGroups;");

    pricingRuleItemGroupListdata = queryResult
        .map((row) => PricingRuleItemGroupModel.fromJson(row.fields))
        .toList()
        .cast<PricingRuleItemGroupModel>();

    await conn.close();
    return pricingRuleItemGroupListdata;
  } catch (e) {
    logErrorToFile("Error fetching data from PricingRuleItemGroups Table: $e");
    return [];
  }
}

Future<List<PricingRuleBrandModel>> fetchFromPricingRuleBrands() async {
  try {
    final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM PricingRuleBrands;");

    pricingRuleBrandListdata = queryResult
        .map((row) => PricingRuleBrandModel.fromJson(row.fields))
        .toList()
        .cast<PricingRuleBrandModel>();

    await conn.close();
    return pricingRuleBrandListdata;
  } catch (e) {
    logErrorToFile("Error fetching data from PricingRuleBrands Table: $e");
    return [];
  }
}

Future<List<PricingRuleModel>> fetchApplicablePricingRules({
  String? itemCode,
  String? itemGroup,
  String? brand,
  String? customerGroup,
  String? customer,
  double? qty,
  double? amount,
}) async {
  try {
    final conn = await getDatabase();
    
    String whereClause = "WHERE disabled = 0 AND (valid_from IS NULL OR valid_from <= CURDATE()) AND (valid_upto IS NULL OR valid_upto >= CURDATE())";
    List<dynamic> params = [];

    // Add item-specific filters
    if (itemCode != null) {
      whereClause += " AND (apply_on = 'Item Code' AND name IN (SELECT parent FROM PricingRuleItems WHERE item_code = ?))";
      params.add(itemCode);
    }
    
    if (itemGroup != null) {
      whereClause += " AND (apply_on = 'Item Group' AND name IN (SELECT parent FROM PricingRuleItemGroups WHERE item_group = ?))";
      params.add(itemGroup);
    }
    
    if (brand != null) {
      whereClause += " AND (apply_on = 'Brand' AND name IN (SELECT parent FROM PricingRuleBrands WHERE brand = ?))";
      params.add(brand);
    }

    // Add customer filters
    if (customer != null) {
      whereClause += " AND (customer IS NULL OR customer = ?)";
      params.add(customer);
    }
    
    if (customerGroup != null) {
      whereClause += " AND (customer_group IS NULL OR customer_group = ?)";
      params.add(customerGroup);
    }

    // Add quantity filters
    if (qty != null) {
      whereClause += " AND (min_qty IS NULL OR min_qty <= ?) AND (max_qty IS NULL OR max_qty >= ?)";
      params.add(qty);
      params.add(qty);
    }

    // Add amount filters
    if (amount != null) {
      whereClause += " AND (min_amount IS NULL OR min_amount <= ?) AND (max_amount IS NULL OR max_amount >= ?)";
      params.add(amount);
      params.add(amount);
    }

    final query = "SELECT * FROM PricingRules $whereClause ORDER BY priority DESC;";
    final queryResult = await conn.query(query, params);

    final applicableRules = queryResult
        .map((row) => PricingRuleModel.fromJson(row.fields))
        .toList()
        .cast<PricingRuleModel>();

    await conn.close();
    return applicableRules;
  } catch (e) {
    logErrorToFile("Error fetching applicable pricing rules: $e");
    return [];
  }
}