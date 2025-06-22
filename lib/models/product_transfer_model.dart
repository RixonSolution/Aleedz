class ProductTransferModel {
  final String token;
  final String transferId;
  final String productId;
  String? isTransfer;
  String? transferCount;
  final String teamMemberId;
  final String storeId;
  final String visitId;

  ProductTransferModel({
    required this.token,
    required this.transferId,
    required this.productId,
    required this.isTransfer,
    required this.transferCount,
    required this.teamMemberId,
    required this.storeId,
    required this.visitId,
  });

  factory ProductTransferModel.fromJson(Map<String, dynamic> json) {
    return ProductTransferModel(
      token: json['_token'],
      transferId: json['TransferID'],
      productId: json['ProductID'],
      isTransfer: json['isTransfer'],
      transferCount: json['TransferCount'],
      teamMemberId: json['TeamMemberID'],
      storeId: json['StoreID'],
      visitId: json['VisitID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_token': token,
      'TransferID': transferId,
      'ProductID': productId,
      'isTransfer': isTransfer,
      'TransferCount': transferCount,
      'TeamMemberID': teamMemberId,
      'StoreID': storeId,
      'VisitID': visitId,
    };
  }
}
