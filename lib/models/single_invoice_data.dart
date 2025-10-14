import 'dart:core';

class SingleInvoiceListModel {
  String? id;
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? title;
  String? namingSeries;
  String? customer;
  String? customerName;
  String? posProfile;
  String? consolidatedInvoice;
  int? isPos;
  int? isReturn;
  int? updateBilledAmountInSalesOrder;
  int? updateBilledAmountInDeliveryNote;
  String? company;
  String? postingDate;
  String? postingTime;
  int? setPostingTime;
  String? dueDate;
  String? territory;
  String? currency;
  double? conversionRate;
  String? sellingPriceList;
  String? priceListCurrency;
  double? plcConversionRate;
  int? ignorePricingRule;
  String? setWarehouse;
  int? updateStock;
  double? totalBillingAmount;
  double? totalQty;
  double? baseTotal;
  double? baseNetTotal;
  double? total;
  double? netTotal;
  double? totalNetWeight;
  String? taxesAndCharges;
  String? taxCategory;
  double? baseTotalTaxesAndCharges;
  double? totalTaxesAndCharges;
  int? loyaltyPoints;
  double? loyaltyAmount;
  int? redeemLoyaltyPoints;
  String? applyDiscountOn;
  double? baseDiscountAmount;
  double? additionalDiscountPercentage;
  double? discountAmount;
  double? baseGrandTotal;
  double? baseRoundingAdjustment;
  double? baseRoundedTotal;
  String? baseInWords;
  double? grandTotal;
  double? roundingAdjustment;
  double? roundedTotal;
  String? inWords;
  double? totalAdvance;
  double? outstandingAmount;
  int? allocateAdvancesAutomatically;
  double? basePaidAmount;
  double? paidAmount;
  double? baseChangeAmount;
  double? changeAmount;
  String? accountForChangeAmount;
  double? writeOffAmount;
  double? baseWriteOffAmount;
  int? writeOffOutstandingAmountAutomatically;
  String? writeOffAccount;
  String? writeOffCostCenter;
  int? groupSameItems;
  String? language;
  String? customerGroup;
  int? isDiscounted;
  String? status;
  String? messageStatus;
  String? debitTo;
  String? partyAccountCurrency;
  String? isOpening;
  double? amountEligibleForCommission;
  double? commissionRate;
  double? totalCommission;
  double? vat;
  double? discount;
  String? doctype;
  List<Items>? items;
  List<Null>? pricingRules;
  List<Null>? timesheets;
  List<Null>? salesTeam;
  List<Null>? taxes;
  List<Null>? paymentSchedule;
  List<Null>? advances;
  List<Null>? packedItems;
  List<Payments>? payments;

  SingleInvoiceListModel({this.id,this.name, this.owner, this.creation,this.messageStatus, this.modified, this.modifiedBy, this.docstatus, this.idx, this.title, this.namingSeries, this.customer, this.customerName, this.posProfile, this.consolidatedInvoice, this.isPos, this.isReturn, this.updateBilledAmountInSalesOrder, this.updateBilledAmountInDeliveryNote, this.company, this.postingDate, this.postingTime, this.setPostingTime, this.dueDate, this.territory, this.currency, this.conversionRate, this.sellingPriceList, this.priceListCurrency, this.plcConversionRate, this.ignorePricingRule, this.setWarehouse, this.updateStock, this.totalBillingAmount, this.totalQty, this.baseTotal, this.baseNetTotal, this.total, this.netTotal, this.totalNetWeight, this.taxesAndCharges, this.taxCategory, this.baseTotalTaxesAndCharges, this.totalTaxesAndCharges, this.loyaltyPoints, this.loyaltyAmount, this.redeemLoyaltyPoints, this.applyDiscountOn, this.baseDiscountAmount, this.additionalDiscountPercentage, this.discountAmount, this.baseGrandTotal, this.baseRoundingAdjustment, this.baseRoundedTotal, this.baseInWords, this.grandTotal, this.roundingAdjustment, this.roundedTotal, this.inWords, this.totalAdvance, this.outstandingAmount, this.allocateAdvancesAutomatically, this.basePaidAmount, this.paidAmount,this.vat,this.discount, this.baseChangeAmount, this.changeAmount, this.accountForChangeAmount, this.writeOffAmount, this.baseWriteOffAmount, this.writeOffOutstandingAmountAutomatically, this.writeOffAccount, this.writeOffCostCenter, this.groupSameItems, this.language, this.customerGroup, this.isDiscounted, this.status, this.debitTo, this.partyAccountCurrency, this.isOpening, this.amountEligibleForCommission, this.commissionRate, this.totalCommission, this.doctype, this.items, this.pricingRules, this.timesheets, this.salesTeam, this.taxes, this.paymentSchedule, this.advances, this.packedItems, this.payments});

  SingleInvoiceListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    title = json['title'];
    namingSeries = json['naming_series'];
    customer = json['customer'];
    customerName = json['customer_name'];
    posProfile = json['pos_profile'];
    consolidatedInvoice = json['consolidated_invoice'];
    isPos = json['is_pos'];
    isReturn = json['is_return'];
    updateBilledAmountInSalesOrder = json['update_billed_amount_in_sales_order'];
    updateBilledAmountInDeliveryNote = json['update_billed_amount_in_delivery_note'];
    company = json['company'];
    postingDate = json['posting_date'];
    postingTime = json['posting_time'];
    setPostingTime = json['set_posting_time'];
    dueDate = json['due_date'];
    territory = json['territory'];
    currency = json['currency'];
    conversionRate = json['conversion_rate'];
    sellingPriceList = json['selling_price_list'];
    priceListCurrency = json['price_list_currency'];
    plcConversionRate = json['plc_conversion_rate'];
    ignorePricingRule = json['ignore_pricing_rule'];
    setWarehouse = json['set_warehouse'];
    updateStock = json['update_stock'];
    totalBillingAmount = json['total_billing_amount'];
    totalQty = json['total_qty'];
    baseTotal = json['base_total'];
    baseNetTotal = json['base_net_total'];
    total = json['total'];
    netTotal = json['net_total'];
    totalNetWeight = json['total_net_weight'];
    taxesAndCharges = json['taxes_and_charges'];
    taxCategory = json['tax_category'];
    baseTotalTaxesAndCharges = json['base_total_taxes_and_charges'];
    totalTaxesAndCharges = json['total_taxes_and_charges'];
    loyaltyPoints = json['loyalty_points'];
    loyaltyAmount = json['loyalty_amount'];
    redeemLoyaltyPoints = json['redeem_loyalty_points'];
    applyDiscountOn = json['apply_discount_on'];
    baseDiscountAmount = json['base_discount_amount'];
    additionalDiscountPercentage = json['additional_discount_percentage'];
    discountAmount = json['discount_amount'];
    baseGrandTotal = json['base_grand_total'];
    baseRoundingAdjustment = json['base_rounding_adjustment'];
    baseRoundedTotal = json['base_rounded_total'];
    baseInWords = json['base_in_words'];
    grandTotal = json['grand_total'];
    roundingAdjustment = json['rounding_adjustment'];
    roundedTotal = json['rounded_total'];
    inWords = json['in_words'];
    totalAdvance = json['total_advance'];
    outstandingAmount = json['outstanding_amount'];
    allocateAdvancesAutomatically = json['allocate_advances_automatically'];
    basePaidAmount = json['base_paid_amount'];
    paidAmount = json['paid_amount'];
    baseChangeAmount = json['base_change_amount'];
    changeAmount = json['change_amount'];
    accountForChangeAmount = json['account_for_change_amount'];
    writeOffAmount = json['write_off_amount'];
    baseWriteOffAmount = json['base_write_off_amount'];
    writeOffOutstandingAmountAutomatically = json['write_off_outstanding_amount_automatically'];
    writeOffAccount = json['write_off_account'];
    writeOffCostCenter = json['write_off_cost_center'];
    groupSameItems = json['group_same_items'];
    language = json['language'];
    customerGroup = json['customer_group'];
    isDiscounted = json['is_discounted'];
    status = json['status'];
    messageStatus = json['messageStatus'];
    debitTo = json['debit_to'];
    partyAccountCurrency = json['party_account_currency'];
    isOpening = json['is_opening'];
    amountEligibleForCommission = json['amount_eligible_for_commission'];
    commissionRate = json['commission_rate'];
    totalCommission = json['total_commission'];
    vat = json['vat'];
    discount = json['discount'];
    doctype = json['doctype'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) { items!.add(Items.fromJson(v)); });
    }
    if (json['payments'] != null) {
      payments = <Payments>[];
      json['payments'].forEach((v) { payments!.add(Payments.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['owner'] = owner;
    data['creation'] = creation;
    data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['title'] = title;
    data['naming_series'] = namingSeries;
    data['customer'] = customer;
    data['customer_name'] = customerName;
    data['pos_profile'] = posProfile;
    data['consolidated_invoice'] = consolidatedInvoice;
    data['is_pos'] = isPos;
    data['is_return'] = isReturn;
    data['update_billed_amount_in_sales_order'] = updateBilledAmountInSalesOrder;
    data['update_billed_amount_in_delivery_note'] = updateBilledAmountInDeliveryNote;
    data['company'] = company;
    data['posting_date'] = postingDate;
    data['posting_time'] = postingTime;
    data['set_posting_time'] = setPostingTime;
    data['due_date'] = dueDate;
    data['territory'] = territory;
    data['currency'] = currency;
    data['conversion_rate'] = conversionRate;
    data['selling_price_list'] = sellingPriceList;
    data['price_list_currency'] = priceListCurrency;
    data['plc_conversion_rate'] = plcConversionRate;
    data['ignore_pricing_rule'] = ignorePricingRule;
    data['set_warehouse'] = setWarehouse;
    data['update_stock'] = updateStock;
    data['total_billing_amount'] = totalBillingAmount;
    data['total_qty'] = totalQty;
    data['base_total'] = baseTotal;
    data['base_net_total'] = baseNetTotal;
    data['total'] = total;
    data['net_total'] = netTotal;
    data['total_net_weight'] = totalNetWeight;
    data['taxes_and_charges'] = taxesAndCharges;
    data['tax_category'] = taxCategory;
    data['base_total_taxes_and_charges'] = baseTotalTaxesAndCharges;
    data['total_taxes_and_charges'] = totalTaxesAndCharges;
    data['loyalty_points'] = loyaltyPoints;
    data['loyalty_amount'] = loyaltyAmount;
    data['redeem_loyalty_points'] = redeemLoyaltyPoints;
    data['apply_discount_on'] = applyDiscountOn;
    data['base_discount_amount'] = baseDiscountAmount;
    data['additional_discount_percentage'] = additionalDiscountPercentage;
    data['discount_amount'] = discountAmount;
    data['base_grand_total'] = baseGrandTotal;
    data['base_rounding_adjustment'] = baseRoundingAdjustment;
    data['base_rounded_total'] = baseRoundedTotal;
    data['base_in_words'] = baseInWords;
    data['grand_total'] = grandTotal;
    data['rounding_adjustment'] = roundingAdjustment;
    data['rounded_total'] = roundedTotal;
    data['in_words'] = inWords;
    data['total_advance'] = totalAdvance;
    data['outstanding_amount'] = outstandingAmount;
    data['allocate_advances_automatically'] = allocateAdvancesAutomatically;
    data['base_paid_amount'] = basePaidAmount;
    data['paid_amount'] = paidAmount;
    data['base_change_amount'] = baseChangeAmount;
    data['change_amount'] = changeAmount;
    data['account_for_change_amount'] = accountForChangeAmount;
    data['write_off_amount'] = writeOffAmount;
    data['base_write_off_amount'] = baseWriteOffAmount;
    data['write_off_outstanding_amount_automatically'] = writeOffOutstandingAmountAutomatically;
    data['write_off_account'] = writeOffAccount;
    data['write_off_cost_center'] = writeOffCostCenter;
    data['group_same_items'] = groupSameItems;
    data['language'] = language;
    data['customer_group'] = customerGroup;
    data['is_discounted'] = isDiscounted;
    data['status'] = status;
    data['messageStatus'] = messageStatus;
    data['debit_to'] = debitTo;
    data['party_account_currency'] = partyAccountCurrency;
    data['is_opening'] = isOpening;
    data['amount_eligible_for_commission'] = amountEligibleForCommission;
    data['commission_rate'] = commissionRate;
    data['total_commission'] = totalCommission;
    data['vat'] = vat;
    data['discount'] = discount;
    data['doctype'] = doctype;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    if (payments != null) {
      data['payments'] = payments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? name;
  // String? owner;
  // String? creation;
  // String? modified;
  // String? modifiedBy;
  // int? docstatus;
  // int? idx;
  // String? barcode;
  // int? hasItemScanned;
  String? itemCode;
  String? itemName;
  // String? description;
  String? itemGroup;
  String? image;
  int? qty;
  String? stockUom;
  // String? uom;
  // double? conversionFactor;
  // double? stockQty;
  double? priceListRate;
  double? basePriceListRate;
  // String? marginType;
  // double? marginRateOrAmount;
  // double? rateWithMargin;
  dynamic discountPercentage;
  double? discountAmount;
  // double? baseRateWithMargin;
  double? rate;
  int? vatValue;
  double? totalWithVat;
  double? totalWithoutVat;
  double? amount;
  // double? baseRate;
  // double? baseAmount;
  // String? pricingRules;
  // int? isFreeItem;
  // double? grantCommission;
  double? netRate;
  double? netAmount;
  // double? baseNetRate;
  // double? baseNetAmount;
  // double? deliveredBySupplier;
  // String? incomeAccount;
  // double? isFixedAsset;
  // String? expenseAccount;
  // double? enableDeferredRevenue;
  // double? weightPerUnit;
  // double? totalWeight;
  // String? warehouse;
  String? batchNo;
  // int? allowZeroValuationRate;
  String? serialNo;
  String? itemTaxRate;
  dynamic customVATInclusive;
  
  // Pricing rule fields
  String? appliedPricingRuleId;
  String? appliedPricingRuleTitle;
  String? discountSource;
  // double? actualBatchQty;
  // double? actualQty;
  // double? deliveredQty;
  // String? costCenter;
  // int? pageBreak;
  // String? parent;
  // String? parentfield;
  // String? parenttype;
  // String? doctype;

  Items({
    this.id,
    this.name,
    // this.owner,
    // this.creation,
    // this.modified,
    // this.modifiedBy,
    // this.docstatus,
    // this.idx,
    // this.barcode,
    // this.hasItemScanned,
    this.itemCode,
    this.itemName,
    // this.description,
    this.itemGroup,
    this.image,
    this.qty,
    this.stockUom,
    // this.uom,
    // this.conversionFactor,
    // this.stockQty,
    this.priceListRate,
    this.basePriceListRate,
    // this.marginType,
    // this.marginRateOrAmount,
    // this.rateWithMargin,
    this.discountPercentage,
    this.discountAmount,
    // this.baseRateWithMargin,
    this.rate,
    this.vatValue,
    this.totalWithVat,
    this.totalWithoutVat,
    this.amount,
    this.customVATInclusive,
    // this.baseRate,
    // this.baseAmount,
    // this.pricingRules,
    // this.isFreeItem,
    // this.grantCommission,
    this.netRate,
    this.netAmount,
    // this.baseNetRate,
    // this.baseNetAmount,
    // this.deliveredBySupplier,
    // this.incomeAccount,
    // this.isFixedAsset,
    // this.expenseAccount,
    // this.enableDeferredRevenue,
    // this.weightPerUnit,
    // this.totalWeight,
    // this.warehouse,
    this.batchNo,
    // this.allowZeroValuationRate,
    this.serialNo,
    this.itemTaxRate,
    this.appliedPricingRuleId,
    this.appliedPricingRuleTitle,
    this.discountSource,
    // this.actualBatchQty,
    // this.actualQty,
    // this.deliveredQty,
    // this.costCenter,
    // this.pageBreak,
    // this.parent,
    // this.parentfield,
    // this.parenttype,
    // this.doctype
  });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'] ?? '');
    // id = json['id'];
    name = json['name'];
    // owner = json['owner'];
    // creation = json['creation'];
    // modified = json['modified'];
    // modifiedBy = json['modified_by'];
    // docstatus = json['docstatus'];
    // idx = json['idx'];
    // barcode = json['barcode'];
    // hasItemScanned = json['has_item_scanned'];
    itemCode = json['item_code'];
    itemName = json['item_name'];
    // description = json['description'];
    itemGroup = json['item_group'];
    image = json['image'];
    qty = json['qty'];
    stockUom = json['stock_uom'];
    // uom = json['uom'];
    // conversionFactor = json['conversion_factor'];
    // stockQty = json['stock_qty'];
    priceListRate = json['price_list_rate'];
    basePriceListRate = json['base_price_list_rate'];
    // marginType = json['margin_type'];
    // marginRateOrAmount = json['margin_rate_or_amount'];
    // rateWithMargin = json['rate_with_margin'];
    discountPercentage = json['discount_percentage'];
    discountAmount = json['discount_amount'];
    // baseRateWithMargin = json['base_rate_with_margin'];
    rate = json['rate'];
    vatValue = json['vat_value'];
    totalWithVat = json['total_with_vat'];
    totalWithoutVat = json['total_without_vat'];
    amount = json['amount'];
    customVATInclusive = json['custom_is_vat_inclusive'] ?? 0;
    // baseRate = json['base_rate'];
    // baseAmount = json['base_amount'];
    // pricingRules = json['pricing_rules'];
    // isFreeItem = json['is_free_item'];
    // grantCommission = json['grant_commission'];
    netRate = json['net_rate'];
    netAmount = json['net_amount'];
    // baseNetRate = json['base_net_rate'];
    // baseNetAmount = json['base_net_amount'];
    // deliveredBySupplier = json['delivered_by_supplier'];
    // incomeAccount = json['income_account'];
    // isFixedAsset = json['is_fixed_asset'];
    // expenseAccount = json['expense_account'];
    // enableDeferredRevenue = json['enable_deferred_revenue'];
    // weightPerUnit = json['weight_per_unit'];
    // totalWeight = json['total_weight'];
    // warehouse = json['warehouse'];
    batchNo = json['batch_no'];
    // allowZeroValuationRate = json['allow_zero_valuation_rate'];
    serialNo = json['serial_no'];
    itemTaxRate = json['item_tax_rate'];
    appliedPricingRuleId = json['applied_pricing_rule_id'];
    appliedPricingRuleTitle = json['applied_pricing_rule_title'];
    discountSource = json['discount_source'];
    // actualBatchQty = json['actual_batch_qty'];
    // actualQty = json['actual_qty'];
    // deliveredQty = json['delivered_qty'];
    // costCenter = json['cost_center'];
    // pageBreak = json['page_break'];
    // parent = json['parent'];
    // parentfield = json['parentfield'];
    // parenttype = json['parenttype'];
    // doctype = json['doctype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    // data['owner'] = this.owner;
    // data['creation'] = this.creation;
    // data['modified'] = this.modified;
    // data['modified_by'] = this.modifiedBy;
    // data['docstatus'] = this.docstatus;
    // data['idx'] = this.idx;
    // data['barcode'] = this.barcode;
    // data['has_item_scanned'] = this.hasItemScanned;
    data['item_code'] = itemCode;
    data['item_name'] = itemName;
    // data['description'] = this.description;
    data['item_group'] = itemGroup;
    data['image'] = image;
    data['qty'] = qty;
    data['stock_uom'] = stockUom;
    // data['uom'] = this.uom;
    // data['conversion_factor'] = this.conversionFactor;
    // data['stock_qty'] = this.stockQty;
    data['price_list_rate'] = priceListRate;
    data['base_price_list_rate'] = basePriceListRate;
    // data['margin_type'] = this.marginType;
    // data['margin_rate_or_amount'] = this.marginRateOrAmount;
    // data['rate_with_margin'] = this.rateWithMargin;
    data['discount_percentage'] = discountPercentage;
    data['discount_amount'] = discountAmount;
    // data['base_rate_with_margin'] = this.baseRateWithMargin;
    data['rate'] = rate;
    data['vat_value'] = totalWithVat;
    data['total_with_vat'] = totalWithVat;
    data['total_without_vat'] = totalWithoutVat;
    data['amount'] = amount;
    // data['base_rate'] = this.baseRate;
    // data['base_amount'] = this.baseAmount;
    // data['pricing_rules'] = this.pricingRules;
    // data['is_free_item'] = this.isFreeItem;
    // data['grant_commission'] = this.grantCommission;
    data['net_rate'] = netRate;
    data['net_amount'] = netAmount;
    // data['base_net_rate'] = this.baseNetRate;
    // data['base_net_amount'] = this.baseNetAmount;
    // data['delivered_by_supplier'] = this.deliveredBySupplier;
    // data['income_account'] = this.incomeAccount;
    // data['is_fixed_asset'] = this.isFixedAsset;
    // data['expense_account'] = this.expenseAccount;
    // data['enable_deferred_revenue'] = this.enableDeferredRevenue;
    // data['weight_per_unit'] = this.weightPerUnit;
    // data['total_weight'] = this.totalWeight;
    // data['warehouse'] = this.warehouse;
    data['batch_no'] = batchNo;
    // data['allow_zero_valuation_rate'] = this.allowZeroValuationRate;
    data['serial_no'] = serialNo;
    data['item_tax_rate'] = itemTaxRate;
    data['custom_is_vat_inclusive'] = customVATInclusive ?? 0;
    data['applied_pricing_rule_id'] = appliedPricingRuleId;
    data['applied_pricing_rule_title'] = appliedPricingRuleTitle;
    data['discount_source'] = discountSource;
    // data['actual_batch_qty'] = this.actualBatchQty;
    // data['actual_qty'] = this.actualQty;
    // data['delivered_qty'] = this.deliveredQty;
    // data['cost_center'] = this.costCenter;
    // data['page_break'] = this.pageBreak;
    // data['parent'] = this.parent;
    // data['parentfield'] = this.parentfield;
    // data['parenttype'] = this.parenttype;
    // data['doctype'] = this.doctype;
    return data;
  }
}

class Payments {
  String? name;
  // String? owner;
  // String? creation;
  // String? modified;
  // String? modifiedBy;
  // int? docstatus;
  // int? idx;
  // int? default1;
  String? modeOfPayment;
  double? amount;
  String? openingEntry;
  // String? account;
  String? type;
  double? baseAmount;
  // String? parent;
  // String? parentfield;
  // String? parenttype;
  // String? doctype;

  Payments({this.name,
    // this.owner, this.creation, this.modified, this.modifiedBy, this.docstatus, this.idx,
    // this.default1,
    this.type, this.modeOfPayment, this.amount,this.openingEntry, this.baseAmount
    // this.account, this.type, this.baseAmount, this.parent, this.parentfield, this.parenttype, this.doctype
  });

Payments.fromJson(Map<String, dynamic> json) {
name = json['name'];
// owner = json['owner'];
// creation = json['creation'];
// modified = json['modified'];
// modifiedBy = json['modified_by'];
// docstatus = json['docstatus'];
// idx = json['idx'];
// default1 = json['default'];
modeOfPayment = json['mode_of_payment'];
amount = json['amount'];
openingEntry = json['opening_name'];
// account = json['account'];
type = json['type'];
baseAmount = json['base_amount'];
// parent = json['parent'];
// parentfield = json['parentfield'];
// parenttype = json['parenttype'];
// doctype = json['doctype'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = <String, dynamic>{};
data['name'] = name;
// data['owner'] = this.owner;
// data['creation'] = this.creation;
// data['modified'] = this.modified;
// data['modified_by'] = this.modifiedBy;
// data['docstatus'] = this.docstatus;
// data['idx'] = this.idx;
// data['default'] = this.default1;
data['mode_of_payment'] = modeOfPayment;
data['amount'] = amount;
data['opening_name'] = openingEntry;
// data['account'] = this.account;
data['type'] = this.type;
data['base_amount'] = this.baseAmount;
// data['parent'] = this.parent;
// data['parentfield'] = this.parentfield;
// data['parenttype'] = this.parenttype;
// data['doctype'] = this.doctype;
return data;
}
}

class SyncPayments {
  String? id;
  // String? owner;
  // String? creation;
  // String? modified;
  // String? modifiedBy;
  // int? docstatus;
  // int? idx;
  // int? default1;
  String? modeOfPayment;
  double? amount;
  // String? account;
  String? type;
  double? baseAmount;
  // String? parent;
  // String? parentfield;
  // String? parenttype;
  // String? doctype;

  SyncPayments({this.id,
    // this.owner, this.creation, this.modified, this.modifiedBy, this.docstatus, this.idx,
    // this.default1,
    this.modeOfPayment, this.amount,this.type, this.baseAmount,
    // this.account, this.type, this.baseAmount, this.parent, this.parentfield, this.parenttype, this.doctype
  });

  SyncPayments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
// owner = json['owner'];
// creation = json['creation'];
// modified = json['modified'];
// modifiedBy = json['modified_by'];
// docstatus = json['docstatus'];
// idx = json['idx'];
// default1 = json['default'];
    modeOfPayment = json['mode_of_payment'];
    amount = json['amount'];
// account = json['account'];
type = json['type'];
baseAmount = json['base_amount'];
// parent = json['parent'];
// parentfield = json['parentfield'];
// parenttype = json['parenttype'];
// doctype = json['doctype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
// data['owner'] = this.owner;
// data['creation'] = this.creation;
// data['modified'] = this.modified;
// data['modified_by'] = this.modifiedBy;
// data['docstatus'] = this.docstatus;
// data['idx'] = this.idx;
// data['default'] = this.default1;
    data['mode_of_payment'] = modeOfPayment;
    data['amount'] = amount;
// data['account'] = this.account;
data['type'] = this.type;
data['base_amount'] = this.baseAmount;
// data['parent'] = this.parent;
// data['parentfield'] = this.parentfield;
// data['parenttype'] = this.parenttype;
// data['doctype'] = this.doctype;
    return data;
  }
}