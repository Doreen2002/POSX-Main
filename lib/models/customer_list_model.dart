//   class CustomerListModel {
//   String? message;
//   List<CustomerData>? customerData;
//
//   CustomerListModel({this.message, this.customerData});
//
//   CustomerListModel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     if (json['data'] != null) {
//       customerData = <CustomerData>[];
//       json['data'].forEach((v) {
//         customerData!.add(new CustomerData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     if (this.customerData != null) {
//       data['data'] = this.customerData!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class CustomerData {
//   String? name;
//   String? creation;
//   String? modified;
//   String? modifiedBy;
//   String? owner;
//   int? docstatus;
//   int? idx;
//   String? namingSeries;
//   String? salutation;
//   String? customerName;
//   String? customerType;
//   String? customerGroup;
//   String? territory;
//   String? gender;
//   String? leadName;
//   String? opportunityName;
//   String? accountManager;
//   String? image;
//   String? defaultPriceList;
//   String? defaultBankAccount;
//   String? defaultCurrency;
//   int? isInternalCustomer;
//   String? representsCompany;
//   String? marketSegment;
//   String? industry;
//   String? customerPosId;
//   String? website;
//   String? language;
//   String? customerDetails;
//   String? customerPrimaryContact;
//   String? mobileNo;
//   String? emailId;
//   String? customerPrimaryAddress;
//   String? primaryAddress;
//   String? taxId;
//   String? taxCategory;
//   String? taxWithholdingCategory;
//   String? paymentTerms;
//   String? loyaltyProgram;
//   String? loyaltyProgramTier;
//   String? defaultSalesPartner;
//   double? defaultCommissionRate;
//   int? soRequired;
//   int? dnRequired;
//   int? isFrozen;
//   int? disabled;
//   String? nUserTags;
//   String? nComments;
//   String? nAssign;
//   String? nLikedBy;
//   String? customerCode;
//   String? pan;
//   String? gstin;
//   String? gstCategory;
//   String? marking;
//   String? taxInvoicePrintHeading;
//   String? shippingMarks;
//   String? marksNumber;
//   String? descriptionOfGoods;
//   String? vendorNo;
//
//   CustomerData(
//       {this.name,
//         this.creation,
//         this.modified,
//         this.modifiedBy,
//         this.owner,
//         this.docstatus,
//         this.idx,
//         this.namingSeries,
//         this.salutation,
//         this.customerName,
//         this.customerType,
//         this.customerGroup,
//         this.territory,
//         this.gender,
//         this.leadName,
//         this.opportunityName,
//         this.accountManager,
//         this.image,
//         this.defaultPriceList,
//         this.defaultBankAccount,
//         this.defaultCurrency,
//         this.isInternalCustomer,
//         this.representsCompany,
//         this.marketSegment,
//         this.industry,
//         this.customerPosId,
//         this.website,
//         this.language,
//         this.customerDetails,
//         this.customerPrimaryContact,
//         this.mobileNo,
//         this.emailId,
//         this.customerPrimaryAddress,
//         this.primaryAddress,
//         this.taxId,
//         this.taxCategory,
//         this.taxWithholdingCategory,
//         this.paymentTerms,
//         this.loyaltyProgram,
//         this.loyaltyProgramTier,
//         this.defaultSalesPartner,
//         this.defaultCommissionRate,
//         this.soRequired,
//         this.dnRequired,
//         this.isFrozen,
//         this.disabled,
//         this.nUserTags,
//         this.nComments,
//         this.nAssign,
//         this.nLikedBy,
//         this.customerCode,
//         this.pan,
//         this.gstin,
//         this.gstCategory,
//         this.marking,
//         this.taxInvoicePrintHeading,
//         this.shippingMarks,
//         this.marksNumber,
//         this.descriptionOfGoods,
//         this.vendorNo});
//
//   CustomerData.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     creation = json['creation'];
//     modified = json['modified'];
//     modifiedBy = json['modified_by'];
//     owner = json['owner'];
//     docstatus = json['docstatus'];
//     idx = json['idx'];
//     namingSeries = json['naming_series'];
//     salutation = json['salutation'];
//     customerName = json['customer_name'];
//     customerType = json['customer_type'];
//     customerGroup = json['customer_group'];
//     territory = json['territory'];
//     gender = json['gender'];
//     leadName = json['lead_name'];
//     opportunityName = json['opportunity_name'];
//     accountManager = json['account_manager'];
//     image = json['image'];
//     defaultPriceList = json['default_price_list'];
//     defaultBankAccount = json['default_bank_account'];
//     defaultCurrency = json['default_currency'];
//     isInternalCustomer = json['is_internal_customer'];
//     representsCompany = json['represents_company'];
//     marketSegment = json['market_segment'];
//     industry = json['industry'];
//     customerPosId = json['customer_pos_id'];
//     website = json['website'];
//     language = json['language'];
//     customerDetails = json['customer_details'];
//     customerPrimaryContact = json['customer_primary_contact'];
//     mobileNo = json['mobile_no'];
//     emailId = json['email_id'];
//     customerPrimaryAddress = json['customer_primary_address'];
//     primaryAddress = json['primary_address'];
//     taxId = json['tax_id'];
//     taxCategory = json['tax_category'];
//     taxWithholdingCategory = json['tax_withholding_category'];
//     paymentTerms = json['payment_terms'];
//     loyaltyProgram = json['loyalty_program'];
//     loyaltyProgramTier = json['loyalty_program_tier'];
//     defaultSalesPartner = json['default_sales_partner'];
//     defaultCommissionRate = json['default_commission_rate'];
//     soRequired = json['so_required'];
//     dnRequired = json['dn_required'];
//     isFrozen = json['is_frozen'];
//     disabled = json['disabled'];
//     nUserTags = json['_user_tags'];
//     nComments = json['_comments'];
//     nAssign = json['_assign'];
//     nLikedBy = json['_liked_by'];
//     customerCode = json['customer_code'];
//     pan = json['pan'];
//     gstin = json['gstin'];
//     gstCategory = json['gst_category'];
//     marking = json['marking'];
//     taxInvoicePrintHeading = json['tax_invoice_print_heading'];
//     shippingMarks = json['shipping_marks'];
//     marksNumber = json['marks_number'];
//     descriptionOfGoods = json['description_of_goods'];
//     vendorNo = json['vendor_no'];
//   }
//
//   static List<CustomerData> fromJsonArray(List<dynamic> dataList) {
//     List<CustomerData> list =
//     dataList.map<CustomerData>((a) => CustomerData.fromJson(a)).toList();
//     return list;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['creation'] = this.creation;
//     data['modified'] = this.modified;
//     data['modified_by'] = this.modifiedBy;
//     data['owner'] = this.owner;
//     data['docstatus'] = this.docstatus;
//     data['idx'] = this.idx;
//     data['naming_series'] = this.namingSeries;
//     data['salutation'] = this.salutation;
//     data['customer_name'] = this.customerName;
//     data['customer_type'] = this.customerType;
//     data['customer_group'] = this.customerGroup;
//     data['territory'] = this.territory;
//     data['gender'] = this.gender;
//     data['lead_name'] = this.leadName;
//     data['opportunity_name'] = this.opportunityName;
//     data['account_manager'] = this.accountManager;
//     data['image'] = this.image;
//     data['default_price_list'] = this.defaultPriceList;
//     data['default_bank_account'] = this.defaultBankAccount;
//     data['default_currency'] = this.defaultCurrency;
//     data['is_internal_customer'] = this.isInternalCustomer;
//     data['represents_company'] = this.representsCompany;
//     data['market_segment'] = this.marketSegment;
//     data['industry'] = this.industry;
//     data['customer_pos_id'] = this.customerPosId;
//     data['website'] = this.website;
//     data['language'] = this.language;
//     data['customer_details'] = this.customerDetails;
//     data['customer_primary_contact'] = this.customerPrimaryContact;
//     data['mobile_no'] = this.mobileNo;
//     data['email_id'] = this.emailId;
//     data['customer_primary_address'] = this.customerPrimaryAddress;
//     data['primary_address'] = this.primaryAddress;
//     data['tax_id'] = this.taxId;
//     data['tax_category'] = this.taxCategory;
//     data['tax_withholding_category'] = this.taxWithholdingCategory;
//     data['payment_terms'] = this.paymentTerms;
//     data['loyalty_program'] = this.loyaltyProgram;
//     data['loyalty_program_tier'] = this.loyaltyProgramTier;
//     data['default_sales_partner'] = this.defaultSalesPartner;
//     data['default_commission_rate'] = this.defaultCommissionRate;
//     data['so_required'] = this.soRequired;
//     data['dn_required'] = this.dnRequired;
//     data['is_frozen'] = this.isFrozen;
//     data['disabled'] = this.disabled;
//     data['_user_tags'] = this.nUserTags;
//     data['_comments'] = this.nComments;
//     data['_assign'] = this.nAssign;
//     data['_liked_by'] = this.nLikedBy;
//     data['customer_code'] = this.customerCode;
//     data['pan'] = this.pan;
//     data['gstin'] = this.gstin;
//     data['gst_category'] = this.gstCategory;
//     data['marking'] = this.marking;
//     data['tax_invoice_print_heading'] = this.taxInvoicePrintHeading;
//     data['shipping_marks'] = this.shippingMarks;
//     data['marks_number'] = this.marksNumber;
//     data['description_of_goods'] = this.descriptionOfGoods;
//     data['vendor_no'] = this.vendorNo;
//     return data;
//   }
// }

// class TempCustomerData {
//   String? name;
//   String? creation;
//   String? modified;
//   String? modifiedBy;
//   String? owner;
//   int? docstatus;
//   int? idx;
//   String? namingSeries;
//   String? salutation;
//   String? customerName;
//   String? customerType;
//   String? customerGroup;
//   String? territory;
//   String? flatNo;
//   String? building;
//   String? roadNo;
//   String? zip;
//   String? country;
//   String? idNo;
//   String? gender;
//   String? leadName;
//   String? opportunityName;
//   String? accountManager;
//   String? image;
//   String? defaultPriceList;
//   String? defaultBankAccount;
//   String? defaultCurrency;
//   int? isInternalCustomer;
//   String? representsCompany;
//   String? marketSegment;
//   String? industry;
//   String? customerPosId;
//   String? website;
//   String? language;
//   String? customerDetails;
//   String? customerPrimaryContact;
//   String? mobileNo;
//   String? emailId;
//   String? customerPrimaryAddress;
//   String? primaryAddress;
//   String? taxId;
//   String? taxCategory;
//   String? taxWithholdingCategory;
//   String? paymentTerms;
//   String? loyaltyProgram;
//   String? loyaltyProgramTier;
//   String? defaultSalesPartner;
//   double? defaultCommissionRate;
//   int? soRequired;
//   int? dnRequired;
//   int? isFrozen;
//   int? disabled;
//   String? nUserTags;
//   String? nComments;
//   String? nAssign;
//   String? nLikedBy;
//   String? customerCode;
//   String? pan;
//   String? gstin;
//   String? gstCategory;
//   String? marking;
//   String? taxInvoicePrintHeading;
//   String? shippingMarks;
//   String? marksNumber;
//   String? descriptionOfGoods;
//   String? vendorNo;
//
//   TempCustomerData(
//       {this.name,
//         this.creation,
//         this.modified,
//         this.modifiedBy,
//         this.owner,
//         this.docstatus,
//         this.idx,
//         this.idNo,
//         this.building,
//         this.flatNo,
//         this.roadNo,
//         this.zip,
//         this.country,
//         this.namingSeries,
//         this.salutation,
//         this.customerName,
//         this.customerType,
//         this.customerGroup,
//         this.territory,
//         this.gender,
//         this.leadName,
//         this.opportunityName,
//         this.accountManager,
//         this.image,
//         this.defaultPriceList,
//         this.defaultBankAccount,
//         this.defaultCurrency,
//         this.isInternalCustomer,
//         this.representsCompany,
//         this.marketSegment,
//         this.industry,
//         this.customerPosId,
//         this.website,
//         this.language,
//         this.customerDetails,
//         this.customerPrimaryContact,
//         this.mobileNo,
//         this.emailId,
//         this.customerPrimaryAddress,
//         this.primaryAddress,
//         this.taxId,
//         this.taxCategory,
//         this.taxWithholdingCategory,
//         this.paymentTerms,
//         this.loyaltyProgram,
//         this.loyaltyProgramTier,
//         this.defaultSalesPartner,
//         this.defaultCommissionRate,
//         this.soRequired,
//         this.dnRequired,
//         this.isFrozen,
//         this.disabled,
//         this.nUserTags,
//         this.nComments,
//         this.nAssign,
//         this.nLikedBy,
//         this.customerCode,
//         this.pan,
//         this.gstin,
//         this.gstCategory,
//         this.marking,
//         this.taxInvoicePrintHeading,
//         this.shippingMarks,
//         this.marksNumber,
//         this.descriptionOfGoods,
//         this.vendorNo});
//
//   TempCustomerData.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     creation = json['creation'];
//     modified = json['modified'];
//     modifiedBy = json['modified_by'];
//     owner = json['owner'];
//     docstatus = json['docstatus'];
//     idx = json['idx'];
//     namingSeries = json['naming_series'];
//     salutation = json['salutation'];
//     customerName = json['customer_name'];
//     customerType = json['customer_type'];
//     customerGroup = json['customer_group'];
//     territory = json['territory'];
//     gender = json['gender'];
//     idNo = json['id_no'];
//     flatNo = json['flat_no'];
//     building = json['building'];
//     roadNo = json['road_no'];
//     zip = json['zip'];
//     country = json['country'];
//     leadName = json['lead_name'];
//     opportunityName = json['opportunity_name'];
//     accountManager = json['account_manager'];
//     image = json['image'];
//     defaultPriceList = json['default_price_list'];
//     defaultBankAccount = json['default_bank_account'];
//     defaultCurrency = json['default_currency'];
//     isInternalCustomer = json['is_internal_customer'];
//     representsCompany = json['represents_company'];
//     marketSegment = json['market_segment'];
//     industry = json['industry'];
//     customerPosId = json['customer_pos_id'];
//     website = json['website'];
//     language = json['language'];
//     customerDetails = json['customer_details'];
//     customerPrimaryContact = json['customer_primary_contact'];
//     mobileNo = json['mobile_no'];
//     emailId = json['email_id'];
//     customerPrimaryAddress = json['customer_primary_address'];
//     primaryAddress = json['primary_address'];
//     taxId = json['tax_id'];
//     taxCategory = json['tax_category'];
//     taxWithholdingCategory = json['tax_withholding_category'];
//     paymentTerms = json['payment_terms'];
//     loyaltyProgram = json['loyalty_program'];
//     loyaltyProgramTier = json['loyalty_program_tier'];
//     defaultSalesPartner = json['default_sales_partner'];
//     defaultCommissionRate = json['default_commission_rate'];
//     soRequired = json['so_required'];
//     dnRequired = json['dn_required'];
//     isFrozen = json['is_frozen'];
//     disabled = json['disabled'];
//     nUserTags = json['_user_tags'];
//     nComments = json['_comments'];
//     nAssign = json['_assign'];
//     nLikedBy = json['_liked_by'];
//     customerCode = json['customer_code'];
//     pan = json['pan'];
//     gstin = json['gstin'];
//     gstCategory = json['gst_category'];
//     marking = json['marking'];
//     taxInvoicePrintHeading = json['tax_invoice_print_heading'];
//     shippingMarks = json['shipping_marks'];
//     marksNumber = json['marks_number'];
//     descriptionOfGoods = json['description_of_goods'];
//     vendorNo = json['vendor_no'];
//   }
//
//   static List<TempCustomerData> fromJsonArray(List<dynamic> dataList) {
//     List<TempCustomerData> list =
//     dataList.map<TempCustomerData>((a) => TempCustomerData.fromJson(a)).toList();
//     return list;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['creation'] = this.creation;
//     data['modified'] = this.modified;
//     data['modified_by'] = this.modifiedBy;
//     data['owner'] = this.owner;
//     data['docstatus'] = this.docstatus;
//     data['idx'] = this.idx;
//     data['naming_series'] = this.namingSeries;
//     data['salutation'] = this.salutation;
//     data['customer_name'] = this.customerName;
//     data['customer_type'] = this.customerType;
//     data['customer_group'] = this.customerGroup;
//     data['territory'] = this.territory;
//     data['gender'] = this.gender;
//     data['lead_name'] = this.leadName;
//     data['opportunity_name'] = this.opportunityName;
//     data['account_manager'] = this.accountManager;
//     data['image'] = this.image;
//     data['default_price_list'] = this.defaultPriceList;
//     data['default_bank_account'] = this.defaultBankAccount;
//     data['default_currency'] = this.defaultCurrency;
//     data['is_internal_customer'] = this.isInternalCustomer;
//     data['represents_company'] = this.representsCompany;
//     data['market_segment'] = this.marketSegment;
//     data['industry'] = this.industry;
//     data['customer_pos_id'] = this.customerPosId;
//     data['website'] = this.website;
//     data['language'] = this.language;
//     data['customer_details'] = this.customerDetails;
//     data['customer_primary_contact'] = this.customerPrimaryContact;
//     data['mobile_no'] = this.mobileNo;
//     data['email_id'] = this.emailId;
//     data['customer_primary_address'] = this.customerPrimaryAddress;
//     data['primary_address'] = this.primaryAddress;
//     data['tax_id'] = this.taxId;
//     data['tax_category'] = this.taxCategory;
//     data['tax_withholding_category'] = this.taxWithholdingCategory;
//     data['payment_terms'] = this.paymentTerms;
//     data['loyalty_program'] = this.loyaltyProgram;
//     data['loyalty_program_tier'] = this.loyaltyProgramTier;
//     data['default_sales_partner'] = this.defaultSalesPartner;
//     data['default_commission_rate'] = this.defaultCommissionRate;
//     data['so_required'] = this.soRequired;
//     data['dn_required'] = this.dnRequired;
//     data['is_frozen'] = this.isFrozen;
//     data['disabled'] = this.disabled;
//     data['_user_tags'] = this.nUserTags;
//     data['_comments'] = this.nComments;
//     data['_assign'] = this.nAssign;
//     data['_liked_by'] = this.nLikedBy;
//     data['customer_code'] = this.customerCode;
//     data['pan'] = this.pan;
//     data['gstin'] = this.gstin;
//     data['gst_category'] = this.gstCategory;
//     data['marking'] = this.marking;
//     data['tax_invoice_print_heading'] = this.taxInvoicePrintHeading;
//     data['shipping_marks'] = this.shippingMarks;
//     data['marks_number'] = this.marksNumber;
//     data['description_of_goods'] = this.descriptionOfGoods;
//     data['vendor_no'] = this.vendorNo;
//     return data;
//   }
// }

class CustomerListModel {
  Message? message;

  CustomerListModel({this.message});

  CustomerListModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  int? status;
  String? message;
  List<CustomerData>? customerData;

  Message({this.status, this.message, this.customerData});

  Message.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      customerData = <CustomerData>[];
      json['data'].forEach((v) {
        customerData!.add(CustomerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (customerData != null) {
      data['data'] = customerData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerData {
  String? name;
  String? customerName;
  String? territory;
  String? customerGroup;
  String? customerType;
  String? emailId;
  String? mobileNo;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? zipCode;
  String? country;

  CustomerData({
    this.name,
    this.customerName,
    this.territory,
    this.customerGroup,
    this.customerType,
    this.emailId,
    this.mobileNo,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  CustomerData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    customerName = json['customer_name'];
    // territory = json['territory'];
    // customerGroup = json['customer_group'];
    // customerType = json['customer_type'];
    emailId = json['email_id'];
    mobileNo = json['mobile_no'];
    addressLine1 = json['address_line1'];
    addressLine2 = json['address_line2'];
    city = json['city'];
    // state = json['state'];
    // zipCode = json['zip_code'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['customer_name'] = customerName;
    // data['territory'] = territory;
    // data['customer_group'] = customerGroup;
    // data['customer_type'] = customerType;
    data['email_id'] = emailId;
    data['mobile_no'] = mobileNo;
    data['address_line1'] = addressLine1;
    data['address_line2'] = addressLine2;
    data['city'] = city;
    // data['state'] = state;
    // data['zip_code'] = zipCode;
    data['country'] = country;
    return data;
  }
}

class TempCustomerData {
  String? name;
  String? customerName;
  String? posxID ;
  // String? territory;
  // String? customerGroup;
  // String? customerType;
  String? emailId;
  String? mobileNo;
  String? addressLine1;
  String? addressLine2;
  String? city;
  // String? state;
  // String? zipCode;
  String? syncStatus;
  String? defaultPriceList;
  String? country;
  double? loyaltyPoints;
  double? loyaltyPointsAmount;
  double? conversionRate;
  String? gender; // new
  String? nationalId; // new
  String? qrCodeData; // NEW: Customer QR code for POS scanning

  TempCustomerData({
    this.name,
    this.customerName,
    this.posxID,
    // this.territory,
    // this.customerGroup,
    // this.customerType,
    this.emailId,
    this.mobileNo,
    this.addressLine1,
    this.addressLine2,
    this.city,
    // this.state,
    // this.zipCode,
    this.country,
    this.loyaltyPoints,
    this.loyaltyPointsAmount,
    this.conversionRate,
    this.defaultPriceList,
    this.gender,
    this.nationalId,
    this.syncStatus,
    this.qrCodeData, // NEW
  });

String? parseBlob(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is List<int>) return String.fromCharCodes(value);
  return value.toString();
}
  TempCustomerData.fromJson(Map<String, dynamic> json) {
  name = json['name']?.toString();
  customerName = json['customer_name']?.toString();
  posxID = json['posx_id']?.toString() ?? "";
  emailId = json['email_id']?.toString();
  mobileNo = json['mobile_no']?.toString();
  addressLine1 = json['address_line1']?.toString();
  addressLine2 = json['address_line2']?.toString();
  city = json['city']?.toString();
  country = json['country']?.toString();
  loyaltyPoints = json['loyalty_points'] != null
      ? double.tryParse(json['loyalty_points'].toString())
      : null;
  loyaltyPointsAmount = json['loyalty_points_amount'] != null
      ? double.tryParse(json['loyalty_points_amount'].toString())
      : null;
  conversionRate = json['conversion_rate'] != null
  ? double.tryParse(json['conversion_rate'].toString())
  : null;
  gender = json['gender']?.toString();
  nationalId = parseBlob(json['national_id']);
  syncStatus = json['sync_status']?.toString() ?? 'Synced';
  qrCodeData = json['custom_qr_code_data']?.toString(); // NEW: Parse QR code data
  defaultPriceList = json['default_price_list']?.toString();
}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['customer_name'] = customerName;
    // data['territory'] = territory;
    // data['customer_group'] = customerGroup;
    // data['customer_type'] = customerType;
    data['email_id'] = emailId;
    data['mobile_no'] = mobileNo;
    data['gender'] = gender; // new
    data['national_id'] = nationalId; // new
    data['address_line1'] = addressLine1;
    data['address_line2'] = addressLine2;
    data['city'] = city;
    // data['state'] = state;
    // data['zip_code'] = zipCode;
    data['country'] = country;
    data['loyalty_points'] = loyaltyPoints;
    data['loyalty_points_amount'] = loyaltyPointsAmount;
    data['conversion_rate'] = conversionRate;
    data['sync_status'] = syncStatus;
    data['custom_qr_code_data'] = qrCodeData; // NEW: Include QR code data
    data['default_price_list'] = defaultPriceList;
    return data;
  }
}
