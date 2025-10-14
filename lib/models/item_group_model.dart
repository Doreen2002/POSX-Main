class ItemGroupModel {
  String? message;
  List<ItemGroupData>? itemGroupData;

  ItemGroupModel({this.message, this.itemGroupData});

  ItemGroupModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      itemGroupData = <ItemGroupData>[];
      json['data'].forEach((v) {
        itemGroupData!.add(ItemGroupData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (itemGroupData != null) {
      data['data'] = itemGroupData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemGroupData {
  String? name;
  String? creation;
  String? modified;
  String? modifiedBy;
  String? owner;
  int? docstatus;
  int? idx;
  String? itemGroupName;
  String? parentItemGroup;
  int? isGroup;
  Null image;
  String? route;
  Null websiteTitle;
  Null description;
  int? showInWebsite;
  int? includeDescendants;
  int? weightage;
  Null slideshow;
  int? lft;
  int? rgt;
  String? oldParent;
  Null nUserTags;
  Null nComments;
  Null nAssign;
  Null nLikedBy;

  ItemGroupData(
      {this.name,
        this.creation,
        this.modified,
        this.modifiedBy,
        this.owner,
        this.docstatus,
        this.idx,
        this.itemGroupName,
        this.parentItemGroup,
        this.isGroup,
        this.image,
        this.route,
        this.websiteTitle,
        this.description,
        this.showInWebsite,
        this.includeDescendants,
        this.weightage,
        this.slideshow,
        this.lft,
        this.rgt,
        this.oldParent,
        this.nUserTags,
        this.nComments,
        this.nAssign,
        this.nLikedBy});

  ItemGroupData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    creation = json['creation'];
    modified = json['modified'];
    modifiedBy = json['modified_by'];
    owner = json['owner'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    itemGroupName = json['item_group_name'];
    parentItemGroup = json['parent_item_group'];
    isGroup = json['is_group'];
    image = json['image'];
    route = json['route'];
    websiteTitle = json['website_title'];
    description = json['description'];
    showInWebsite = json['show_in_website'];
    includeDescendants = json['include_descendants'];
    weightage = json['weightage'];
    slideshow = json['slideshow'];
    lft = json['lft'];
    rgt = json['rgt'];
    oldParent = json['old_parent'];
    nUserTags = json['_user_tags'];
    nComments = json['_comments'];
    nAssign = json['_assign'];
    nLikedBy = json['_liked_by'];
  }
  static List<ItemGroupData> fromJsonArray(List<dynamic> dataList) {
    List<ItemGroupData> list =
    dataList.map<ItemGroupData>((a) => ItemGroupData.fromJson(a)).toList();
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
    data['item_group_name'] = itemGroupName;
    data['parent_item_group'] = parentItemGroup;
    data['is_group'] = isGroup;
    data['image'] = image;
    data['route'] = route;
    data['website_title'] = websiteTitle;
    data['description'] = description;
    data['show_in_website'] = showInWebsite;
    data['include_descendants'] = includeDescendants;
    data['weightage'] = weightage;
    data['slideshow'] = slideshow;
    data['lft'] = lft;
    data['rgt'] = rgt;
    data['old_parent'] = oldParent;
    data['_user_tags'] = nUserTags;
    data['_comments'] = nComments;
    data['_assign'] = nAssign;
    data['_liked_by'] = nLikedBy;
    return data;
  }
}


class TempItemGroup {
  String? name;
  // String? creation;
  // String? modified;
  // String? modifiedBy;
  // String? owner;
  // int? docstatus;
  // int? idx;
  // String? itemGroupName;
  // String? parentItemGroup;
  // int? isGroup;
  // Null? image;
  // String? route;
  // Null? websiteTitle;
  // Null? description;
  // int? showInWebsite;
  // int? includeDescendants;
  // int? weightage;
  // Null? slideshow;
  // int? lft;
  // int? rgt;
  // String? oldParent;
  // Null? nUserTags;
  // Null? nComments;
  // Null? nAssign;
  // Null? nLikedBy;

  TempItemGroup(
      {this.name,
        // this.creation,
        // this.modified,
        // this.modifiedBy,
        // this.owner,
        // this.docstatus,
        // this.idx,
        // this.itemGroupName,
        // this.parentItemGroup,
        // this.isGroup,
        // this.image,
        // this.route,
        // this.websiteTitle,
        // this.description,
        // this.showInWebsite,
        // this.includeDescendants,
        // this.weightage,
        // this.slideshow,
        // this.lft,
        // this.rgt,
        // this.oldParent,
        // this.nUserTags,
        // this.nComments,
        // this.nAssign,
        // this.nLikedBy
  });

  TempItemGroup.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    // creation = json['creation'];
    // modified = json['modified'];
    // modifiedBy = json['modified_by'];
    // owner = json['owner'];
    // docstatus = json['docstatus'];
    // idx = json['idx'];
    // itemGroupName = json['item_group_name'];
    // parentItemGroup = json['parent_item_group'];
    // isGroup = json['is_group'];
    // image = json['image'];
    // route = json['route'];
    // websiteTitle = json['website_title'];
    // description = json['description'];
    // showInWebsite = json['show_in_website'];
    // includeDescendants = json['include_descendants'];
    // weightage = json['weightage'];
    // slideshow = json['slideshow'];
    // lft = json['lft'];
    // rgt = json['rgt'];
    // oldParent = json['old_parent'];
    // nUserTags = json['_user_tags'];
    // nComments = json['_comments'];
    // nAssign = json['_assign'];
    // nLikedBy = json['_liked_by'];
  }
  static List<TempItemGroup> fromJsonArray(List<dynamic> dataList) {
    List<TempItemGroup> list =
    dataList.map<TempItemGroup>((a) => TempItemGroup.fromJson(a)).toList();
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    // data['creation'] = this.creation;
    // data['modified'] = this.modified;
    // data['modified_by'] = this.modifiedBy;
    // data['owner'] = this.owner;
    // data['docstatus'] = this.docstatus;
    // data['idx'] = this.idx;
    // data['item_group_name'] = this.itemGroupName;
    // data['parent_item_group'] = this.parentItemGroup;
    // data['is_group'] = this.isGroup;
    // data['image'] = this.image;
    // data['route'] = this.route;
    // data['website_title'] = this.websiteTitle;
    // data['description'] = this.description;
    // data['show_in_website'] = this.showInWebsite;
    // data['include_descendants'] = this.includeDescendants;
    // data['weightage'] = this.weightage;
    // data['slideshow'] = this.slideshow;
    // data['lft'] = this.lft;
    // data['rgt'] = this.rgt;
    // data['old_parent'] = this.oldParent;
    // data['_user_tags'] = this.nUserTags;
    // data['_comments'] = this.nComments;
    // data['_assign'] = this.nAssign;
    // data['_liked_by'] = this.nLikedBy;
    return data;
  }
}




class BatchResponseModel {
  String? name;

  BatchResponseModel({this.name});

  BatchResponseModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  static List<BatchResponseModel> fromJsonArray(List<dynamic> dataList) {
    List<BatchResponseModel> list =
    dataList.map<BatchResponseModel>((a) => BatchResponseModel.fromJson(a)).toList();
    return list;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
