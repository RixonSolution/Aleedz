class LabelModel {
  final int id;
  final String label;

  LabelModel({required this.id, required this.label});

  // From JSON (used for decoding from the API response or SharedPreferences)
  factory LabelModel.fromJson(Map<String, dynamic> json) {
    return LabelModel(
      id: json['ROS_LabelID'] as int,
      label: json['ROS_LabelName'] as String,
    );
  }

  // To JSON (used for saving to SharedPreferences)
  Map<String, dynamic> toJson() {
    return {'ROS_LabelID': id, 'ROS_LabelName': label};
  }
}
