class MonthlyTargetValueModel {
  int? teamMemberID;
  String? teamMemberName;
  dynamic saleValue;
  dynamic targetValue;
  dynamic achievementPercent;

  MonthlyTargetValueModel({
    this.teamMemberID,
    this.teamMemberName,
    this.saleValue,
    this.targetValue,
    this.achievementPercent,
  });

  MonthlyTargetValueModel.fromJson(Map<String, dynamic> json) {
    teamMemberID = json['TeamMemberID'];
    teamMemberName = json['TeamMemberName'];
    saleValue = json['SaleValue'];
    targetValue = json['TargetValue'];
    achievementPercent = json['AchievementPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamMemberID'] = this.teamMemberID;
    data['TeamMemberName'] = this.teamMemberName;
    data['SaleValue'] = this.saleValue;
    data['TargetValue'] = this.targetValue;
    data['AchievementPercent'] = this.achievementPercent;
    return data;
  }
}
