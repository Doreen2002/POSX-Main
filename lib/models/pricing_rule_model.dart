class PricingRuleModel {
  String? name;
  String? title;
  int? disabled;
  String? applyOn;
  String? mixedConditions;
  int? isBasedOnQuantity;
  String? applicableFor;
  int? isCumulative;
  String? otherItemCode;
  String? otherItemGroup;
  String? otherBrand;
  String? company;
  String? currency;
  String? sellingOrBuying;
  String? applicability;
  String? applicableForCondition;
  String? customer;
  String? customerGroup;
  String? territory;
  String? salesPartner;
  String? campaign;
  String? supplier;
  String? supplierGroup;
  String? validFrom;
  String? validUpto;
  String? warehouse;
  double? minQty;
  double? maxQty;
  double? minAmount;
  double? maxAmount;
  String? priority;
  double? threshold;
  String? ruleDescription;
  String? priceOrProductDiscount;
  double? rateOrDiscount;
  
  // ✅ NEW: Separate discount fields from ERPNext
  double? discountPercentage;
  double? discountAmount;
  double? rate;
  
  int? forPriceList;
  String? marginType;
  double? marginRateOrAmount;
  String? promotionalScheme;
  int? samePriceListRate;
  String? conditionalFormula;

  // Reconciliation fields
  String? erpCreated;
  String? erpLastModified;
  String? posxLastModified;
  int? posxSyncStatus;
  String? posxSyncError;
  String? posxReconciliationHash;

  PricingRuleModel({
    this.name,
    this.title,
    this.disabled,
    this.applyOn,
    this.mixedConditions,
    this.isBasedOnQuantity,
    this.applicableFor,
    this.isCumulative,
    this.otherItemCode,
    this.otherItemGroup,
    this.otherBrand,
    this.company,
    this.currency,
    this.sellingOrBuying,
    this.applicability,
    this.applicableForCondition,
    this.customer,
    this.customerGroup,
    this.territory,
    this.salesPartner,
    this.campaign,
    this.supplier,
    this.supplierGroup,
    this.validFrom,
    this.validUpto,
    this.warehouse,
    this.minQty,
    this.maxQty,
    this.minAmount,
    this.maxAmount,
    this.priority,
    this.threshold,
    this.ruleDescription,
    this.priceOrProductDiscount,
    this.rateOrDiscount,
    // ✅ NEW: Separate discount fields
    this.discountPercentage,
    this.discountAmount,
    this.rate,
    this.forPriceList,
    this.marginType,
    this.marginRateOrAmount,
    this.promotionalScheme,
    this.samePriceListRate,
    this.conditionalFormula,
    this.erpCreated,
    this.erpLastModified,
    this.posxLastModified,
    this.posxSyncStatus,
    this.posxSyncError,
    this.posxReconciliationHash,
  });

  factory PricingRuleModel.fromJson(Map<String, dynamic> json) {
    return PricingRuleModel(
      name: json['name'],
      title: json['title'],
      disabled: json['disabled'] ?? 0,
      applyOn: json['apply_on'],
      mixedConditions: json['mixed_conditions'],
      isBasedOnQuantity: json['is_based_on_quantity'] ?? 0,
      applicableFor: json['applicable_for'],
      isCumulative: json['is_cumulative'] ?? 0,
      otherItemCode: json['other_item_code'],
      otherItemGroup: json['other_item_group'],
      otherBrand: json['other_brand'],
      company: json['company'],
      currency: json['currency'],
      sellingOrBuying: json['selling_or_buying'],
      applicability: json['applicability'],
      applicableForCondition: json['applicable_for_condition'],
      customer: json['customer'],
      customerGroup: json['customer_group'],
      territory: json['territory'],
      salesPartner: json['sales_partner'],
      campaign: json['campaign'],
      supplier: json['supplier'],
      supplierGroup: json['supplier_group'],
      validFrom: json['valid_from'],
      validUpto: json['valid_upto'],
      warehouse: json['warehouse'],
      minQty: json['min_qty']?.toDouble(),
      maxQty: json['max_qty']?.toDouble(),
      minAmount: json['min_amount']?.toDouble(),
      maxAmount: json['max_amount']?.toDouble(),
      priority: json['priority'],
      threshold: json['threshold']?.toDouble(),
      ruleDescription: json['rule_description'],
      priceOrProductDiscount: json['price_or_product_discount'],
      rateOrDiscount: json['rate_or_discount']?.toDouble(),
      // ✅ NEW: Separate discount fields
      discountPercentage: json['discount_percentage']?.toDouble(),
      discountAmount: json['discount_amount']?.toDouble(),
      rate: json['rate']?.toDouble(),
      forPriceList: json['for_price_list'] ?? 0,
      marginType: json['margin_type'],
      marginRateOrAmount: json['margin_rate_or_amount']?.toDouble(),
      promotionalScheme: json['promotional_scheme'],
      samePriceListRate: json['same_price_list_rate'] ?? 0,
      conditionalFormula: json['conditional_formula'],
      erpCreated: json['creation'],
      erpLastModified: json['erp_last_modified'],
      posxLastModified: json['posx_last_modified'],
      posxSyncStatus: json['posx_sync_status'] ?? 1,
      posxSyncError: json['posx_sync_error'],
      posxReconciliationHash: json['posx_reconciliation_hash'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'title': title,
      'disabled': disabled,
      'apply_on': applyOn,
      'mixed_conditions': mixedConditions,
      'is_based_on_quantity': isBasedOnQuantity,
      'applicable_for': applicableFor,
      'is_cumulative': isCumulative,
      'other_item_code': otherItemCode,
      'other_item_group': otherItemGroup,
      'other_brand': otherBrand,
      'company': company,
      'currency': currency,
      'selling_or_buying': sellingOrBuying,
      'applicability': applicability,
      'applicable_for_condition': applicableForCondition,
      'customer': customer,
      'customer_group': customerGroup,
      'territory': territory,
      'sales_partner': salesPartner,
      'campaign': campaign,
      'supplier': supplier,
      'supplier_group': supplierGroup,
      'valid_from': validFrom,
      'valid_upto': validUpto,
      'warehouse': warehouse,
      'min_qty': minQty,
      'max_qty': maxQty,
      'min_amount': minAmount,
      'max_amount': maxAmount,
      'priority': priority,
      'threshold': threshold,
      'rule_description': ruleDescription,
      'price_or_product_discount': priceOrProductDiscount,
      'rate_or_discount': rateOrDiscount,
      // ✅ NEW: Separate discount fields
      'discount_percentage': discountPercentage,
      'discount_amount': discountAmount,
      'rate': rate,
      'for_price_list': forPriceList,
      'margin_type': marginType,
      'margin_rate_or_amount': marginRateOrAmount,
      'promotional_scheme': promotionalScheme,
      'same_price_list_rate': samePriceListRate,
      'conditional_formula': conditionalFormula,
      'creation': erpCreated,
      'erp_last_modified': erpLastModified,
      'posx_last_modified': posxLastModified,
      'posx_sync_status': posxSyncStatus,
      'posx_sync_error': posxSyncError,
      'posx_reconciliation_hash': posxReconciliationHash,
    };
  }
}

class PricingRuleItemModel {
  String? name;
  String? parent;
  String? itemCode;
  String? uom;
  String? erpLastModified;
  String? posxLastModified;

  PricingRuleItemModel({
    this.name,
    this.parent,
    this.itemCode,
    this.uom,
    this.erpLastModified,
    this.posxLastModified,
  });

  factory PricingRuleItemModel.fromJson(Map<String, dynamic> json) {
    return PricingRuleItemModel(
      name: json['name'],
      parent: json['parent'],
      itemCode: json['item_code'],
      uom: json['uom'],
      erpLastModified: json['erp_last_modified'],
      posxLastModified: json['posx_last_modified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'parent': parent,
      'item_code': itemCode,
      'uom': uom,
      'erp_last_modified': erpLastModified,
      'posx_last_modified': posxLastModified,
    };
  }
}

class PricingRuleItemGroupModel {
  String? name;
  String? parent;
  String? itemGroup;
  String? erpLastModified;
  String? posxLastModified;

  PricingRuleItemGroupModel({
    this.name,
    this.parent,
    this.itemGroup,
    this.erpLastModified,
    this.posxLastModified,
  });

  factory PricingRuleItemGroupModel.fromJson(Map<String, dynamic> json) {
    return PricingRuleItemGroupModel(
      name: json['name'],
      parent: json['parent'],
      itemGroup: json['item_group'],
      erpLastModified: json['erp_last_modified'],
      posxLastModified: json['posx_last_modified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'parent': parent,
      'item_group': itemGroup,
      'erp_last_modified': erpLastModified,
      'posx_last_modified': posxLastModified,
    };
  }
}

class PricingRuleBrandModel {
  String? name;
  String? parent;
  String? brand;
  String? erpLastModified;
  String? posxLastModified;

  PricingRuleBrandModel({
    this.name,
    this.parent,
    this.brand,
    this.erpLastModified,
    this.posxLastModified,
  });

  factory PricingRuleBrandModel.fromJson(Map<String, dynamic> json) {
    return PricingRuleBrandModel(
      name: json['name'],
      parent: json['parent'],
      brand: json['brand'],
      erpLastModified: json['erp_last_modified'],
      posxLastModified: json['posx_last_modified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'parent': parent,
      'brand': brand,
      'erp_last_modified': erpLastModified,
      'posx_last_modified': posxLastModified,
    };
  }
}