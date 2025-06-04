class SaleListModel {
  int? brandID;
  int? productCategoryID;
  String? brandName;
  String? productCategoryName;
  int? saleQuantity;
  int? saleValue;

  SaleListModel({
    this.brandID,
    this.productCategoryID,
    this.brandName,
    this.productCategoryName,
    this.saleQuantity,
    this.saleValue,
  });

  SaleListModel.fromJson(Map<String, dynamic> json) {
    brandID = json['BrandID'];
    productCategoryID = json['ProductCategoryID'];
    brandName = json['BrandName'];
    productCategoryName = json['ProductCategoryName'];
    saleQuantity = json['SaleQuantity'];
    saleValue = json['SaleValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandID'] = this.brandID;
    data['ProductCategoryID'] = this.productCategoryID;
    data['BrandName'] = this.brandName;
    data['ProductCategoryName'] = this.productCategoryName;
    data['SaleQuantity'] = this.saleQuantity;
    data['SaleValue'] = this.saleValue;
    return data;
  }
}
