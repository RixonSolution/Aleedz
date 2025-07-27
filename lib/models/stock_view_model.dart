class StockListModel {
  String? productCategoryName;
  String? productCategoryName1;
  int? brandID;
  String? brandName;
  int? productID;
  String? productModelCode;
  String? productModelName;
  int? stock;
  int? inputType;

  StockListModel({
    this.productCategoryName,
    this.productCategoryName1,
    this.brandID,
    this.brandName,
    this.productID,
    this.productModelCode,
    this.productModelName,
    this.stock,
    this.inputType,
  });

  StockListModel.fromJson(Map<String, dynamic> json) {
    productCategoryName = json['ProductCategoryName'];
    productCategoryName1 = json['ProductCategoryName1'];
    brandID = json['BrandID'];
    brandName = json['BrandName'];
    productID = json['ProductID'];
    productModelCode = json['ProductModelCode'];
    productModelName = json['ProductModelName'];
    stock = json['Stock'];
    inputType = json['InputType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductCategoryName'] = this.productCategoryName;
    data['ProductCategoryName1'] = this.productCategoryName1;
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['ProductID'] = this.productID;
    data['ProductModelCode'] = this.productModelCode;
    data['ProductModelName'] = this.productModelName;
    data['Stock'] = this.stock;
    data['InputType'] = this.inputType;
    return data;
  }
}
