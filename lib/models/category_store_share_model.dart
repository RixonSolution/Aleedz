class CategoryStoreShareModel {
  int? levelID;
  int? brandID;
  String? brandName;
  int? productCategoryID;
  String? productCategoryName;
  int? facingCount;
  int? stockCount;
  int? count;
  String? code;
  String? picture;

  CategoryStoreShareModel({
    this.levelID,
    this.brandID,
    this.brandName,
    this.productCategoryID,
    this.productCategoryName,
    this.facingCount,
    this.stockCount,
    this.count,
    this.code,
    this.picture,
  });

  CategoryStoreShareModel.fromJson(Map<String, dynamic> json) {
    levelID = json['LevelID'];
    brandID = json['BrandID'];
    brandName = json['BrandName'];
    productCategoryID = json['ProductCategoryID'];
    productCategoryName = json['ProductCategoryName'];
    facingCount = int.tryParse(json['FacingCount']?.toString() ?? '');
    stockCount = int.tryParse(json['StockCount']?.toString() ?? '');
    count = json['Count'];
    code = json['Code'];
    picture = json['Picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LevelID'] = this.levelID;
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['ProductCategoryID'] = this.productCategoryID;
    data['ProductCategoryName'] = this.productCategoryName;
    data['FacingCount'] = this.facingCount;
    data['StockCount'] = this.stockCount;
    data['Count'] = this.count;
    data['Code'] = this.code;
    data['Picture'] = this.picture;
    return data;
  }
}
