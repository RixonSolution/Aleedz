import 'package:intl/intl.dart';

class DisplayComplianceModel {
  int? displayComplianceId;
  String? displayComplianceDate;
  String? pictureId;
  int? display;
  int? posmAvailable;
  int? displayGuidlineId;
  int? quantity;
  String? brandName;
  int? productCategoryId;
  String? productCategoryName;
  int? brandId;
  int? displayLocationId;
  String? displayLocationName;
  String? status;
  DateTime? parsedDate;

  DisplayComplianceModel({
    this.displayComplianceId,
    this.displayComplianceDate,
    this.pictureId,
    this.display,
    this.posmAvailable,
    this.displayGuidlineId,
    this.quantity,
    this.brandName,
    this.productCategoryId,
    this.productCategoryName,
    this.brandId,
    this.displayLocationId,
    this.displayLocationName,
    this.status,
    this.parsedDate,
  });

  DisplayComplianceModel.fromJson(Map<String, dynamic> json) {
    displayComplianceId = json['DisplayComplianceID'];
    displayComplianceDate = json['DisplayComplianceDate'];
    pictureId = json['PictureID'];
    display = json['Display'];
    posmAvailable = json['POSMAvailable'];
    displayGuidlineId = json['DisplayGuidlineID'];
    quantity = json['Quantity'];
    brandName = json['BrandName'];
    productCategoryId = json['ProductCategoryID'];
    productCategoryName = json['ProductCategoryName'];
    brandId = json['BrandID'];
    displayLocationId = json['DisplayLocationID'];
    displayLocationName = json['DisplayLocaitonName'];
    status = json['Status'];
    parsedDate = _parseDotNetDate(displayComplianceDate);
  }

  String get formattedDate {
    final date = parsedDate;
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  DateTime? _parseDotNetDate(String? value) {
    if (value == null || value.isEmpty) return null;
    final match = RegExp(r'/Date\((\d+)\)/').firstMatch(value);
    if (match == null) return null;
    final millis = int.tryParse(match.group(1) ?? '');
    if (millis == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  Map<String, dynamic> toJson() {
    return {
      'DisplayComplianceID': displayComplianceId,
      'DisplayComplianceDate': displayComplianceDate,
      'PictureID': pictureId,
      'Display': display,
      'POSMAvailable': posmAvailable,
      'DisplayGuidlineID': displayGuidlineId,
      'Quantity': quantity,
      'BrandName': brandName,
      'ProductCategoryID': productCategoryId,
      'ProductCategoryName': productCategoryName,
      'BrandID': brandId,
      'DisplayLocationID': displayLocationId,
      'DisplayLocaitonName': displayLocationName,
      'Status': status,
    };
  }
}
