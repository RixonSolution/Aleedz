class FieldUserModel {
  int? teamMemberId;
  String? teamMemberName;

  FieldUserModel({this.teamMemberId, this.teamMemberName});

  FieldUserModel.fromJson(Map<String, dynamic> json) {
    teamMemberId = json['TeamMemberID'];
    teamMemberName = json['TeamMemberName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TeamMemberID'] = teamMemberId;
    data['TeamMemberName'] = teamMemberName;
    return data;
  }
}
