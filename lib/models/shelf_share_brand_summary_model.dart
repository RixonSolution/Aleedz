class ShelfShareBrandSummaryModel {
  int? shelfShareId;
  int? brandId;
  String? brandName;
  int? productCategoryId;
  String? productCategoryName;
  int? weekNo;
  int? year;
  int? facingCount;
  int? stockCount;
  String? displayLocations;
  String? updatedBy;
  String? code;
  String? picture;

  ShelfShareBrandSummaryModel({
    this.shelfShareId,
    this.brandId,
    this.brandName,
    this.productCategoryId,
    this.productCategoryName,
    this.weekNo,
    this.year,
    this.facingCount,
    this.stockCount,
    this.displayLocations,
    this.updatedBy,
    this.code,
    this.picture,
  });

  ShelfShareBrandSummaryModel.fromJson(Map<String, dynamic> json) {
    shelfShareId = int.tryParse(json['ShelfShareID']?.toString() ?? '');
    brandId = int.tryParse(json['BrandID']?.toString() ?? '');
    brandName = json['BrandName'];
    productCategoryId = int.tryParse(json['ProductCategoryID']?.toString() ?? '');
    productCategoryName = json['ProductCategoryName'];
    weekNo = int.tryParse(json['WeekNo']?.toString() ?? '');
    year = int.tryParse(json['Year']?.toString() ?? '');
    facingCount = int.tryParse(json['FacingCount']?.toString() ?? '');
    stockCount = int.tryParse(json['StockCount']?.toString() ?? '');
    displayLocations = json['DisplayLocations'];
    updatedBy = json['UpdatedBy'];
    code = json['Code'];
    picture = json['Picture'];
  }
}
