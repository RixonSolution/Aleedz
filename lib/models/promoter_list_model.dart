class PromoterListModel {
  int? teamMemberID;
  int? storeID;
  String? teamMemberName;
  String? storeName;

  PromoterListModel({
    this.teamMemberID,
    this.storeID,
    this.teamMemberName,
    this.storeName,
  });

  PromoterListModel.fromJson(Map<String, dynamic> json) {
    teamMemberID = json['TeamMemberID'];
    storeID = json['StoreID'];
    teamMemberName = json['TeamMemberName'];
    storeName = json['StoreName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamMemberID'] = this.teamMemberID;
    data['StoreID'] = this.storeID;
    data['TeamMemberName'] = this.teamMemberName;
    data['StoreName'] = this.storeName;
    return data;
  }
}
