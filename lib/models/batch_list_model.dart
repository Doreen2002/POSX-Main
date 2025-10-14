class BatchListModel {
  String? name;
  String? creation;
  // String? modified;
  String? modifiedBy;
  String? owner;
  int? docstatus;
  int? idx;
  int? disabled;
  int? useBatchwiseValuation;
  String batchId;
  String? item;
  String? itemName;
  String? image;
  String? parentBatch;
  String? manufacturingDate;
  double? batchQty;
  String? stockUom;
  String? expiryDate;
  String? supplier;
  String? referenceDoctype;
  String? referenceName;
  String? description;
  double? qtyToProduce;
  double? producedQty;
  String? nUserTags;
  String? nComments;
  String? nAssign;
  String? nLikedBy;

  BatchListModel(
      {this.name,
        this.creation,
        // this.modified,
        this.modifiedBy,
        this.owner,
        this.docstatus,
        this.idx,
        this.disabled,
        this.useBatchwiseValuation,
       required this.batchId,
        this.item,
        this.itemName,
        this.image,
        this.parentBatch,
        this.manufacturingDate,
        this.batchQty,
        this.stockUom,
        this.expiryDate,
        this.supplier,
        this.referenceDoctype,
        this.referenceName,
        this.description,
        this.qtyToProduce,
        this.producedQty,
        this.nUserTags,
        this.nComments,
        this.nAssign,
        this.nLikedBy});

  factory BatchListModel.fromJson(Map<String, dynamic> json) {
    return BatchListModel(
      name: json['name'],
      creation: json['creation'],
      // modified: json['modified'],
      modifiedBy: json['modified_by'],
      owner: json['owner'],
      docstatus: json['docstatus'],
      idx: json['idx'],
      disabled: json['disabled'],
      useBatchwiseValuation: json['use_batchwise_valuation'],
      batchId: json['batch_id'] as String,
      item: json['item'],
      itemName: json['item_name'],
      image: json['image'],
      parentBatch: json['parent_batch'],
      manufacturingDate: json['manufacturing_date'],
      batchQty: (json['batch_qty'] is int)
          ? (json['batch_qty'] as int).toDouble()
          : json['batch_qty'] as double?,
      stockUom: json['stock_uom'],
      expiryDate: json['expiry_date'],
      supplier: json['supplier'],
      referenceDoctype: json['reference_doctype'],
      referenceName: json['reference_name'],
      description: json['description'],
      qtyToProduce: (json['qty_to_produce'] is int)
          ? (json['qty_to_produce'] as int).toDouble()
          : json['qty_to_produce'] as double?,
      producedQty: (json['produced_qty'] is int)
          ? (json['produced_qty'] as int).toDouble()
          : json['produced_qty'] as double?,
      nUserTags: json['_user_tags'],
      nComments: json['_comments'],
      nAssign: json['_assign'],
      nLikedBy: json['_liked_by'],
    );
   
  }

  static List<BatchListModel> fromJsonArray(List<dynamic> dataList) {
    List<BatchListModel> list =
    dataList.map<BatchListModel>((a) => BatchListModel.fromJson(a)).toList();
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['creation'] = creation;
    // data['modified'] = modified;
    data['modified_by'] = modifiedBy;
    data['owner'] = owner;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['disabled'] = disabled;
    data['use_batchwise_valuation'] = useBatchwiseValuation;
    data['batch_id'] = batchId;
    data['item'] = item;
    data['item_name'] = itemName;
    data['image'] = image;
    data['parent_batch'] = parentBatch;
    data['manufacturing_date'] = manufacturingDate;
    data['batch_qty'] = batchQty;
    data['stock_uom'] = stockUom;
    data['expiry_date'] = expiryDate;
    data['supplier'] = supplier;
    data['reference_doctype'] = referenceDoctype;
    data['reference_name'] = referenceName;
    data['description'] = description;
    data['qty_to_produce'] = qtyToProduce;
    data['produced_qty'] = producedQty;
    data['_user_tags'] = nUserTags;
    data['_comments'] = nComments;
    data['_assign'] = nAssign;
    data['_liked_by'] = nLikedBy;
    return data;
  }
}


class TempBatchListModel {
  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? owner;
  int? docstatus;
  int? idx;
  int? disabled;
  int? useBatchwiseValuation;
  String? batchId;
  String? item;
  String? itemName;
  String? image;
  String? parentBatch;
  String? manufacturingDate;
  int? batchQty;
  String? stockUom;
  String? expiryDate;
  String? supplier;
  String? referenceDoctype;
  String? referenceName;
  String? description;
  double? qtyToProduce;
  double? producedQty;
  String? nUserTags;
  String? nComments;
  String? nAssign;
  String? nLikedBy;

  TempBatchListModel(
      {this.name,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.owner,
        this.docstatus,
        this.idx,
        this.disabled,
        this.useBatchwiseValuation,
        this.batchId,
        this.item,
        this.itemName,
        this.image,
        this.parentBatch,
        this.manufacturingDate,
        this.batchQty,
        this.stockUom,
        this.expiryDate,
        this.supplier,
        this.referenceDoctype,
        this.referenceName,
        this.description,
        this.qtyToProduce,
        this.producedQty,
        this.nUserTags,
        this.nComments,
        this.nAssign,
        this.nLikedBy});

  TempBatchListModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    owner = json['owner'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    disabled = json['disabled'];
    useBatchwiseValuation = json['use_batchwise_valuation'];
    batchId = json['batch_id'];
    item = json['item'];
    itemName = json['item_name'];
    image = json['image'];
    parentBatch = json['parent_batch'];
    manufacturingDate = json['manufacturing_date'];
    batchQty = json['batch_qty'];
    stockUom = json['stock_uom'];
    expiryDate = json['expiry_date'];
    supplier = json['supplier'];
    referenceDoctype = json['reference_doctype'];
    referenceName = json['reference_name'];
    description = json['description'];
    qtyToProduce = json['qty_to_produce'];
    producedQty = json['produced_qty'];
    nUserTags = json['_user_tags'];
    nComments = json['_comments'];
    nAssign = json['_assign'];
    nLikedBy = json['_liked_by'];
  }

  static List<TempBatchListModel> fromJsonArray(List<dynamic> dataList) {
    List<TempBatchListModel> list =
    dataList.map<TempBatchListModel>((a) => TempBatchListModel.fromJson(a)).toList();
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
    data['disabled'] = disabled;
    data['use_batchwise_valuation'] = useBatchwiseValuation;
    data['batch_id'] = batchId;
    data['item'] = item;
    data['item_name'] = itemName;
    data['image'] = image;
    data['parent_batch'] = parentBatch;
    data['manufacturing_date'] = manufacturingDate;
    data['batch_qty'] = batchQty;
    data['stock_uom'] = stockUom;
    data['expiry_date'] = expiryDate;
    data['supplier'] = supplier;
    data['reference_doctype'] = referenceDoctype;
    data['reference_name'] = referenceName;
    data['description'] = description;
    data['qty_to_produce'] = qtyToProduce;
    data['produced_qty'] = producedQty;
    data['_user_tags'] = nUserTags;
    data['_comments'] = nComments;
    data['_assign'] = nAssign;
    data['_liked_by'] = nLikedBy;
    return data;
  }
}




