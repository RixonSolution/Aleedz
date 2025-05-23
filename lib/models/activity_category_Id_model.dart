class ActivityCategoryModel {
  int? activityTypeID;
  String? activityTypeName;
  int? activityCategoryID;
  String? activityCategoryName;
  int? divisionID;
  String? divisionName;
  int? taskDeploymentCategoryID;
  String? taskDeploymentCategoryName;
  int? isParent;
  int? withSerialNumber;

  ActivityCategoryModel({
    this.activityTypeID,
    this.activityTypeName,
    this.activityCategoryID,
    this.activityCategoryName,
    this.divisionID,
    this.divisionName,
    this.taskDeploymentCategoryID,
    this.taskDeploymentCategoryName,
    this.isParent,
    this.withSerialNumber,
  });

  ActivityCategoryModel.fromJson(Map<String, dynamic> json) {
    activityTypeID = json['ActivityTypeID'];
    activityTypeName = json['ActivityTypeName'];
    activityCategoryID = json['ActivityCategoryID'];
    activityCategoryName = json['ActivityCategoryName'];
    divisionID = json['DivisionID'];
    divisionName = json['DivisionName'];
    taskDeploymentCategoryID = json['TaskDeploymentCategoryID'];
    taskDeploymentCategoryName = json['TaskDeploymentCategoryName'];
    isParent = json['IsParent'];
    withSerialNumber = json['WithSerialNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ActivityTypeID'] = this.activityTypeID;
    data['ActivityTypeName'] = this.activityTypeName;
    data['ActivityCategoryID'] = this.activityCategoryID;
    data['ActivityCategoryName'] = this.activityCategoryName;
    data['DivisionID'] = this.divisionID;
    data['DivisionName'] = this.divisionName;
    data['TaskDeploymentCategoryID'] = this.taskDeploymentCategoryID;
    data['TaskDeploymentCategoryName'] = this.taskDeploymentCategoryName;
    data['IsParent'] = this.isParent;
    data['WithSerialNumber'] = this.withSerialNumber;
    return data;
  }
}
