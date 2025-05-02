class ChannelModel {
  final int channelId;
  final String channelName;

  ChannelModel({required this.channelId, required this.channelName});

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      channelId: json['ChannelID'] ?? 0,
      channelName: json['ChannelName'] ?? '',
    );
  }

  @override
  String toString() => channelName; // For UI display
}
