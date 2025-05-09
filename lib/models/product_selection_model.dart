class ProductSelection {
  final int productId;
  int displayCheck;
  int displayCheckCount;
  final String token;
  final String storeId;
  final String teamMemberId;

  ProductSelection({
    required this.productId,
    this.displayCheck = 0,
    this.displayCheckCount = 0,
    required this.token,
    required this.storeId,
    required this.teamMemberId,
  });

  Map<String, dynamic> toJson() {
    return {
      "ProductID": productId,
      "DisplayCheck": displayCheck,
      "DisplayCheckCount": displayCheckCount,
      "_token": token,
      "StoreID": storeId,
      "TeamMemberID": teamMemberId,
    };
  }
}
