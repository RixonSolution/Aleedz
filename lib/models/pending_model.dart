class PendingModel {
  int? activityCategoryID;
  int? storeID;
  String? planDateTime;
  String? taskDeploymentCategoryName;
  String? activityCategoryName;
  String? storeCode;
  String? storeName;

  PendingModel({
    this.activityCategoryID,
    this.storeID,
    this.planDateTime,
    this.taskDeploymentCategoryName,
    this.activityCategoryName,
    this.storeCode,
    this.storeName,
  });

  PendingModel.fromJson(Map<String, dynamic> json) {
    activityCategoryID = json['ActivityCategoryID'];
    storeID = json['StoreID'];
    planDateTime = json['PlanDateTime'];
    taskDeploymentCategoryName = json['TaskDeploymentCategoryName'];
    activityCategoryName = json['ActivityCategoryName'];
    storeCode = json['StoreCode'];
    storeName = json['StoreName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ActivityCategoryID'] = this.activityCategoryID;
    data['StoreID'] = this.storeID;
    data['PlanDateTime'] = this.planDateTime;
    data['TaskDeploymentCategoryName'] = this.taskDeploymentCategoryName;
    data['ActivityCategoryName'] = this.activityCategoryName;
    data['StoreCode'] = this.storeCode;
    data['StoreName'] = this.storeName;
    return data;
  }
}
