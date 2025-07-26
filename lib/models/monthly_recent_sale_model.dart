class MonthlyRecentSaleModel {
  final DateTime creationDateTime;
  final double saleValue;
  final int quantity;

  MonthlyRecentSaleModel({
    required this.creationDateTime,
    required this.saleValue,
    required this.quantity,
  });

  factory MonthlyRecentSaleModel.fromJson(Map<String, dynamic> json) {
    final dateString = json['CreationDateTime'] as String;
    final timestamp = int.parse(dateString.replaceAll(RegExp(r'[^\d]'), ''));
    return MonthlyRecentSaleModel(
      creationDateTime: DateTime.fromMillisecondsSinceEpoch(timestamp),
      saleValue: (json['SaleValue'] ?? 0).toDouble(),
      quantity: (json['Quantity'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CreationDateTime': creationDateTime.millisecondsSinceEpoch,
      'SaleValue': saleValue,
      'Quantity': quantity,
    };
  }
}
