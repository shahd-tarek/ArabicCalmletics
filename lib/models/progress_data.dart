class ProgressData {
  final int sessionNumber;
  final String sessionName;
  final double planPercentage;
  final String taskProgress;
  final double taskPercentage;

  ProgressData({
    required this.sessionNumber,
    required this.sessionName,
    required this.planPercentage,
    required this.taskProgress,
    required this.taskPercentage,
  });

  factory ProgressData.fromJson(Map<String, dynamic> json) {
    return ProgressData(
      sessionNumber: json["your plan"]["session_number"],
      sessionName: json["your plan"]["session_name"],
      planPercentage: double.parse(json["your plan"]["Percentage"].replaceAll('%', '').trim()) / 100,
      taskProgress: json["task's today"]["progress"],
      taskPercentage: double.parse(json["task's today"]["Percentage"].replaceAll('%', '').trim()) / 100,
    );
  }
}
