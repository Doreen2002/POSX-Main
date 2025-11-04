class AddToCartModel{
  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? owner;
  int? docstatus;
  int? idx;
  String? namingSeries;
  String? itemCode;
  String? itemName;
  String? itemGroup;
  String? stockUom;
  int? disabled;
  int? allowAlternativeItem;
  int? isStockItem;
  int? hasVariants;
  int? includeItemInManufacturing;
  double? openingStock;
  double? itemTotal; // Used for line total (rate × qty)
  double? newRate;
  double? standardRate;
  int? autoCreateAssets;
  int? isGroupedAsset;
  String? assetCategory;
  String? assetNamingSeries;
  double? overDeliveryReceiptAllowance;
  double? overBillingAllowance;
  String? image;
  String? description;
  String? brand;
  int? shelfLifeInDays;
  String? endOfLife;
  String? defaultMaterialRequestType;
  String? valuationMethod;
  String? warrantyPeriod;
  double? weightPerUnit;
  String? weightUom;
  int? allowNegativeStock;
  int? hasBatchNo;
  int? createNewBatch;
  String? batchNumberSeries;
  int? hasExpiryDate;
  int? retainSample;
  int? sampleQuantity;
  int? hasSerialNo;
  String? serialNoSeries;
  String? variantOf;
  String? variantBasedOn;
  int? enableDeferredExpense;
  int? noOfMonthsExp;
  int? enableDeferredRevenue;
  int? noOfMonths;
  String? purchaseUom;
  double? minOrderQty;
  double? safetyStock;
  int? isPurchaseItem;
  int? leadTimeDays;
  double? lastPurchaseRate;
  int? isCustomerProvidedItem;
  String? customer;
  int? deliveredBySupplier;
  String? countryOfOrigin;
  String? customsTariffNumber;
  String? salesUom;
  int? grantCommission;
  int? isSalesItem;
  double? maxDiscount;
  int? inspectionRequiredBeforePurchase;
  String? qualityInspectionTemplate;
  int? inspectionRequiredBeforeDelivery;
  int? isSubContractedItem;
  String? defaultBom;
  String? customerCode;
  String? defaultItemManufacturer;
  String? defaultManufacturerPartNo;
  int? publishedInWebsite;
  double? totalProjectedQty;
  String? nUserTags;
  String? nComments;
  String? nAssign;
  String? nLikedBy;
  double? onePieceWeight;
  String? packagingMaterialWarehouse;
  double? upperLimit;
  double? lowerLimit;
  String? typeOfRoad;
  String? materialGrade;
  String? gstHsnCode;
  int? isNilExempt;
  int? isNonGst;
  int? isIneligibleForItc;
  int? toolItem;
  String? customPackingMaterialType;
  int? customCalibrationInDays;
  String? dbk;
  String? surfaceFinish;
  String? drgNo;
  String? revNo;
  String? materialGrades;
  String? euDeclaration;
  String? internalTestCertificate;
  String? defaultPackagingTemplate;
  String? remarks;
  int? incoming;
  int? inprocess;
  String? qualityInspectionTemplate1;
  int? itemvat;
  String? qualityInspectionTemplate2;
  int? qty;

  AddToCartModel({
    this.name, this.creation,this.qty, this.modified, this.modifiedBy, this.owner, this.docstatus, this.idx, this.namingSeries, this.itemCode, this.itemName, this.itemGroup, this.stockUom, this.disabled, this.allowAlternativeItem, this.isStockItem, this.hasVariants, this.includeItemInManufacturing, this.openingStock, this.itemTotal, this.standardRate, this.autoCreateAssets, this.isGroupedAsset, this.assetCategory, this.assetNamingSeries, this.overDeliveryReceiptAllowance, this.overBillingAllowance, this.image, this.description, this.brand, this.shelfLifeInDays, this.endOfLife, this.defaultMaterialRequestType, this.valuationMethod, this.warrantyPeriod, this.weightPerUnit, this.weightUom, this.allowNegativeStock, this.hasBatchNo, this.createNewBatch, this.batchNumberSeries, this.hasExpiryDate, this.retainSample, this.sampleQuantity, this.hasSerialNo, this.serialNoSeries, this.variantOf, this.variantBasedOn, this.enableDeferredExpense, this.noOfMonthsExp, this.enableDeferredRevenue, this.noOfMonths, this.purchaseUom, this.minOrderQty, this.safetyStock, this.isPurchaseItem, this.leadTimeDays, this.lastPurchaseRate, this.isCustomerProvidedItem, this.customer, this.deliveredBySupplier, this.countryOfOrigin, this.customsTariffNumber, this.salesUom, this.grantCommission, this.isSalesItem, this.maxDiscount, this.inspectionRequiredBeforePurchase, this.qualityInspectionTemplate, this.inspectionRequiredBeforeDelivery, this.isSubContractedItem, this.defaultBom, this.customerCode, this.defaultItemManufacturer, this.defaultManufacturerPartNo, this.publishedInWebsite, this.totalProjectedQty, this.nUserTags, this.nComments, this.nAssign, this.nLikedBy, this.onePieceWeight, this.packagingMaterialWarehouse, this.upperLimit, this.lowerLimit, this.typeOfRoad, this.materialGrade, this.gstHsnCode, this.isNilExempt, this.isNonGst, this.isIneligibleForItc, this.toolItem, this.customPackingMaterialType, this.customCalibrationInDays, this.dbk, this.surfaceFinish, this.drgNo, this.revNo, this.materialGrades, this.euDeclaration, this.internalTestCertificate, this.defaultPackagingTemplate, this.remarks, this.incoming, this.inprocess, this.qualityInspectionTemplate1, this.itemvat, this.qualityInspectionTemplate2, this.newRate
  });
  AddToCartModel.fromMap(Map<dynamic, dynamic>json):
        name = json['name'],
  creation = json['creation'],
  modified = json['modified'],
  modifiedBy = json['modified_by'],
  owner = json['owner'],
  docstatus = json['docstatus'],
  idx = json['idx'],
  namingSeries = json['naming_series'],
  itemCode = json['item_code'],
  itemName = json['item_name'],
  itemGroup = json['item_group'],
  stockUom = json['stock_uom'],
  disabled = json['disabled'],
  allowAlternativeItem = json['allow_alternative_item'],
  isStockItem = json['is_stock_item'],
  hasVariants = json['has_variants'],
  includeItemInManufacturing = json['include_item_in_manufacturing'],
  openingStock = json['opening_stock'],
  itemTotal = json['standard_rate'],
  newRate = json['new_rate'],
  standardRate = json['standard_rate'],
  autoCreateAssets = json['auto_create_assets'],
  isGroupedAsset = json['is_grouped_asset'],
  assetCategory = json['asset_category'],
  assetNamingSeries = json['asset_naming_series'],
  overDeliveryReceiptAllowance = json['over_delivery_receipt_allowance'],
  overBillingAllowance = json['over_billing_allowance'],
  image = json['image'],
  description = json['description'],
  brand = json['brand'],
  shelfLifeInDays = json['shelf_life_in_days'],
  endOfLife = json['end_of_life'],
  defaultMaterialRequestType = json['default_material_request_type'],
  valuationMethod = json['valuation_method'],
  warrantyPeriod = json['warranty_period'],
  weightPerUnit = json['weight_per_unit'],
  weightUom = json['weight_uom'],
  allowNegativeStock = json['allow_negative_stock'],
  hasBatchNo = json['has_batch_no'],
  createNewBatch = json['create_new_batch'],
  batchNumberSeries = json['batch_number_seres'],
  hasExpiryDate = json['has_expiry_date'],
  retainSample = json['retain_sample'],
  sampleQuantity = json['sample_quantity'],
  hasSerialNo = json['has_serial_no'],
  serialNoSeries = json['serial_no_series'],
  variantOf = json['variant_of'],
  variantBasedOn = json['variant_based_on'],
  enableDeferredExpense = json['enable_deferred_expense'],
  noOfMonthsExp = json['no_of_months_exp'],
  enableDeferredRevenue = json['enable_deferred_revenue'],
  noOfMonths = json['no_of_months'],
  purchaseUom = json['purchase_uom'],
  minOrderQty = json['min_order_qty'],
  safetyStock = json['safety_stock'],
  isPurchaseItem = json['is_purchase_item'],
  leadTimeDays = json['lead_time_days'],
  lastPurchaseRate = json['last_purchase_rate'],
  isCustomerProvidedItem = json['is_customer_provided_item'],
  customer = json['customer'],
  deliveredBySupplier = json['delivered_by_supplier'],
  countryOfOrigin = json['country_of_origin'],
  customsTariffNumber = json['customs_tariff_number'],
  salesUom = json['sales_uom'],
  grantCommission = json['grant_commission'],
  isSalesItem = json['is_sales_item'],
  maxDiscount = json['max_discount'],
  inspectionRequiredBeforePurchase = json['inspection_required_before_purchase'],
  qualityInspectionTemplate = json['quality_inspection_template'],
  inspectionRequiredBeforeDelivery = json['inspection_required_before_delivery'],
  isSubContractedItem = json['is_sub_contracted_item'],
  defaultBom = json['default_bom'],
  customerCode = json['customer_code'],
  defaultItemManufacturer = json['default_item_manufacturer'],
  defaultManufacturerPartNo = json['default_manufacturer_part_no'],
  publishedInWebsite = json['published_in_website'],
  totalProjectedQty = json['total_projected_qty'],
  nUserTags = json['_user_tags'],
  nComments = json['_comments'],
  nAssign = json['_assign'],
  nLikedBy = json['_liked_by'],
  onePieceWeight = json['one_piece_weight'],
  packagingMaterialWarehouse = json['packaging_material_warehouse'],
  upperLimit = json['upper_limit'],
  lowerLimit = json['lower_limit'],
  typeOfRoad = json['type_of_road'],
  materialGrade = json['material_grade'],
  gstHsnCode = json['gst_hsn_code'],
  isNilExempt = json['is_nil_exempt'],
  isNonGst = json['is_non_gst'],
  isIneligibleForItc = json['is_ineligible_for_itc'],
  toolItem = json['tool_item'],
  customPackingMaterialType = json['custom_packing_material_type'],
  customCalibrationInDays = json['custom_calibration_in_days'],
  dbk = json['dbk'],
  surfaceFinish = json['surface_finish'],
  drgNo = json['drg_no'],
  revNo = json['rev_no'],
  materialGrades = json['material_grades'],
  euDeclaration = json['eu_declaration'],
  internalTestCertificate = json['internal_test_certificate'],
  defaultPackagingTemplate = json['default_packaging_template'],
  remarks = json['remarks'],
  incoming = json['incoming'],
  inprocess = json['inprocess'],
  qualityInspectionTemplate1 = json['quality_inspection_template_1'],
  itemvat = json['itemvat'],
        qty = json['qty'],
  qualityInspectionTemplate2 = json['quality_inspection_template_2'];
  Map<String, Object?> toMap(){
    return{
      // 'id' :id,
    'name' : name,
    'creation' : creation,
    'modified' : modified,
    'modified_by':modifiedBy,
    'owner':owner,
    'docstatus':docstatus,
    'idx':idx,
    'naming_series':namingSeries,
    'item_code':itemCode,
    'item_name':itemName,
    'item_group':itemGroup,
    'stock_uom':stockUom,
    'disabled':disabled,
    'allow_alternative_item':allowAlternativeItem,
    'is_stock_item':isStockItem,
    'has_variants':hasVariants,
    'include_item_in_manufacturing':includeItemInManufacturing,
    'opening_stock':openingStock,
    'item_total':itemTotal,
    'new_rate':newRate,
    'standard_rate':standardRate,
    'auto_create_assets':autoCreateAssets,
    'is_grouped_asset':isGroupedAsset,
    'asset_category':assetCategory,
    'asset_naming_series':assetNamingSeries,
    'over_delivery_receipt_allowance':overDeliveryReceiptAllowance,
    'over_billing_allowance':overBillingAllowance,
    'image':image,
    'description':description,
    'brand':brand,
    'shelf_life_in_days':shelfLifeInDays,
    'end_of_life':endOfLife,
    'default_material_request_type':defaultMaterialRequestType,
    'valuation_method':valuationMethod,
    'warranty_period':warrantyPeriod,
    'weight_per_unit':weightPerUnit,
    'weight_uom':weightUom,
    'allow_negative_stock':allowNegativeStock,
    'has_batch_no':hasBatchNo,
    'create_new_batch':createNewBatch,
    'batch_number_series' :batchNumberSeries,
    'has_expiry_date':hasExpiryDate,
    'retain_sample':retainSample,
    'sample_quantity':sampleQuantity,
    'has_serial_no':hasSerialNo,
    'serial_no_series':serialNoSeries,
    'variant_of':variantOf,
    'variant_based_on':variantBasedOn,
    'enable_deferred_expense':enableDeferredExpense,
    'no_of_months_exp':noOfMonthsExp,
    'enable_deferred_revenue':enableDeferredRevenue,
    'no_of_months':noOfMonths,
    'purchase_uom':purchaseUom,
    'min_order_qty':minOrderQty,
    'safety_stock':safetyStock,
    'is_purchase_item':isPurchaseItem,
    'lead_time_days':leadTimeDays,
    'last_purchase_rate':lastPurchaseRate,
    'is_customer_provided_item':isCustomerProvidedItem,
    'customer':customer,
    'delivered_by_supplier':deliveredBySupplier,
    'country_of_origin':countryOfOrigin,
    'customs_tariff_number':customsTariffNumber,
    'sales_uom':salesUom,
    'grant_commission':grantCommission,
    'is_sales_item':isSalesItem,
    'max_discount':maxDiscount,
    'inspection_required_before_purchase':inspectionRequiredBeforePurchase,
    'quality_inspection_template':qualityInspectionTemplate,
    'inspection_required_before_delivery':inspectionRequiredBeforeDelivery,
    'is_sub_contracted_item':isSubContractedItem,
    'default_bom':defaultBom,
    'customer_code':customerCode,
    'default_item_manufacturer':defaultItemManufacturer,
    'default_manufacturer_part_no':defaultManufacturerPartNo,
    'published_in_website':publishedInWebsite,
    'total_projected_qty':totalProjectedQty,
    '_user_tags':nUserTags,
    '_comments':nComments,
    '_assign':nAssign,
    '_liked_by':nLikedBy,
    'one_piece_weight':onePieceWeight,
    'packaging_material_warehouse':packagingMaterialWarehouse,
    'upper_limit':upperLimit,
    'lower_limit':lowerLimit,
    'type_of_road':typeOfRoad,
    'material_grade':materialGrade,
    'gst_hsn_code':gstHsnCode,
    'is_nil_exempt':isNilExempt,
    'is_non_gst':isNonGst,
    'is_ineligible_for_itc':isIneligibleForItc,
    'tool_item':toolItem,
    'custom_packing_material_type':customPackingMaterialType,
    'custom_calibration_in_days':customCalibrationInDays,
    'dbk':dbk,
    'surface_finish':surfaceFinish,
    'drg_no':drgNo,
    'rev_no':revNo,
    'material_grades':materialGrades,
    'eu_declaration':euDeclaration,
    'internal_test_certificate':internalTestCertificate,
    'default_packaging_template':defaultPackagingTemplate,
    'remarks':remarks,
    'incoming':incoming,
    'inprocess' : inprocess,
    'quality_inspection_template_1': qualityInspectionTemplate1,
    'itemvat' : itemvat,
    'quality_inspection_template_2' : qualityInspectionTemplate2,
      'qty' : qty,
    };
  }
}

class CartModel{
  int? id;
  String? itemCode;
  String? itemName;
  double? rate;
  double? itemRate;
  int? qty;
  String? image;

  CartModel({
    this.id,
    this.itemCode,
    this.itemName,
    this.rate,
    this.itemRate,
    this.qty,
    this.image
  });
  CartModel.fromMap(Map<dynamic, dynamic>res):
  id = res['id'],
        itemCode = res['itemCode'],
        itemName = res['itemName'],
        rate = res['rate'],
        itemRate = res['itemRate'],
        qty = res['qty'],
        image = res['image'];
  Map<String, Object?> toMap(){
    return{
      'id' :id,
      'itemCode' : itemCode,
      'itemName' : itemName,
      'rate' : rate,
      'itemRate' : itemRate,
      'qty' : qty,
      'image' : image,
    };
  }
}




// class AddToCartModel{
//   int? id;
//   String? itemCode;
//   String? itemName;
//   double? rate;
//   double? itemRate;
//   int? qty;
//   String? image;
//
//   AddToCartModel({
//     this.id,
//     this.itemCode,
//     this.itemName,
//     this.rate,
//     this.itemRate,
//     this.qty,
//     this.image
//   });
//   AddToCartModel.fromMap(Map<dynamic, dynamic>res):
//         id = res['id'],
//         itemCode = res['itemCode'],
//         itemName = res['itemName'],
//         rate = res['rate'],
//         itemRate = res['itemRate'],
//         qty = res['qty'],
//         image = res['image'];
//   Map<String, Object?> toMap(){
//     return{
//       'id' :id,
//       'itemCode' : itemCode,
//       'itemName' : itemName,
//       'rate' : rate,
//       'itemRate' : itemRate,
//       'qty' : qty,
//       'image' : image,
//     };
//   }
// }

// class CartModel{
//   int? id;
//   String? itemCode;
//   String? itemName;
//   double? rate;
//   double? itemRate;
//   int? qty;
//   String? image;
//
//   CartModel({
//     this.id,
//     this.itemCode,
//     this.itemName,
//     this.rate,
//     this.itemRate,
//     this.qty,
//     this.image
//   });
//   CartModel.fromMap(Map<dynamic, dynamic>res):
//         id = res['id'],
//         itemCode = res['itemCode'],
//         itemName = res['itemName'],
//         rate = res['rate'],
//         itemRate = res['itemRate'],
//         qty = res['qty'],
//         image = res['image'];
//   Map<String, Object?> toMap(){
//     return{
//       'id' :id,
//       'itemCode' : itemCode,
//       'itemName' : itemName,
//       'rate' : rate,
//       'itemRate' : itemRate,
//       'qty' : qty,
//       'image' : image,
//     };
//   }
// }