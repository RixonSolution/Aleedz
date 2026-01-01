class AuditItem {
  final int brandId;
  final String brandName;
  final int productId;
  final String productModelName;
  final String productModelCode;
  final int productCategoryId;
  final String productCategoryName;
  final int storeId;
  final int displayCheck;
  final int displayCheckCount;
  final int inputType;

  AuditItem({
    required this.brandId,
    required this.brandName,
    required this.productId,
    required this.productModelName,
    required this.productModelCode,
    required this.productCategoryId,
    required this.productCategoryName,
    required this.storeId,
    required this.displayCheck,
    required this.displayCheckCount,
    required this.inputType,
  });

  factory AuditItem.fromJson(Map<String, dynamic> json) {
    return AuditItem(
      brandId: json["BrandID"],
      brandName: json["BrandName"],
      productId: json["Productid"],
      productModelName: json["Productmodelname"],
      productModelCode: json["productmodelcode"],
      productCategoryId: json["ProductCategoryID"],
      productCategoryName: json["ProductCategoryName"],
      storeId: json["Storeid"],
      displayCheck: json["DisplayCheck"],
      displayCheckCount: json["DisplayCheckCount"],
      inputType: json["inputType"] ?? json["InputType"] ?? 0,
    );
  }
}
