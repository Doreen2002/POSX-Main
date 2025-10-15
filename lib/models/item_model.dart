import 'dart:convert';

String itemToJson(List<TempItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
List<TempItem> itemFromJson(String str) =>
    List<TempItem>.from(json.decode(str).map((x) => TempItem.fromJson(x)));

class TempItem {
  String name;
  String itemCode;
  String? creation;
  String? modifiedBy;
  String? owner;
  dynamic docstatus;
  dynamic idx;
  String? namingSeries;
  String? itemName;
  String? itemGroup;
  String? stockUom;
  dynamic disabled;
  dynamic allowAlternativeItem;
  dynamic isStockItem;
  dynamic hasVariants;
  dynamic includeItemInManufacturing;
  dynamic openingStock;
  dynamic customVATInclusive;
  dynamic vatExclusiveRate;
  dynamic standardRate;
  dynamic vatValue;
  dynamic autoCreateAssets;
  dynamic isGroupedAsset;
  String? assetCategory;
  String? assetNamingSeries;
  dynamic overDeliveryReceiptAllowance;
  dynamic overBillingAllowance;
  String? image;
  String? description;
  String? brand;
  dynamic shelfLifeInDays;
  String? endOfLife;
  String? defaultMaterialRequestType;
  String? valuationMethod;
  double? valuationRate;  // Cost price from ERPNext Bin for below-cost validation
  String? warrantyPeriod;
  dynamic weightPerUnit;
  String? weightUom;
  dynamic allowNegativeStock;
  dynamic hasBatchNo;
  dynamic createNewBatch;
  String? batchNumberSeries;
  dynamic hasExpiryDate;
  dynamic retainSample;
  dynamic sampleQuantity;
  dynamic hasSerialNo;
  String? serialNoSeries;
  String? variantOf;
  String? variantBasedOn;
  dynamic enableDeferredExpense;
  dynamic noOfMonthsExp;
  dynamic enableDeferredRevenue;
  dynamic noOfMonths;
  String? purchaseUom;
  double? minOrderQty;
  double? safetyStock;
  dynamic isPurchaseItem;
  dynamic leadTimeDays;
  dynamic lastPurchaseRate;
  dynamic isCustomerProvidedItem;
  String? customer;
  String? defaultWarehouse;
  dynamic deliveredBySupplier;
  String? countryOfOrigin;
  String? customsTariffNumber;
  String? salesUom;
  dynamic grantCommission;
  dynamic isSalesItem;
  dynamic maxDiscount;
  dynamic inspectionRequiredBeforePurchase;
  String? qualityInspectionTemplate;
  dynamic inspectionRequiredBeforeDelivery;
  dynamic isSubContractedItem;
  String? defaultBom;
  String? customerCode;
  String? defaultItemManufacturer;
  String? defaultManufacturerPartNo;
  dynamic publishedInWebsite;
  dynamic totalProjectedQty;
  String? nUserTags;
  String? nComments;
  String? nAssign;
  String? nLikedBy;
  dynamic onePieceWeight;
  String? packagingMaterialWarehouse;
  dynamic upperLimit;
  dynamic lowerLimit;
  String? typeOfRoad;
  String? materialGrade;
  String? gstHsnCode;
  dynamic isNilExempt;
  dynamic isNonGst;
  dynamic isIneligibleForItc;
  dynamic toolItem;
  String? customPackingMaterialType;
  dynamic customCalibrationInDays;
  String? dbk;
  String? surfaceFinish;
  String? drgNo;
  String? revNo;
  String? materialGrades;
  String? euDeclaration;
  String? internalTestCertificate;
  String? defaultPackagingTemplate;
  String? remarks;
  dynamic incoming;
  dynamic inprocess;
  String? qualityInspectionTemplate1;
  dynamic itemvat;
  String? warehouse;
  String? qualityInspectionTemplate2;
  String? batchId;
  String? serialNo;
  String? barcode;
  dynamic batchQty;
  List<dynamic>? taxes;
  List<dynamic>? itemDefaults;
  List<dynamic>? itemBarcods;
  
  // PLU for barcode lookup
  String? plu;

  TempItem({
    required this.name,
    required this.itemCode,
    this.creation,
    this.modifiedBy,
    this.owner,
    this.docstatus,
    this.idx,
    this.namingSeries,
    this.itemName,
    this.itemGroup,
    this.stockUom,
    this.disabled,
    this.allowAlternativeItem,
    this.isStockItem,
    this.hasVariants,
    this.includeItemInManufacturing,
    this.openingStock,
    this.customVATInclusive,
    this.vatExclusiveRate,
    this.standardRate,
    this.vatValue,
    this.autoCreateAssets,
    this.isGroupedAsset,
    this.assetCategory,
    this.assetNamingSeries,
    this.overDeliveryReceiptAllowance,
    this.overBillingAllowance,
    this.image,
    this.description,
    this.brand,
    this.shelfLifeInDays,
    this.endOfLife,
    this.defaultMaterialRequestType,
    this.valuationMethod,
    this.valuationRate,
    this.warrantyPeriod,
    this.weightPerUnit,
    this.weightUom,
    this.allowNegativeStock,
    this.hasBatchNo,
    this.createNewBatch,
    this.batchNumberSeries,
    this.hasExpiryDate,
    this.retainSample,
    this.sampleQuantity,
    this.hasSerialNo,
    this.serialNoSeries,
    this.variantOf,
    this.variantBasedOn,
    this.enableDeferredExpense,
    this.noOfMonthsExp,
    this.enableDeferredRevenue,
    this.noOfMonths,
    this.purchaseUom,
    this.minOrderQty,
    this.safetyStock,
    this.isPurchaseItem,
    this.leadTimeDays,
    this.lastPurchaseRate,
    this.isCustomerProvidedItem,
    this.customer,
    this.defaultWarehouse,
    this.deliveredBySupplier,
    this.countryOfOrigin,
    this.customsTariffNumber,
    this.salesUom,
    this.grantCommission,
    this.isSalesItem,
    this.maxDiscount,
    this.inspectionRequiredBeforePurchase,
    this.qualityInspectionTemplate,
    this.inspectionRequiredBeforeDelivery,
    this.isSubContractedItem,
    this.defaultBom,
    this.customerCode,
    this.defaultItemManufacturer,
    this.defaultManufacturerPartNo,
    this.publishedInWebsite,
    this.totalProjectedQty,
    this.nUserTags,
    this.nComments,
    this.nAssign,
    this.nLikedBy,
    this.onePieceWeight,
    this.packagingMaterialWarehouse,
    this.upperLimit,
    this.lowerLimit,
    this.typeOfRoad,
    this.materialGrade,
    this.gstHsnCode,
    this.isNilExempt,
    this.isNonGst,
    this.isIneligibleForItc,
    this.toolItem,
    this.customPackingMaterialType,
    this.customCalibrationInDays,
    this.dbk,
    this.surfaceFinish,
    this.drgNo,
    this.revNo,
    this.materialGrades,
    this.euDeclaration,
    this.internalTestCertificate,
    this.defaultPackagingTemplate,
    this.remarks,
    this.incoming,
    this.inprocess,
    this.qualityInspectionTemplate1,
    this.itemvat,
    this.warehouse,
    this.qualityInspectionTemplate2,
    this.batchId,
    this.serialNo,
    this.barcode,
    this.batchQty,
    this.taxes,
    this.itemDefaults,
    this.itemBarcods,
    // PLU for barcode lookup
    this.plu,
  });

  factory TempItem.fromJson(Map<String, dynamic> json) {
    return TempItem(
      name: json['name'] as String,
      itemCode: json['item_code'] as String,
      creation: json['creation'] as String?,
      modifiedBy: json['modified_by'] as String?,
      owner: json['owner'] as String?,
      docstatus: json['docstatus'],
      idx: json['idx'],
      namingSeries: json['naming_series'] as String?,
      itemName: json['item_name'] as String?,
      itemGroup: json['item_group'] as String?,
      stockUom: json['stock_uom'] as String?,
      disabled: json['disabled'],
      allowAlternativeItem: json['allow_alternative_item'],
      isStockItem: json['is_stock_item'],
      hasVariants: json['has_variants'],
      includeItemInManufacturing: json['include_item_in_manufacturing'],
      openingStock: json['opening_stock'],
      customVATInclusive: json['custom_is_vat_inclusive'],
      vatExclusiveRate: json['vat_exclusive_rate'],
      standardRate: json['standard_rate'],
      vatValue: json['vat_value'],
      autoCreateAssets: json['auto_create_assets'],
      isGroupedAsset: json['is_grouped_asset'],
      assetCategory: json['asset_category'] as String?,
      assetNamingSeries: json['asset_naming_series'] as String?,
      overDeliveryReceiptAllowance: json['over_delivery_receipt_allowance'],
      overBillingAllowance: json['over_billing_allowance'],
      image: json['image'] as String?,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      shelfLifeInDays: json['shelf_life_in_days'],
      endOfLife: json['end_of_life'] as String?,
      defaultMaterialRequestType: json['default_material_request_type'] as String?,
      valuationMethod: json['valuation_method'] as String?,
      valuationRate: json['valuation_rate']?.toDouble(),
      warrantyPeriod: json['warranty_period'] as String?,
      weightPerUnit: json['weight_per_unit'],
      weightUom: json['weight_uom'] as String?,
      allowNegativeStock: json['allow_negative_stock'],
      hasBatchNo: json['has_batch_no'],
      createNewBatch: json['create_new_batch'],
      batchNumberSeries: json['batch_number_series'] as String?,
      hasExpiryDate: json['has_expiry_date'],
      retainSample: json['retain_sample'],
      sampleQuantity: json['sample_quantity'],
      hasSerialNo: json['has_serial_no'],
      serialNoSeries: json['serial_no_series'] as String?,
      variantOf: json['variant_of'] as String?,
      variantBasedOn: json['variant_based_on'] as String?,
      enableDeferredExpense: json['enable_deferred_expense'],
      noOfMonthsExp: json['no_of_months_exp'],
      enableDeferredRevenue: json['enable_deferred_revenue'],
      noOfMonths: json['no_of_months'],
      purchaseUom: json['purchase_uom'] as String?,
      minOrderQty: (json['min_order_qty'] as num?)?.toDouble(),
      safetyStock: (json['safety_stock'] as num?)?.toDouble(),
      isPurchaseItem: json['is_purchase_item'],
      leadTimeDays: json['lead_time_days'],
      lastPurchaseRate: json['last_purchase_rate'],
      isCustomerProvidedItem: json['is_customer_provided_item'],
      customer: json['customer'] as String?,
      defaultWarehouse: json['default_warehouse'] as String?,
      deliveredBySupplier: json['delivered_by_supplier'],
      countryOfOrigin: json['country_of_origin'] as String?,
      customsTariffNumber: json['customs_tariff_number'] as String?,
      salesUom: json['sales_uom'] as String?,
      grantCommission: json['grant_commission'],
      isSalesItem: json['is_sales_item'],
      maxDiscount: json['max_discount'],
      inspectionRequiredBeforePurchase: json['inspection_required_before_purchase'],
      qualityInspectionTemplate: json['quality_inspection_template'] as String?,
      inspectionRequiredBeforeDelivery: json['inspection_required_before_delivery'],
      isSubContractedItem: json['is_sub_contracted_item'],
      defaultBom: json['default_bom'] as String?,
      customerCode: json['customer_code'] as String?,
      defaultItemManufacturer: json['default_item_manufacturer'] as String?,
      defaultManufacturerPartNo: json['default_manufacturer_part_no'] as String?,
      publishedInWebsite: json['published_in_website'],
      totalProjectedQty: json['total_projected_qty'],
      nUserTags: json['_user_tags'] as String?,
      nComments: json['_comments'] as String?,
      nAssign: json['_assign'] as String?,
      nLikedBy: json['_liked_by'] as String?,
      onePieceWeight: json['one_piece_weight'],
      packagingMaterialWarehouse: json['packaging_material_warehouse'] as String?,
      upperLimit: json['upper_limit'],
      lowerLimit: json['lower_limit'],
      typeOfRoad: json['type_of_road'] as String?,
      materialGrade: json['material_grade'] as String?,
      gstHsnCode: json['gst_hsn_code'] as String?,
      isNilExempt: json['is_nil_exempt'],
      isNonGst: json['is_non_gst'],
      isIneligibleForItc: json['is_ineligible_for_itc'],
      toolItem: json['tool_item'],
      customPackingMaterialType: json['custom_packing_material_type'] as String?,
      customCalibrationInDays: json['custom_calibration_in_days'],
      dbk: json['dbk'] as String?,
      surfaceFinish: json['surface_finish'] as String?,
      drgNo: json['drg_no'] as String?,
      revNo: json['rev_no'] as String?,
      materialGrades: json['material_grades'] as String?,
      euDeclaration: json['eu_declaration'] as String?,
      internalTestCertificate: json['internal_test_certificate'] as String?,
      defaultPackagingTemplate: json['default_packaging_template'] as String?,
      remarks: json['remarks'] as String?,
      incoming: json['incoming'],
      inprocess: json['inprocess'],
      qualityInspectionTemplate1: json['quality_inspection_template_1'] as String?,
      itemvat: json['itemvat'],
      warehouse: json['warehouse'] as String?,
      qualityInspectionTemplate2: json['quality_inspection_template_2'] as String?,
      batchId: json['batch_id'] as String?,
      serialNo: json['serial_no'] as String?,
      barcode: json['barcode'] as String?,
      batchQty: json['batch_qty'],
      taxes: json['taxes'] != null
          ? List<TempTaxes>.from(json['taxes'].map((x) => TempTaxes.fromJson(x)))
          : null,
      itemDefaults: json['item_defaults'] != null
          ? List<TempItemDefaults>.from(json['item_defaults'].map((x) => TempItemDefaults.fromJson(x)))
          : null,
      itemBarcods: json['barcodes'] != null
          ? List<TempItemBarcodes>.from(json['barcodes'].map((x) => TempItemBarcodes.fromJson(x)))
          : null,
      // PLU for barcode lookup
      plu: json['plu'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['item_code'] = itemCode;
    data['creation'] = creation;
    data['modified_by'] = modifiedBy;
    data['owner'] = owner;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['naming_series'] = namingSeries;
    data['item_name'] = itemName;
    data['item_group'] = itemGroup;
    data['stock_uom'] = stockUom;
    data['disabled'] = disabled;
    data['allow_alternative_item'] = allowAlternativeItem;
    data['is_stock_item'] = isStockItem;
    data['has_variants'] = hasVariants;
    data['include_item_in_manufacturing'] = includeItemInManufacturing;
    data['opening_stock'] = openingStock;
    data['custom_is_vat_inclusive'] = customVATInclusive;
    data['vat_exclusive_rate'] = vatExclusiveRate;
    data['standard_rate'] = standardRate;
    data['vat_value'] = vatValue;
    data['auto_create_assets'] = autoCreateAssets;
    data['is_grouped_asset'] = isGroupedAsset;
    data['asset_category'] = assetCategory;
    data['asset_naming_series'] = assetNamingSeries;
    data['over_delivery_receipt_allowance'] = overDeliveryReceiptAllowance;
    data['over_billing_allowance'] = overBillingAllowance;
    data['image'] = image;
    data['description'] = description;
    data['brand'] = brand;
    data['shelf_life_in_days'] = shelfLifeInDays;
    data['end_of_life'] = endOfLife;
    data['default_material_request_type'] = defaultMaterialRequestType;
    data['valuation_method'] = valuationMethod;
    data['valuation_rate'] = valuationRate;
    data['warranty_period'] = warrantyPeriod;
    data['weight_per_unit'] = weightPerUnit;
    data['weight_uom'] = weightUom;
    data['allow_negative_stock'] = allowNegativeStock;
    data['has_batch_no'] = hasBatchNo;
    data['create_new_batch'] = createNewBatch;
    data['batch_number_series'] = batchNumberSeries;
    data['has_expiry_date'] = hasExpiryDate;
    data['retain_sample'] = retainSample;
    data['sample_quantity'] = sampleQuantity;
    data['has_serial_no'] = hasSerialNo;
    data['serial_no_series'] = serialNoSeries;
    data['variant_of'] = variantOf;
    data['variant_based_on'] = variantBasedOn;
    data['enable_deferred_expense'] = enableDeferredExpense;
    data['no_of_months_exp'] = noOfMonthsExp;
    data['enable_deferred_revenue'] = enableDeferredRevenue;
    data['no_of_months'] = noOfMonths;
    data['purchase_uom'] = purchaseUom;
    data['min_order_qty'] = minOrderQty;
    data['safety_stock'] = safetyStock;
    data['is_purchase_item'] = isPurchaseItem;
    data['lead_time_days'] = leadTimeDays;
    data['last_purchase_rate'] = lastPurchaseRate;
    data['is_customer_provided_item'] = isCustomerProvidedItem;
    data['customer'] = customer;
    data['default_warehouse'] = defaultWarehouse;
    data['delivered_by_supplier'] = deliveredBySupplier;
    data['country_of_origin'] = countryOfOrigin;
    data['customs_tariff_number'] = customsTariffNumber;
    data['sales_uom'] = salesUom;
    data['grant_commission'] = grantCommission;
    data['is_sales_item'] = isSalesItem;
    data['max_discount'] = maxDiscount;
    data['inspection_required_before_purchase'] = inspectionRequiredBeforePurchase;
    data['quality_inspection_template'] = qualityInspectionTemplate;
    data['inspection_required_before_delivery'] = inspectionRequiredBeforeDelivery;
    data['is_sub_contracted_item'] = isSubContractedItem;
    data['default_bom'] = defaultBom;
    data['customer_code'] = customerCode;
    data['default_item_manufacturer'] = defaultItemManufacturer;
    data['default_manufacturer_part_no'] = defaultManufacturerPartNo;
    data['published_in_website'] = publishedInWebsite;
    data['total_projected_qty'] = totalProjectedQty;
    data['_user_tags'] = nUserTags;
    data['_comments'] = nComments;
    data['_assign'] = nAssign;
    data['_liked_by'] = nLikedBy;
    data['one_piece_weight'] = onePieceWeight;
    data['packaging_material_warehouse'] = packagingMaterialWarehouse;
    data['upper_limit'] = upperLimit;
    data['lower_limit'] = lowerLimit;
    data['type_of_road'] = typeOfRoad;
    data['material_grade'] = materialGrade;
    data['gst_hsn_code'] = gstHsnCode;
    data['is_nil_exempt'] = isNilExempt;
    data['is_non_gst'] = isNonGst;
    data['is_ineligible_for_itc'] = isIneligibleForItc;
    data['tool_item'] = toolItem;
    data['custom_packing_material_type'] = customPackingMaterialType;
    data['custom_calibration_in_days'] = customCalibrationInDays;
    data['dbk'] = dbk;
    data['surface_finish'] = surfaceFinish;
    data['drg_no'] = drgNo;
    data['rev_no'] = revNo;
    data['material_grades'] = materialGrades;
    data['eu_declaration'] = euDeclaration;
    data['internal_test_certificate'] = internalTestCertificate;
    data['default_packaging_template'] = defaultPackagingTemplate;
    data['remarks'] = remarks;
    data['incoming'] = incoming;
    data['inprocess'] = inprocess;
    data['quality_inspection_template_1'] = qualityInspectionTemplate1;
    data['batch_id'] = batchId;
    data['serial_no'] = serialNo;
    data['barcode'] = barcode;
    data['batch_qty'] = batchQty;
    data['itemvat'] = itemvat;
    data['quality_inspection_template_2'] = qualityInspectionTemplate2;

    if (taxes != null) {
      data['taxes'] = taxes!.map((v) => v.toJson()).toList();
    }
    if (itemDefaults != null) {
      data['item_defaults'] = itemDefaults!.map((v) => v.toJson()).toList();
    }
    if (itemBarcods != null) {
      data['barcodes'] = itemBarcods!.map((v) => v.toJson()).toList();
    }
    
    // PLU for barcode lookup
    data['plu'] = plu;
    
    return data;
  }
}


class TempTaxes {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? itemTaxTemplate;
  String? taxCategory;
  String? validFrom;
  double? minimumNetRate;
  double? maximumNetRate;
  String? parent;
  String? parentfield;
  String? parenttype;
  String? doctype;

  TempTaxes(
      {this.name,
        this.owner,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.docstatus,
        this.idx,
        this.itemTaxTemplate,
        this.taxCategory,
        this.validFrom,
        this.minimumNetRate,
        this.maximumNetRate,
        this.parent,
        this.parentfield,
        this.parenttype,
        this.doctype});

  TempTaxes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    itemTaxTemplate = json['item_tax_template'];
    taxCategory = json['tax_category'];
    validFrom = json['valid_from'];
    minimumNetRate = json['minimum_net_rate'];
    maximumNetRate = json['maximum_net_rate'];
    parent = json['parent'];
    parentfield = json['parentfield'];
    parenttype = json['parenttype'];
    doctype = json['doctype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['owner'] = owner;
    data['creation'] = creation;
    data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['item_tax_template'] = itemTaxTemplate;
    data['tax_category'] = taxCategory;
    data['valid_from'] = validFrom;
    data['minimum_net_rate'] = minimumNetRate;
    data['maximum_net_rate'] = maximumNetRate;
    data['parent'] = parent;
    data['parentfield'] = parentfield;
    data['parenttype'] = parenttype;
    data['doctype'] = doctype;
    return data;
  }
}
class TempItemDefaults {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? company;
  String? defaultWarehouse;
  String? incomeAccount;
  String? parent;
  String? parentfield;
  String? parenttype;
  String? doctype;

  TempItemDefaults(
      {this.name,
        this.owner,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.docstatus,
        this.idx,
        this.company,
        this.defaultWarehouse,
        this.incomeAccount,
        this.parent,
        this.parentfield,
        this.parenttype,
        this.doctype});

  TempItemDefaults.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    company = json['company'];
    defaultWarehouse = json['default_warehouse'];
    incomeAccount = json['income_account'];
    parent = json['parent'];
    parentfield = json['parentfield'];
    parenttype = json['parenttype'];
    doctype = json['doctype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['owner'] = owner;
    data['creation'] = creation;
    data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['company'] = company;
    data['default_warehouse'] = defaultWarehouse;
    data['income_account'] = incomeAccount;
    data['parent'] = parent;
    data['parentfield'] = parentfield;
    data['parenttype'] = parenttype;
    data['doctype'] = doctype;
    return data;
  }
}

class TempItemBarcodes {
  String? name;
  String? owner;
  String? creation;
  String? modified;
  String? modifiedBy;
  int? docstatus;
  int? idx;
  String? barcode;
  String? itemCode;
  String? barcodeType;
  String? uom;
  String? parent;
  String? parentfield;
  String? parenttype;
  String? doctype;

  TempItemBarcodes(
      {this.name,
        this.owner,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.docstatus,
        this.idx,
        this.barcode,
        this.itemCode,
        this.barcodeType,
        this.uom,
        this.parent,
        this.parentfield,
        this.parenttype,
        this.doctype});

  TempItemBarcodes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    owner = json['owner'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    barcode = json['barcode'];
    itemCode = json['item_code'];
    barcodeType = json['barcode_type'];
    uom = json['uom'];
    parent = json['parent'];
    parentfield = json['parentfield'];
    parenttype = json['parenttype'];
    doctype = json['doctype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['owner'] = owner;
    data['creation'] = creation;
    data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['barcode'] = barcode;
    data['item_code'] = itemCode;
    data['barcode_type'] = barcodeType;
    data['uom'] = uom;
    data['parent'] = parent;
    data['parentfield'] = parentfield;
    data['parenttype'] = parenttype;
    data['doctype'] = doctype;
    return data;
  }
}