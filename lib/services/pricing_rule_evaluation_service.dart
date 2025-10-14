import 'dart:async';
import 'package:offline_pos/models/item.dart';
import 'package:offline_pos/models/pricing_rule_model.dart';
import 'package:offline_pos/database_conn/get_pricing_rules.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:offline_pos/data_source/local/pref_keys.dart';

/// Pricing Rule Evaluation Service
/// Handles automatic pricing rule evaluation and application to cart items
class PricingRuleEvaluationService {
  
  /// Evaluate and apply pricing rules for a specific item
  static Future<Item> evaluatePricingRulesForItem(Item item) async {
    try {
      // Get applicable pricing rules using fast Map lookups (O(1) vs database query)
      List<PricingRuleModel> applicableRules = _getApplicablePricingRulesFromMaps(
        itemCode: item.itemCode,
        itemGroup: item.itemGroup,
        qty: item.qty.toDouble(),
        amount: item.newNetRate != null ? (item.newNetRate! * item.qty) : item.itemTotal,
        // TODO: Add customer and customer group when available
        // customer: getCurrentCustomer(),
        // customerGroup: getCurrentCustomerGroup(),
      );
      
      if (applicableRules.isNotEmpty) {
        // Select the best pricing rule (highest priority, then highest discount)
        PricingRuleModel bestRule = _selectBestPricingRule(applicableRules);
        
        // Apply the pricing rule to the item
        _applyPricingRuleToItem(item, bestRule);
        
        logErrorToFile("Applied pricing rule '${bestRule.title}' to item '${item.itemCode}'");
      } else {
        // Clear any existing pricing rule data
        _clearPricingRuleFromItem(item);
      }
      
      return item;
    } catch (e) {
      logErrorToFile("Error evaluating pricing rules for item ${item.itemCode}: $e");
      return item;
    }
  }
  
  /// Evaluate pricing rules for entire cart
  static Future<List<Item>> evaluatePricingRulesForCart(List<Item> cartItems) async {
    List<Item> updatedItems = [];
    
    for (Item item in cartItems) {
      Item updatedItem = await evaluatePricingRulesForItem(item);
      updatedItems.add(updatedItem);
    }
    
    return updatedItems;
  }
  
  /// Select the best pricing rule from applicable rules
  /// Priority: 1) Highest priority number, 2) Highest discount percentage/amount
  static PricingRuleModel _selectBestPricingRule(List<PricingRuleModel> rules) {
    // Sort by priority (desc) then by discount percentage (desc)
    rules.sort((a, b) {
      // First sort by priority
      int priorityA = int.tryParse(a.priority ?? '1') ?? 1;
      int priorityB = int.tryParse(b.priority ?? '1') ?? 1;
      
      if (priorityA != priorityB) {
        return priorityB.compareTo(priorityA); // Higher priority first
      }
      
      // If priority is the same, sort by discount percentage
      double discountA = a.discountPercentage ?? 0;
      double discountB = b.discountPercentage ?? 0;
      
      return discountB.compareTo(discountA); // Higher discount first
    });
    
    return rules.first;
  }
  
  /// Apply pricing rule to item
  static void _applyPricingRuleToItem(Item item, PricingRuleModel rule) {
    try {
      // Calculate discount based on rule type
      double discountAmount = 0;
      double discountPercentage = 0;
      
      if (rule.rateOrDiscount == 'Discount Percentage') {
        discountPercentage = rule.discountPercentage ?? 0;
        discountAmount = (item.newNetRate ?? item.itemTotal) * (discountPercentage / 100);
      } else if (rule.rateOrDiscount == 'Discount Amount') {
        discountAmount = rule.discountAmount ?? 0;
        discountPercentage = ((discountAmount / (item.newNetRate ?? item.itemTotal)) * 100);
      } else if (rule.rateOrDiscount == 'Rate') {
        // Set new rate directly
        double newRate = rule.rate ?? 0;
        discountAmount = (item.newNetRate ?? item.itemTotal) - newRate;
        discountPercentage = (discountAmount / (item.newNetRate ?? item.itemTotal)) * 100;
      }
      
      // Apply the discount to the item
      item.singleItemDiscPer = discountPercentage;
      item.singleItemDiscAmount = discountAmount;
      item.ItemDiscAmount = discountAmount * item.qty;
      
      // Calculate new rate after discount
      item.newRate = (item.newNetRate ?? item.itemTotal) - discountAmount;
      
      // Calculate total amount with VAT
      double totalAmount = item.newRate * item.qty;
      
      if (item.vatValue != 0) {
        double vatAmount = totalAmount * (item.vatValue! / 100);
        item.vatValueAmount = _roundToDecimals(vatAmount, _getDecimalPoints());
        totalAmount += vatAmount;
      }
      
      item.itemTotal = _roundToDecimals((item.newRate * item.qty), _getDecimalPoints());
      item.totalWithVatPrev = _roundToDecimals(totalAmount, _getDecimalPoints());
      
      // ✅ SET PRICING RULE TRACKING FIELDS
      item.hasPricingRuleApplied = true;
      item.appliedPricingRuleId = rule.name;
      item.appliedPricingRuleTitle = rule.title;
      item.discountSource = 'pricing_rule';
      
      logErrorToFile("Applied pricing rule: ${rule.title} (${discountPercentage.toStringAsFixed(2)}% / ${discountAmount.toStringAsFixed(2)}) to item ${item.itemCode}");
      
    } catch (e) {
      logErrorToFile("Error applying pricing rule to item: $e");
    }
  }
  
  /// Clear pricing rule from item
  static void _clearPricingRuleFromItem(Item item) {
    item.hasPricingRuleApplied = false;
    item.appliedPricingRuleId = null;
    item.appliedPricingRuleTitle = null;
    item.discountSource = 'none';
    
    // Note: We don't clear manual discounts here, only pricing rule status
    // Manual discounts should be preserved when pricing rules don't apply
  }
  
  /// Check if item qualifies for specific pricing rule
  static Future<bool> doesItemQualifyForRule(Item item, PricingRuleModel rule) async {
    try {
      // Check date validity
      DateTime now = DateTime.now();
      
      if (rule.validFrom != null) {
        DateTime validFrom = DateTime.parse(rule.validFrom!);
        if (now.isBefore(validFrom)) return false;
      }
      
      if (rule.validUpto != null) {
        DateTime validUpto = DateTime.parse(rule.validUpto!);
        if (now.isAfter(validUpto)) return false;
      }
      
      // Check quantity limits
      if (rule.minQty != null && item.qty < rule.minQty!) return false;
      if (rule.maxQty != null && item.qty > rule.maxQty!) return false;
      
      // Check amount limits
      double itemAmount = (item.newNetRate ?? item.itemTotal) * item.qty;
      if (rule.minAmount != null && itemAmount < rule.minAmount!) return false;
      if (rule.maxAmount != null && itemAmount > rule.maxAmount!) return false;
      
      return true;
    } catch (e) {
      logErrorToFile("Error checking item qualification for rule: $e");
      return false;
    }
  }
  
  /// Get current customer (to be implemented when customer context is available)
  static String? getCurrentCustomer() {
    // TODO: Implement customer context retrieval
    return null;
  }
  
  /// Get current customer group (to be implemented when customer context is available)
  static String? getCurrentCustomerGroup() {
    // TODO: Implement customer group context retrieval
    return null;
  }
  
  /// Helper function to round to decimal places
  static double _roundToDecimals(double value, int places) {
    num mod = 1;
    for (int i = 0; i < places; i++) {
      mod *= 10;
    }
    return ((value * mod).round().toDouble() / mod);
  }
  
  /// Get decimal points from preferences
  static int _getDecimalPoints() {
    return int.tryParse(
      UserPreference.getString(PrefKeys.currencyPrecision) ?? "3",
    ) ?? 3;
  }
  
  /// Check if manual discount should be blocked for item
  static bool shouldBlockManualDiscount(Item item) {
    return item.hasPricingRuleApplied == true && 
           item.discountSource == 'pricing_rule';
  }
  
  /// Get pricing rule summary for item (for UI display)
  static String getPricingRuleSummary(Item item) {
    if (item.hasPricingRuleApplied == true && item.appliedPricingRuleTitle != null) {
      return "Applied: ${item.appliedPricingRuleTitle} (${item.singleItemDiscPer?.toStringAsFixed(1) ?? '0'}%)";
    }
    return "No pricing rule applied";
  }
  
  
  /// Get applicable pricing rules using fast Map lookups instead of database queries
  /// Provides O(1) performance vs O(n) database queries
  static List<PricingRuleModel> _getApplicablePricingRulesFromMaps({
    required String itemCode,
    String? itemGroup,
    required double qty,
    required double amount,
  }) {
    List<PricingRuleModel> applicableRules = [];
    
    try {
      // Get rules using direct database access for now
      // TODO: Re-enable optimized lookups when pricing rule structure is finalized
      applicableRules = pricingRuleListdata.where((rule) {
        // Basic item/group matching
        bool itemMatch = rule.otherItemCode == itemCode;
        bool groupMatch = itemGroup != null && rule.otherItemGroup == itemGroup;
        return itemMatch || groupMatch;
      }).toList();
      
      // Filter rules by conditions (date validity, quantity, amount, etc.)
      List<PricingRuleModel> validRules = [];
      
      for (PricingRuleModel rule in applicableRules) {
        // Check date validity
        DateTime now = DateTime.now();
        DateTime? validFrom = rule.validFrom != null ? DateTime.tryParse(rule.validFrom!) : null;
        DateTime? validUpto = rule.validUpto != null ? DateTime.tryParse(rule.validUpto!) : null;
        
        if (validFrom != null && now.isBefore(validFrom)) continue;
        if (validUpto != null && now.isAfter(validUpto)) continue;
        
        // Check disabled status
        if (rule.disabled == 1) continue;
        
        // Check minimum quantity
        if (rule.minQty != null && qty < rule.minQty!) continue;
        
        // Check maximum quantity
        if (rule.maxQty != null && qty > rule.maxQty!) continue;
        
        // Check minimum amount
        if (rule.minAmount != null && amount < rule.minAmount!) continue;
        
        // Check maximum amount
        if (rule.maxAmount != null && amount > rule.maxAmount!) continue;
        
        // TODO: Add customer and customer group checks when available
        // if (customer != null && rule.customer != null && rule.customer != customer) continue;
        // if (customerGroup != null && rule.customerGroup != null && rule.customerGroup != customerGroup) continue;
        
        validRules.add(rule);
      }
      
      // Remove duplicates (same rule might match both item and group criteria)
      Map<String, PricingRuleModel> uniqueRules = {};
      for (PricingRuleModel rule in validRules) {
        uniqueRules[rule.name ?? ''] = rule;
      }
      
      logErrorToFile("Found ${uniqueRules.length} applicable pricing rules for item $itemCode (qty: $qty, amount: $amount)");
      
      return uniqueRules.values.toList();
      
    } catch (e) {
      logErrorToFile("Error getting applicable pricing rules from maps: $e");
      return [];
    }
  }

  /// Validate pricing rule application (for debugging)
  static Future<Map<String, dynamic>> validatePricingRuleApplication(Item item) async {
    Map<String, dynamic> result = {
      'item_code': item.itemCode,
      'has_pricing_rule': item.hasPricingRuleApplied,
      'applied_rule_id': item.appliedPricingRuleId,
      'applied_rule_title': item.appliedPricingRuleTitle,
      'discount_source': item.discountSource,
      'discount_percentage': item.singleItemDiscPer,
      'discount_amount': item.singleItemDiscAmount,
    };
    
    if (item.hasPricingRuleApplied == true) {
      // Verify the rule still exists and is valid using fast Map lookup
      List<PricingRuleModel> currentRules = _getApplicablePricingRulesFromMaps(
        itemCode: item.itemCode,
        itemGroup: item.itemGroup,
        qty: item.qty.toDouble(),
        amount: (item.newNetRate ?? item.itemTotal) * item.qty,
      );
      
      bool ruleStillValid = currentRules.any((rule) => rule.name == item.appliedPricingRuleId);
      result['rule_still_valid'] = ruleStillValid;
      
      if (!ruleStillValid) {
        result['warning'] = 'Applied pricing rule is no longer valid';
      }
    }
    
    return result;
  }
}