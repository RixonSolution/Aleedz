class UserTrainingType {
  int? trainingTypeID;
  String? trainingTypeName;
  int? activeStatus;

  UserTrainingType({
    this.trainingTypeID,
    this.trainingTypeName,
    this.activeStatus,
  });

  UserTrainingType.fromJson(Map<String, dynamic> json) {
    trainingTypeID = json['TrainingTypeID'];
    trainingTypeName = json['TrainingTypeName'];
    activeStatus = json['ActiveStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TrainingTypeID'] = this.trainingTypeID;
    data['TrainingTypeName'] = this.trainingTypeName;
    data['ActiveStatus'] = this.activeStatus;
    return data;
  }
}
