class PriceListModel {
  int? brandID;
  String? brandName;
  int? productID;
  String? productmodelname;
  String? productModelCode;
  int? productCategoryID;
  String? productCategoryName;
  int? storeID;
  int? gradeID;
  dynamic priceID;
  dynamic productID1;
  dynamic storeID1;
  dynamic price;
  dynamic promotion;
  dynamic piceTagPictureID;
  dynamic creationDateTime;
  dynamic activeStatus;
  dynamic teamMemberID;
  dynamic netPrice;
  dynamic installment3Month;
  dynamic installment6Month;
  dynamic installment12Month;
  dynamic isOutOFStock;
  dynamic visitID;

  PriceListModel({
    this.brandID,
    this.brandName,
    this.productID,
    this.productmodelname,
    this.productModelCode,
    this.productCategoryID,
    this.productCategoryName,
    this.storeID,
    this.gradeID,
    this.priceID,
    this.productID1,
    this.storeID1,
    this.price,
    this.promotion,
    this.piceTagPictureID,
    this.creationDateTime,
    this.activeStatus,
    this.teamMemberID,
    this.netPrice,
    this.installment3Month,
    this.installment6Month,
    this.installment12Month,
    this.isOutOFStock,
    this.visitID,
  });

  PriceListModel.fromJson(Map<String, dynamic> json) {
    brandID = json['BrandID'];
    brandName = json['BrandName'];
    productID = json['ProductID'];
    productmodelname = json['productmodelname'];
    productModelCode = json['ProductModelCode'];
    productCategoryID = json['ProductCategoryID'];
    productCategoryName = json['ProductCategoryName'];
    storeID = json['StoreID'];
    gradeID = json['GradeID'];
    priceID = json['PriceID'];
    productID1 = json['ProductID1'];
    storeID1 = json['StoreID1'];
    price = json['Price'];
    promotion = json['Promotion'];
    piceTagPictureID = json['PiceTagPictureID'];
    creationDateTime = json['CreationDateTime'];
    activeStatus = json['ActiveStatus'];
    teamMemberID = json['TeamMemberID'];
    netPrice = json['NetPrice'];
    installment3Month = json['Installment_3Month'];
    installment6Month = json['Installment_6Month'];
    installment12Month = json['Installment_12Month'];
    isOutOFStock = json['IsOutOFStock'];
    visitID = json['VisitID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['ProductID'] = this.productID;
    data['productmodelname'] = this.productmodelname;
    data['ProductModelCode'] = this.productModelCode;
    data['ProductCategoryID'] = this.productCategoryID;
    data['ProductCategoryName'] = this.productCategoryName;
    data['StoreID'] = this.storeID;
    data['GradeID'] = this.gradeID;
    data['PriceID'] = this.priceID;
    data['ProductID1'] = this.productID1;
    data['StoreID1'] = this.storeID1;
    data['Price'] = this.price;
    data['Promotion'] = this.promotion;
    data['PiceTagPictureID'] = this.piceTagPictureID;
    data['CreationDateTime'] = this.creationDateTime;
    data['ActiveStatus'] = this.activeStatus;
    data['TeamMemberID'] = this.teamMemberID;
    data['NetPrice'] = this.netPrice;
    data['Installment_3Month'] = this.installment3Month;
    data['Installment_6Month'] = this.installment6Month;
    data['Installment_12Month'] = this.installment12Month;
    data['IsOutOFStock'] = this.isOutOFStock;
    data['VisitID'] = this.visitID;
    return data;
  }
}
