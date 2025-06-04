class SaleSearchModel {
  int? productID;
  String? productModelName;
  int? productCategoryID;
  String? productCategoryName;
  int? brandID;
  String? brandName;

  SaleSearchModel({
    this.productID,
    this.productModelName,
    this.productCategoryID,
    this.productCategoryName,
    this.brandID,
    this.brandName,
  });

  SaleSearchModel.fromJson(Map<String, dynamic> json) {
    productID = json['ProductID'];
    productModelName = json['ProductModelName'];
    productCategoryID = json['ProductCategoryID'];
    productCategoryName = json['ProductCategoryName'];
    brandID = json['BrandID'];
    brandName = json['BrandName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductID'] = this.productID;
    data['ProductModelName'] = this.productModelName;
    data['ProductCategoryID'] = this.productCategoryID;
    data['ProductCategoryName'] = this.productCategoryName;
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    return data;
  }
}
