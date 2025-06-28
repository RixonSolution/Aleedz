class TraingModel {
  int? trainingModelID;
  String? trainingModelTitle;
  int? trainingModelFeatureID;
  String? trainingModelFeatureTitle;

  TraingModel({
    this.trainingModelID,
    this.trainingModelTitle,
    this.trainingModelFeatureID,
    this.trainingModelFeatureTitle,
  });

  TraingModel.fromJson(Map<String, dynamic> json) {
    trainingModelID = json['TrainingModelID'];
    trainingModelTitle = json['TrainingModelTitle'];
    trainingModelFeatureID = json['TrainingModelFeatureID'];
    trainingModelFeatureTitle = json['TrainingModelFeatureTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TrainingModelID'] = this.trainingModelID;
    data['TrainingModelTitle'] = this.trainingModelTitle;
    data['TrainingModelFeatureID'] = this.trainingModelFeatureID;
    data['TrainingModelFeatureTitle'] = this.trainingModelFeatureTitle;
    return data;
  }
}
