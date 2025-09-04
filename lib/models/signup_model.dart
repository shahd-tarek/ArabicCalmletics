class SignUpResponse {
  final String message;
  final String token;

  SignUpResponse({required this.message, required this.token});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      message: json['message'] ?? 'Unknown error',
      token: json['token'] ?? '', // Default empty string if token is missing
    );
  }
}
