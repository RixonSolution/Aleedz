class ActivityModelType {
  int? activityTypeID;
  String? activityTypeName;
  int? divisionID;
  String? divisionName;

  ActivityModelType({
    this.activityTypeID,
    this.activityTypeName,
    this.divisionID,
    this.divisionName,
  });

  ActivityModelType.fromJson(Map<String, dynamic> json) {
    activityTypeID = json['ActivityTypeID'];
    activityTypeName = json['ActivityTypeName'];
    divisionID = json['DivisionID'];
    divisionName = json['DivisionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ActivityTypeID'] = this.activityTypeID;
    data['ActivityTypeName'] = this.activityTypeName;
    data['DivisionID'] = this.divisionID;
    data['DivisionName'] = this.divisionName;
    return data;
  }
}
