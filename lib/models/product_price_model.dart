class ProductPriceEntry {
  final String token;
  final String productId;
  final String storeId;
  final String price;
  final String promotion;
  final String priceTagPictureId;
  final String? teamMemberId;
  final String netPrice;
  final String installment3Month;
  final String installment6Month;
  final String installment12Month;
  final bool isOutOfStock;
  final String visitId;
  String? priceImage;

  ProductPriceEntry({
    required this.token,
    required this.productId,
    required this.storeId,
    required this.price,
    required this.promotion,
    required this.priceTagPictureId,
    required this.teamMemberId,
    required this.netPrice,
    required this.installment3Month,
    required this.installment6Month,
    required this.installment12Month,
    required this.isOutOfStock,
    required this.visitId,
    this.priceImage,
  });

  Map<String, dynamic> toJson() {
    return {
      "_token": token,
      "ProductID": productId,
      "StoreID": storeId,
      "Price": price,
      "Promotion": promotion,
      "PiceTagPictureID": priceTagPictureId,
      "TeamMemberID": teamMemberId,
      "NetPrice": netPrice,
      "Installment_3Month": installment3Month,
      "Installment_6Month": installment6Month,
      "Installment_12Month": installment12Month,
      "IsOutOFStock": isOutOfStock ? 1 : 0,
      "VisitID": visitId,
      "PricesImg": priceImage,
    };
  }
}
