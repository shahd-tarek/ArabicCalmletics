class Session {
  final int sessionId;
  final String sessionName;
  final String sessionNumber;
  final String status;
   final int sessionType;

  Session({
    required this.sessionId,
    required this.sessionName,
    required this.sessionNumber,
    required this.status,
    required this.sessionType,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionId: json['session_id'],
      sessionName: json['session_name'],
      sessionNumber: json['session_number'],
      status: json['status'],
      sessionType: json["session_type"]
    );
  }
}
