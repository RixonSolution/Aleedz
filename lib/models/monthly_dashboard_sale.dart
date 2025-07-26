class MonthlyDashboardSaleModel {
  double? saleValue;
  int? quantity;

  MonthlyDashboardSaleModel({this.saleValue, this.quantity});

  MonthlyDashboardSaleModel.fromJson(Map<String, dynamic> json) {
    saleValue = json['SaleValue'];
    quantity = json['Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SaleValue'] = this.saleValue;
    data['Quantity'] = this.quantity;
    return data;
  }
}
