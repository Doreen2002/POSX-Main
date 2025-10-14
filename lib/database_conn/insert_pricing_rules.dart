import 'dart:async';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/models/pricing_rule_model.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';

Future<dynamic> insertTablePricingRule({required List<PricingRuleModel> d}) async {
  final conn = await getDatabase();
  try {
    const insertQuery = '''
      INSERT INTO PricingRules 
      (pricing_rule_id, title, company, currency, disable, apply_on, selling, 
       rate_or_discount, discount_percentage, discount_amount, rate, min_qty, max_qty, 
       min_amt, max_amt, valid_from, valid_upto, priority, apply_multiple_pricing_rules, 
       is_cumulative, applicable_for, customer, customer_group, territory, 
       price_or_product_discount, free_item, free_qty, margin_type, margin_rate_or_amount, 
       mixed_conditions, rule_description, condition_code, erpnext_created, erpnext_modified) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) 
      ON DUPLICATE KEY UPDATE
      title = VALUES(title),
      company = VALUES(company),
      currency = VALUES(currency),
      disable = VALUES(disable),
      apply_on = VALUES(apply_on),
      selling = VALUES(selling),
      rate_or_discount = VALUES(rate_or_discount),
      discount_percentage = VALUES(discount_percentage),
      discount_amount = VALUES(discount_amount),
      rate = VALUES(rate),
      min_qty = VALUES(min_qty),
      max_qty = VALUES(max_qty),
      min_amt = VALUES(min_amt),
      max_amt = VALUES(max_amt),
      valid_from = VALUES(valid_from),
      valid_upto = VALUES(valid_upto),
      priority = VALUES(priority),
      apply_multiple_pricing_rules = VALUES(apply_multiple_pricing_rules),
      is_cumulative = VALUES(is_cumulative),
      applicable_for = VALUES(applicable_for),
      customer = VALUES(customer),
      customer_group = VALUES(customer_group),
      territory = VALUES(territory),
      price_or_product_discount = VALUES(price_or_product_discount),
      free_item = VALUES(free_item),
      free_qty = VALUES(free_qty),
      margin_type = VALUES(margin_type),
      margin_rate_or_amount = VALUES(margin_rate_or_amount),
      mixed_conditions = VALUES(mixed_conditions),
      rule_description = VALUES(rule_description),
      condition_code = VALUES(condition_code),
      erpnext_created = VALUES(erpnext_created),
      erpnext_modified = VALUES(erpnext_modified),
      modified_at = CURRENT_TIMESTAMP;
    ''';

    for (var element in d) {
      await conn.query(insertQuery, [
        element.name,
        element.title,
        element.company,
        element.currency,
        element.disabled ?? 0,
        element.applyOn,
        element.sellingOrBuying,
        element.rateOrDiscount,
        element.discountPercentage ?? 0, // ✅ NEW: Use actual discount percentage
        element.discountAmount ?? 0,     // ✅ NEW: Use actual discount amount  
        element.rate ?? 0,               // ✅ NEW: Use actual rate
        element.minQty,
        element.maxQty,
        element.minAmount,
        element.maxAmount,
        element.validFrom,
        element.validUpto,
        element.priority,
        0, // apply_multiple_pricing_rules placeholder
        element.isCumulative ?? 0,
        element.applicableFor,
        element.customer,
        element.customerGroup,
        element.territory,
        element.priceOrProductDiscount,
        "", // free_item placeholder
        0, // free_qty placeholder
        element.marginType,
        element.marginRateOrAmount,
        element.mixedConditions,
        element.ruleDescription,
        element.conditionalFormula,
        element.erpCreated,
        element.erpLastModified,
      ]);
    }
    await conn.close();
    return d.length;
  } catch (e) {
    await conn.close();
    logErrorToFile("Error inserting pricing rules: $e");
    return {"error": e.toString()};
  }
}

Future<dynamic> insertTablePricingRuleItem({required List<PricingRuleItemModel> d}) async {
  final conn = await getDatabase();
  try {
    const insertQuery = '''
      INSERT INTO PricingRuleItems (pricing_rule_id, item_code)
      VALUES (?, ?)
      ON DUPLICATE KEY UPDATE
        item_code = VALUES(item_code);
    ''';

    for (var element in d) {
      await conn.query(insertQuery, [
        element.parent,
        element.itemCode,
      ]);
    }
    await conn.close();
    return d.length;
  } catch (e) {
    await conn.close();
    logErrorToFile("Error inserting pricing rule items: $e");
    return {"error": e.toString()};
  }
}

Future<dynamic> insertTablePricingRuleItemGroup({required List<PricingRuleItemGroupModel> d}) async {
  final conn = await getDatabase();
  try {
    const insertQuery = '''
      INSERT INTO PricingRuleItemGroups (pricing_rule_id, item_group)
      VALUES (?, ?)
      ON DUPLICATE KEY UPDATE
        item_group = VALUES(item_group);
    ''';

    for (var element in d) {
      await conn.query(insertQuery, [
        element.parent,
        element.itemGroup,
      ]);
    }
    await conn.close();
    return d.length;
  } catch (e) {
    await conn.close();
    logErrorToFile("Error inserting pricing rule item groups: $e");
    return {"error": e.toString()};
  }
}

Future<dynamic> insertTablePricingRuleBrand({required List<PricingRuleBrandModel> d}) async {
  final conn = await getDatabase();
  try {
    const insertQuery = '''
      INSERT INTO PricingRuleBrands (pricing_rule_id, brand)
      VALUES (?, ?)
      ON DUPLICATE KEY UPDATE
        brand = VALUES(brand);
    ''';

    for (var element in d) {
      await conn.query(insertQuery, [
        element.parent,
        element.brand,
      ]);
    }
    await conn.close();
    return d.length;
  } catch (e) {
    await conn.close();
    logErrorToFile("Error inserting pricing rule brands: $e");
    return {"error": e.toString()};
  }
}