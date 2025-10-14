class POSProfileModel {
  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? owner;
  int? docstatus;
  int? idx;
  String? company;
  String? customer;
  String? country;
  int? disabled;
  String? warehouse;
  String? campaign;
  String? companyAddress;
  int? hideImages;
  int? hideUnavailableItems;
  int? autoAddItemToCart;
  int? validateStockOnSave;
  int? updateStock;
  int? ignorePricingRule;
  int? allowRateChange;
  int? allowDiscountChange;
  String? printFormat;
  String? letterHead;
  String? tcName;
  String? selectPrintHeading;
  String? sellingPriceList;
  String? currency;
  String? writeOffAccount;
  String? writeOffCostCenter;
  double? writeOffLimit;
  String? accountForChangeAmount;
  int? disableRoundedTotal;
  String? incomeAccount;
  String? expenseAccount;
  String? taxesAndCharges;
  String? taxCategory;
  String? applyDiscountOn;
  String? costCenter;
  String? nUserTags;
  String? nComments;
  String? nAssign;
  String? nLikedBy;

  POSProfileModel(
      {this.name,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.owner,
        this.docstatus,
        this.idx,
        this.company,
        this.customer,
        this.country,
        this.disabled,
        this.warehouse,
        this.campaign,
        this.companyAddress,
        this.hideImages,
        this.hideUnavailableItems,
        this.autoAddItemToCart,
        this.validateStockOnSave,
        this.updateStock,
        this.ignorePricingRule,
        this.allowRateChange,
        this.allowDiscountChange,
        this.printFormat,
        this.letterHead,
        this.tcName,
        this.selectPrintHeading,
        this.sellingPriceList,
        this.currency,
        this.writeOffAccount,
        this.writeOffCostCenter,
        this.writeOffLimit,
        this.accountForChangeAmount,
        this.disableRoundedTotal,
        this.incomeAccount,
        this.expenseAccount,
        this.taxesAndCharges,
        this.taxCategory,
        this.applyDiscountOn,
        this.costCenter,
        this.nUserTags,
        this.nComments,
        this.nAssign,
        this.nLikedBy});

  POSProfileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    owner = json['owner'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    company = json['company'];
    customer = json['customer'];
    country = json['country'];
    disabled = json['disabled'];
    warehouse = json['warehouse'];
    campaign = json['campaign'];
    companyAddress = json['company_address'];
    hideImages = json['hide_images'];
    hideUnavailableItems = json['hide_unavailable_items'];
    autoAddItemToCart = json['auto_add_item_to_cart'];
    validateStockOnSave = json['validate_stock_on_save'];
    updateStock = json['update_stock'];
    ignorePricingRule = json['ignore_pricing_rule'];
    allowRateChange = json['allow_rate_change'];
    allowDiscountChange = json['allow_discount_change'];
    printFormat = json['print_format'];
    letterHead = json['letter_head'];
    tcName = json['tc_name'];
    selectPrintHeading = json['select_print_heading'];
    sellingPriceList = json['selling_price_list'];
    currency = json['currency'];
    writeOffAccount = json['write_off_account'];
    writeOffCostCenter = json['write_off_cost_center'];
    writeOffLimit = json['write_off_limit'];
    accountForChangeAmount = json['account_for_change_amount'];
    disableRoundedTotal = json['disable_rounded_total'];
    incomeAccount = json['income_account'];
    expenseAccount = json['expense_account'];
    taxesAndCharges = json['taxes_and_charges'];
    taxCategory = json['tax_category'];
    applyDiscountOn = json['apply_discount_on'];
    costCenter = json['cost_center'];
    nUserTags = json['_user_tags'];
    nComments = json['_comments'];
    nAssign = json['_assign'];
    nLikedBy = json['_liked_by'];
  }

  static List<POSProfileModel> fromJsonArray(List<dynamic> dataList) {
    List<POSProfileModel> list =
    dataList.map<POSProfileModel>((a) => POSProfileModel.fromJson(a)).toList();
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['creation'] = creation;
    data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    data['owner'] = owner;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['company'] = company;
    data['customer'] = customer;
    data['country'] = country;
    data['disabled'] = disabled;
    data['warehouse'] = warehouse;
    data['campaign'] = campaign;
    data['company_address'] = companyAddress;
    data['hide_images'] = hideImages;
    data['hide_unavailable_items'] = hideUnavailableItems;
    data['auto_add_item_to_cart'] = autoAddItemToCart;
    data['validate_stock_on_save'] = validateStockOnSave;
    data['update_stock'] = updateStock;
    data['ignore_pricing_rule'] = ignorePricingRule;
    data['allow_rate_change'] = allowRateChange;
    data['allow_discount_change'] = allowDiscountChange;
    data['print_format'] = printFormat;
    data['letter_head'] = letterHead;
    data['tc_name'] = tcName;
    data['select_print_heading'] = selectPrintHeading;
    data['selling_price_list'] = sellingPriceList;
    data['currency'] = currency;
    data['write_off_account'] = writeOffAccount;
    data['write_off_cost_center'] = writeOffCostCenter;
    data['write_off_limit'] = writeOffLimit;
    data['account_for_change_amount'] = accountForChangeAmount;
    data['disable_rounded_total'] = disableRoundedTotal;
    data['income_account'] = incomeAccount;
    data['expense_account'] = expenseAccount;
    data['taxes_and_charges'] = taxesAndCharges;
    data['tax_category'] = taxCategory;
    data['apply_discount_on'] = applyDiscountOn;
    data['cost_center'] = costCenter;
    data['_user_tags'] = nUserTags;
    data['_comments'] = nComments;
    data['_assign'] = nAssign;
    data['_liked_by'] = nLikedBy;
    return data;
  }
}


class TempPOSProfileModel {
  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? owner;
  int? docstatus;
  int? idx;
  String? company;
  String? customer;
  String? country;
  int? disabled;
  String? warehouse;
  String? campaign;
  String? companyAddress;
  int? hideImages;
  int? hideUnavailableItems;
  int? autoAddItemToCart;
  int? validateStockOnSave;
  int? updateStock;
  int? ignorePricingRule;
  int? allowRateChange;
  int? allowDiscountChange;
  String? printFormat;
  String? letterHead;
  String? tcName;
  String? selectPrintHeading;
  String? sellingPriceList;
  String? currency;
  String? writeOffAccount;
  String? writeOffCostCenter;
  double? writeOffLimit;
  String? accountForChangeAmount;
  int? disableRoundedTotal;
  String? incomeAccount;
  String? expenseAccount;
  String? taxesAndCharges;
  String? taxCategory;
  String? applyDiscountOn;
  String? costCenter;
  String? nUserTags;
  String? nComments;
  String? nAssign;
  String? nLikedBy;

  TempPOSProfileModel(
      {this.name,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.owner,
        this.docstatus,
        this.idx,
        this.company,
        this.customer,
        this.country,
        this.disabled,
        this.warehouse,
        this.campaign,
        this.companyAddress,
        this.hideImages,
        this.hideUnavailableItems,
        this.autoAddItemToCart,
        this.validateStockOnSave,
        this.updateStock,
        this.ignorePricingRule,
        this.allowRateChange,
        this.allowDiscountChange,
        this.printFormat,
        this.letterHead,
        this.tcName,
        this.selectPrintHeading,
        this.sellingPriceList,
        this.currency,
        this.writeOffAccount,
        this.writeOffCostCenter,
        this.writeOffLimit,
        this.accountForChangeAmount,
        this.disableRoundedTotal,
        this.incomeAccount,
        this.expenseAccount,
        this.taxesAndCharges,
        this.taxCategory,
        this.applyDiscountOn,
        this.costCenter,
        this.nUserTags,
        this.nComments,
        this.nAssign,
        this.nLikedBy});

  TempPOSProfileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    owner = json['owner'];
    docstatus = json['docstatus'];
    idx = int.tryParse(json['id'].toString());
    company = json['company'];
    customer = json['customer'];
    country = json['country'];
    disabled = int.tryParse(json['disabled'].toString());
    warehouse = json['warehouse'];
    campaign = json['campaign'];
    companyAddress = json['company_address'];
    hideImages = json['hide_images'];
    hideUnavailableItems = json['hide_unavailable_items'];
    autoAddItemToCart = json['auto_add_item_to_cart'];
    validateStockOnSave = json['validate_stock_on_save'];
    updateStock = int.tryParse(json['update_stock'].toString());
    ignorePricingRule = json['ignore_pricing_rule'];
    allowRateChange = json['allow_rate_change'];
    allowDiscountChange = json['allow_discount_change'];
    printFormat = json['print_format'];
    letterHead = json['letter_head'];
    tcName = json['tc_name'];
    selectPrintHeading = json['select_print_heading'];
    sellingPriceList = json['selling_price_list'];
    currency = json['currency'];
    writeOffAccount = json['write_off_account'];
    writeOffCostCenter = json['write_off_cost_center'];
    writeOffLimit = json['write_off_limit'];
    accountForChangeAmount = json['account_for_change_amount'];
    disableRoundedTotal = json['disable_rounded_total'];
    incomeAccount = json['income_account'];
    expenseAccount = json['expense_account'];
    taxesAndCharges = json['taxes_and_charges'];
    taxCategory = json['tax_category'];
    applyDiscountOn = json['apply_discount_on'];
    costCenter = json['cost_center'];
    nUserTags = json['_user_tags'];
    nComments = json['_comments'];
    nAssign = json['_assign'];
    nLikedBy = json['_liked_by'];
  }

  static List<TempPOSProfileModel> fromJsonArray(List<dynamic> dataList) {
    List<TempPOSProfileModel> list =
    dataList.map<TempPOSProfileModel>((a) => TempPOSProfileModel.fromJson(a)).toList();
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['creation'] = creation;
    data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    data['owner'] = owner;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['company'] = company;
    data['customer'] = customer;
    data['country'] = country;
    data['disabled'] = disabled;
    data['warehouse'] = warehouse;
    data['campaign'] = campaign;
    data['company_address'] = companyAddress;
    data['hide_images'] = hideImages;
    data['hide_unavailable_items'] = hideUnavailableItems;
    data['auto_add_item_to_cart'] = autoAddItemToCart;
    data['validate_stock_on_save'] = validateStockOnSave;
    data['update_stock'] = updateStock;
    data['ignore_pricing_rule'] = ignorePricingRule;
    data['allow_rate_change'] = allowRateChange;
    data['allow_discount_change'] = allowDiscountChange;
    data['print_format'] = printFormat;
    data['letter_head'] = letterHead;
    data['tc_name'] = tcName;
    data['select_print_heading'] = selectPrintHeading;
    data['selling_price_list'] = sellingPriceList;
    data['currency'] = currency;
    data['write_off_account'] = writeOffAccount;
    data['write_off_cost_center'] = writeOffCostCenter;
    data['write_off_limit'] = writeOffLimit;
    data['account_for_change_amount'] = accountForChangeAmount;
    data['disable_rounded_total'] = disableRoundedTotal;
    data['income_account'] = incomeAccount;
    data['expense_account'] = expenseAccount;
    data['taxes_and_charges'] = taxesAndCharges;
    data['tax_category'] = taxCategory;
    data['apply_discount_on'] = applyDiscountOn;
    data['cost_center'] = costCenter;
    data['_user_tags'] = nUserTags;
    data['_comments'] = nComments;
    data['_assign'] = nAssign;
    data['_liked_by'] = nLikedBy;
    return data;
  }
}