class SaleListModel {
  int? brandID;
  int? productCategoryID;
  String? brandName;
  String? productCategoryName;
  int? saleQuantity;
  dynamic saleValue;
  int? saleId;

  SaleListModel({
    this.brandID,
    this.productCategoryID,
    this.brandName,
    this.productCategoryName,
    this.saleQuantity,
    this.saleValue,
    this.saleId,
  });

  SaleListModel.fromJson(Map<String, dynamic> json) {
    brandID = json['BrandID'];
    productCategoryID = json['ProductCategoryID'];
    brandName = json['BrandName'];
    productCategoryName = json['ProductCategoryName'];
    saleQuantity = json['SaleCount'];
    saleValue = json['SalePrice'];
    saleId = json['SaleID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandID'] = this.brandID;
    data['ProductCategoryID'] = this.productCategoryID;
    data['BrandName'] = this.brandName;
    data['ProductCategoryName'] = this.productCategoryName;
    data['SaleCount'] = this.saleQuantity;
    data['SalePrice'] = this.saleValue;
    data['SaleID'] = this.saleId;

    return data;
  }
}
