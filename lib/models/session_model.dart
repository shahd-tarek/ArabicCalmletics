class SessionModel {
  final int sessionId;
  final String sessionName;
  final String sessionNumber;
  final String type; // e.g., "audio", "video", "text"
  final String icon;

  SessionModel({
    required this.sessionId,
    required this.sessionName,
    required this.sessionNumber,
    required this.type,
    required this.icon,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['session_id'],
      sessionName: json['session_name'],
      sessionNumber: json['session_number'],
      type: json['type'],
      icon: json['icon'],
    );
  }

  // Optional: تحويل النوع إلى int (إذا كنت محتاجه لاحقًا)
  int get sessionTypeInt {
    switch (type) {
      case 'video':
        return 1;
      case 'text':
        return 2;
      case 'audio':
      default:
        return 0;
    }
  }
}
