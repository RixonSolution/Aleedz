class DisplayCheckModel {
  final int displayCheckMasterID;
  final String displayCheckDate; // Keep as-is
  final int productCategoryID;
  final int storeID;
  final String displayCheckRemarks;
  final String image1;
  final String image2;
  final int teamMemberID;

  DisplayCheckModel({
    required this.displayCheckMasterID,
    required this.displayCheckDate,
    required this.productCategoryID,
    required this.storeID,
    required this.displayCheckRemarks,
    required this.image1,
    required this.image2,
    required this.teamMemberID,
  });

  factory DisplayCheckModel.fromJson(Map<String, dynamic> json) {
    return DisplayCheckModel(
      displayCheckMasterID: json['DisplayCheckMasterID'],
      displayCheckDate: json['DisplayCheckDate'],
      productCategoryID: json['ProductCategoryID'],
      storeID: json['StoreID'],
      displayCheckRemarks: json['DisplayCheckRemarks'],
      image1: json['Column1'],
      image2: json['Column2'],
      teamMemberID: json['TeamMemberID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DisplayCheckMasterID': displayCheckMasterID,
      'DisplayCheckDate': displayCheckDate,
      'ProductCategoryID': productCategoryID,
      'StoreID': storeID,
      'DisplayCheckRemarks': displayCheckRemarks,
      'Column1': image1,
      'Column2': image2,
      'TeamMemberID': teamMemberID,
    };
  }
}
