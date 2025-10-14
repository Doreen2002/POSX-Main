import 'package:flutter/cupertino.dart';

class TypeAheadModel {
  String? name;

  TypeAheadModel({this.name});

  TypeAheadModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  static List<TypeAheadModel> fromJsonArray(List<dynamic> dataList) {
    List<TypeAheadModel> list =
    dataList.map<TypeAheadModel>((a) => TypeAheadModel.fromJson(a)).toList();
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}


class TempCGroupTypeAheadModel {
  String? name;

  TempCGroupTypeAheadModel({this.name});

  TempCGroupTypeAheadModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  static List<TempCGroupTypeAheadModel> fromJsonArray(List<dynamic> dataList) {
    List<TempCGroupTypeAheadModel> list =
    dataList.map<TempCGroupTypeAheadModel>((a) => TempCGroupTypeAheadModel.fromJson(a)).toList();
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class TerritoryTypeAheadModel {
  String? name;

  TerritoryTypeAheadModel({this.name});

  TerritoryTypeAheadModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  static List<TerritoryTypeAheadModel> fromJsonArray(List<dynamic> dataList) {
    List<TerritoryTypeAheadModel> list =
    dataList.map<TerritoryTypeAheadModel>((a) => TerritoryTypeAheadModel.fromJson(a)).toList();
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class CustomerTypeAheadModel {
  String? name;

  CustomerTypeAheadModel({this.name});

  CustomerTypeAheadModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  static List<CustomerTypeAheadModel> fromJsonArray(List<dynamic> dataList) {
    List<CustomerTypeAheadModel> list =
    dataList.map<CustomerTypeAheadModel>((a) => CustomerTypeAheadModel.fromJson(a)).toList();
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class PaymentModeTypeAheadModel {
  String? name;
  TextEditingController? controller;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PaymentModeTypeAheadModel &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

  PaymentModeTypeAheadModel({this.name,this.controller});

  PaymentModeTypeAheadModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    controller = json['controller'];
  }

  static List<PaymentModeTypeAheadModel> fromJsonArray(List<dynamic> dataList) {
    List<PaymentModeTypeAheadModel> list =
    dataList.map<PaymentModeTypeAheadModel>((a) => PaymentModeTypeAheadModel.fromJson(a)).toList();
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['controller'] = controller;
    return data;
  }
}

class PaymentMode {
  String? id;
  String name;
  TextEditingController controller;
  FocusNode focusNode;

  PaymentMode({
    this.id,
    required this.name,
    required this.controller,
    required this.focusNode,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'controller': controller,
      'focusNode': focusNode,
    };
  }
}


class PModel {
  String? name;
  String? controller;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PModel &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

  PModel({this.name,this.controller});

  PModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    controller = json['controller'];
  }

  static List<PaymentModeTypeAheadModel> fromJsonArray(List<dynamic> dataList) {
    List<PaymentModeTypeAheadModel> list =
    dataList.map<PaymentModeTypeAheadModel>((a) => PaymentModeTypeAheadModel.fromJson(a)).toList();
    return list;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['controller'] = controller;
    return data;
  }
}