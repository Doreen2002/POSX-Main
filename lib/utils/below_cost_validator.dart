import '../data_source/local/pref_keys.dart';
import '../data_source/local/user_preference.dart';

/// Utility class for handling below-cost sale validations
class BelowCostValidator {
  
  /// Check if below-cost validation is enabled in POS Profile
  static bool isValidationEnabled() {
    return UserPreference.getBool(PrefKeys.enableBelowCostValidation) ?? false;
  }
  
  /// Check if the selling price is below the cost price
  static bool isBelowCost({
    required double sellingPrice,
    required double costPrice,
  }) {
    return sellingPrice < costPrice;
  }
  
  /// Calculate the break-even price (cost price)
  static double calculateBreakEvenPrice(double costPrice) {
    return costPrice;
  }
  
  /// Calculate the discount percentage that brings price to break-even
  static double calculateBreakEvenDiscount({
    required double originalPrice,
    required double costPrice,
  }) {
    if (originalPrice <= 0) return 0.0;
    
    final maxAllowedDiscount = ((originalPrice - costPrice) / originalPrice) * 100;
    return maxAllowedDiscount.clamp(0.0, 100.0);
  }
  
  /// Calculate the discount amount that brings price to break-even
  static double calculateBreakEvenDiscountAmount({
    required double originalPrice,
    required double costPrice,
  }) {
    if (originalPrice <= costPrice) return 0.0;
    
    return originalPrice - costPrice;
  }
}