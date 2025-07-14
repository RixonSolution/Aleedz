class ProductStoreShareModel {
  int? levelID;
  int? brandID;
  String? brandName;
  int? productCategoryID;
  String? productCategoryName;
  int? productID;
  String? productModelCode;
  String? productModelName;
  int? count;
  String? code;
  String? picture;

  ProductStoreShareModel({
    this.levelID,
    this.brandID,
    this.brandName,
    this.productCategoryID,
    this.productCategoryName,
    this.productID,
    this.productModelCode,
    this.productModelName,
    this.count,
    this.code,
    this.picture,
  });

  ProductStoreShareModel.fromJson(Map<String, dynamic> json) {
    levelID = json['LevelID'];
    brandID = json['BrandID'];
    brandName = json['BrandName'];
    productCategoryID = json['ProductCategoryID'];
    productCategoryName = json['ProductCategoryName'];
    productID = json['ProductID'];
    productModelCode = json['ProductModelCode'];
    productModelName = json['ProductModelName'];
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
    data['ProductID'] = this.productID;
    data['ProductModelCode'] = this.productModelCode;
    data['ProductModelName'] = this.productModelName;
    data['Count'] = this.count;
    data['Code'] = this.code;
    data['Picture'] = this.picture;
    return data;
  }
}
