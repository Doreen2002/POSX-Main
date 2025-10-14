class PosClosingEntry {
  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? owner;
  int? docstatus;
  int? idx;
  String? periodStartDate;
  String? periodEndDate;
  String? status;
  String? postingDate;
  int? setPostingDate;
  double? amount;
  String? company;
  String? posProfile;
  String? posClosingEntry;
   String? posOpeningEntry;
  String? user;
  String? amendedFrom;
  String? nUserTags;
  String? comment;
  double? totalDenominationValue;
  String? nAssign;
  String? nLikedBy;
  String? namingSeries;
  String ? syncStatus;
  double? closingAmount;
  double? openingEntryAmount;
    String? erpnextID;

  PosClosingEntry({
    this.name,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.owner,
    this.docstatus,
    this.idx,
    this.periodStartDate,
    this.periodEndDate,
    this.status,
    this.postingDate,
    this.amount,
    this.setPostingDate,
    this.company,
    this.posProfile,
    this.posClosingEntry,
    this.posOpeningEntry,
    this.user,
    this.amendedFrom,
    this.nUserTags,
    this.comment,
    this.totalDenominationValue,
    this.nAssign,
    this.nLikedBy,
    this.namingSeries,
    this.syncStatus,
    this.closingAmount,
    this.openingEntryAmount,
    this.erpnextID
  });

  PosClosingEntry.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    owner = json['owner'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    periodStartDate = json['period_start_date'];
    periodEndDate = json['period_end_date'];
    status = json['status'];
    postingDate = json['posting_date'];
    amount = json['amount'];
    setPostingDate = json['set_posting_date'];
    company = json['company'];
    posProfile = json['pos_profile'];
    posClosingEntry = json['pos_closing_entry'];
      posOpeningEntry = json['pos_opening_entry'];
    user = json['user'];
    amendedFrom = json['amended_from'];
    nUserTags = json['_user_tags'];
    comment = json['comment'];
    nAssign = json['_assign'];
    nLikedBy = json['_liked_by'];
    namingSeries = json['naming_series'];
    syncStatus = json['sync_status'];
    closingAmount = json['closing_amount'];
    openingEntryAmount = json['opening_entry_amount'];
    erpnextID = json['erpnext_id'];
    totalDenominationValue = json['total_denomination_value'];
  }

  static List<PosClosingEntry> fromJsonArray(List<dynamic> dataList) {
    List<PosClosingEntry> list =
        dataList
            .map<PosClosingEntry>((a) => PosClosingEntry.fromJson(a))
            .toList();
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
    data['period_start_date'] = periodStartDate;
    data['period_end_date'] = periodEndDate;
    data['status'] = status;
    data['posting_date'] = postingDate;
    data['amount'] = amount;
    data['set_posting_date'] = setPostingDate;
    data['company'] = company;
    data['pos_profile'] = posProfile;
    data['pos_closing_entry'] = posClosingEntry;
     data['pos_opening_entry'] = posOpeningEntry;
    data['user'] = user;
    data['amended_from'] = amendedFrom;
    data['_user_tags'] = nUserTags;
    data['comment'] = comment;
    data['_assign'] = nAssign;
    data['_liked_by'] = nLikedBy;
    data['naming_series'] = namingSeries;
    data['sync_status'] = syncStatus;
    data['closing_amount'] = closingAmount;
    data['opening_entry_amount'] = openingEntryAmount;
    data['erpnext_id'] = erpnextID;
    data['total_denomination_value'] = totalDenominationValue;
    return data;
  }
}

class TempPosClosingEntry {
  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? owner;
  int? docstatus;
  int? idx;
  String? periodStartDate;
  String? periodEndDate;
  String? status;
  String? postingDate;
  int? setPostingDate;
  double? amount;
  String? company;
  String? posProfile;
  String? posClosingEntry;
  String? user;
  String? paymentMode;
  String? amendedFrom;
  String? nUserTags;
  String? nComments;
  String? nAssign;
  String? nLikedBy;
  String? namingSeries;
  String? erpnextID;

  TempPosClosingEntry({
    this.name,
    this.creation,
    this.modified,
    this.modifiedBy,
    this.owner,
    this.docstatus,
    this.idx,
    this.periodStartDate,
    this.periodEndDate,
    this.status,
    this.postingDate,
    this.amount,
    this.setPostingDate,
    this.company,
    this.posProfile,
    this.posClosingEntry,
    this.user,
    this.paymentMode,
    this.amendedFrom,
    this.nUserTags,
    this.nComments,
    this.nAssign,
    this.nLikedBy,
    this.namingSeries,
    this.erpnextID
  });

  TempPosClosingEntry.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    owner = json['owner'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    periodStartDate = json['period_start_date'];
    periodEndDate = json['period_end_date'];
    status = json['status'];
    postingDate = json['posting_date'];
    amount = json['amount'];
    setPostingDate = json['set_posting_date'];
    company = json['company'];
    posProfile = json['pos_profile'];
    posClosingEntry = json['pos_closing_entry'];
    user = json['user'];
    paymentMode = json['paymentMode'];
    amendedFrom = json['amended_from'];
    nUserTags = json['_user_tags'];
    nComments = json['_comments'];
    nAssign = json['_assign'];
    nLikedBy = json['_liked_by'];
    namingSeries = json['naming_series'];
    erpnextID = json['erpnext_id'];
  }

  static List<TempPosClosingEntry> fromJsonArray(List<dynamic> dataList) {
    List<TempPosClosingEntry> list =
        dataList
            .map<TempPosClosingEntry>((a) => TempPosClosingEntry.fromJson(a))
            .toList();
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
    data['period_start_date'] = periodStartDate;
    data['period_end_date'] = periodEndDate;
    data['status'] = status;
    data['posting_date'] = postingDate;
    data['amount'] = amount;
    data['set_posting_date'] = setPostingDate;
    data['company'] = company;
    data['pos_profile'] = posProfile;
    data['pos_closing_entry'] = posClosingEntry;
    data['user'] = user;
    data['paymentMode'] = paymentMode;
    data['amended_from'] = amendedFrom;
    data['_user_tags'] = nUserTags;
    data['_comments'] = nComments;
    data['_assign'] = nAssign;
    data['_liked_by'] = nLikedBy;
    data['naming_series'] = namingSeries;
    data['erpnext_id'] = erpnextID;
    return data;
  }
}
