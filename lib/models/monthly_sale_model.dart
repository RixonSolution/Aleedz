class MonthlySaleModel {
  int? teamMemberID;
  String? teamMemberName;
  dynamic saleQty;
  dynamic targetQty;
  dynamic achievementQty;

  MonthlySaleModel({
    this.teamMemberID,
    this.teamMemberName,
    this.saleQty,
    this.targetQty,
    this.achievementQty,
  });

  MonthlySaleModel.fromJson(Map<String, dynamic> json) {
    teamMemberID = json['TeamMemberID'];
    teamMemberName = json['TeamMemberName'];
    saleQty = json['SaleQty'];
    targetQty = json['TargetQty'];
    achievementQty = json['AchievementQty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamMemberID'] = this.teamMemberID;
    data['TeamMemberName'] = this.teamMemberName;
    data['SaleQty'] = this.saleQty;
    data['TargetQty'] = this.targetQty;
    data['AchievementQty'] = this.achievementQty;
    return data;
  }
}
