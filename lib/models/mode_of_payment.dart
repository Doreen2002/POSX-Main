class ModeOfPaymentModel {
  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? owner;
  int? docstatus;
  int? idx;
  String? modeOfPayment;
  int? enabled;
  String? type;
  // Null? nUserTags;
  // Null? nComments;
  // Null? nAssign;
  // Null? nLikedBy;

  ModeOfPaymentModel(
      {this.name,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.owner,
        this.docstatus,
        this.idx,
        this.modeOfPayment,
        this.enabled,
        this.type,
        // this.nUserTags,
        // this.nComments,
        // this.nAssign,
        // this.nLikedBy
      });

  ModeOfPaymentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    owner = json['owner'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    modeOfPayment = json['mode_of_payment'];
    enabled = json['enabled'];
    type = json['type'];
    // nUserTags = json['_user_tags'];
    // nComments = json['_comments'];
    // nAssign = json['_assign'];
    // nLikedBy = json['_liked_by'];
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
    data['mode_of_payment'] = modeOfPayment;
    data['enabled'] = enabled;
    data['type'] = type;
    // data['_user_tags'] = this.nUserTags;
    // data['_comments'] = this.nComments;
    // data['_assign'] = this.nAssign;
    // data['_liked_by'] = this.nLikedBy;
    return data;
  }
}