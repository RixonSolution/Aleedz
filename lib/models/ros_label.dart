class ROSLabel {
  final int rosLabelID;
  final String rosScreen;
  final String rosLabelName;
  final int languageID;
  final String imageLocation;
  final String fixedLabelName;
  final int activeStatus;
  final String? rosLabelName2;
  final String? rosLabelName3;

  ROSLabel({
    required this.rosLabelID,
    required this.rosScreen,
    required this.rosLabelName,
    required this.languageID,
    required this.imageLocation,
    required this.fixedLabelName,
    required this.activeStatus,
    this.rosLabelName2,
    this.rosLabelName3,
  });

  // Factory method to create a ROSLabel from JSON
  factory ROSLabel.fromJson(Map<String, dynamic> json) {
    return ROSLabel(
      rosLabelID: json['ROS_LabelID'],
      rosScreen: json['ROS_Screen'],
      rosLabelName: json['ROS_LabelName'],
      languageID: json['LanguageID'],
      imageLocation: json['ImageLocation'] ?? '',
      fixedLabelName: json['FixedLabelName'],
      activeStatus: json['ActiveStatus'],
      rosLabelName2: json['ROS_LabelName2'],
      rosLabelName3: json['ROS_LabelName3'],
    );
  }

  // Convert a ROSLabel to a map (for use in sending requests)
  Map<String, dynamic> toJson() {
    return {
      'ROS_LabelID': rosLabelID,
      'ROS_Screen': rosScreen,
      'ROS_LabelName': rosLabelName,
      'LanguageID': languageID,
      'ImageLocation': imageLocation,
      'FixedLabelName': fixedLabelName,
      'ActiveStatus': activeStatus,
      'ROS_LabelName2': rosLabelName2,
      'ROS_LabelName3': rosLabelName3,
    };
  }
}
