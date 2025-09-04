class SessionContent {
  final int sessionId;
  final String content;
  final String task;
  final String practical;
  final bool keyActive;
  final dynamic booksession;

  SessionContent({
    required this.sessionId,
    required this.content,
    required this.task,
    required this.practical,
    required this.keyActive,
    this.booksession,
  });

  factory SessionContent.fromJson(Map<String, dynamic> json) {
    return SessionContent(
      sessionId: json['session_id'],
      content: json['content'],
      task: json['task'],
      practical: json['practical'],
      keyActive: json['key_active'],
      booksession: json['booksession'],
    );
  }
}
