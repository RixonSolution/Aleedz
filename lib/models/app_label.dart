class AppLabel {
  final int rosLabelID;
  final String rosScreen;
  final String rosLabelName;
  final int languageID;
  final String imageLocation;
  final String fixedLabelName;
  final int activeStatus;
  final String? rosLabelName2;
  final String? rosLabelName3;

  AppLabel({
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

  // Factory method to create an AppLabel from JSON
  factory AppLabel.fromJson(Map<String, dynamic> json) {
    return AppLabel(
      rosLabelID: json['ROS_LabelID'],
      rosScreen: json['ROS_Screen'],
      rosLabelName: json['ROS_LabelName'],
      languageID: json['LanguageID'],
      imageLocation: json['ImageLocation'],
      fixedLabelName: json['FixedLabelName'],
      activeStatus: json['ActiveStatus'],
      rosLabelName2: json['ROS_LabelName2'],
      rosLabelName3: json['ROS_LabelName3'],
    );
  }
}
