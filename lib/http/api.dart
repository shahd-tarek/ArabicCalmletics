// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calmleticsarab/helper/token_helper.dart';
import 'package:calmleticsarab/models/login_model.dart';
import 'package:calmleticsarab/models/plan_model.dart';
import 'package:calmleticsarab/models/signup_model.dart';

class Api {
  static const String baseUrl =
      "https://calmletics-production.up.railway.app/api";

  Future<SignUpResponse> signUp(
    String name,
    String email,
    String password,
    String passwordConfirmation,
    String userRole,
  ) async {
    debugPrint("Signing up as: $userRole");
    String signUpUrl =
        userRole == "Coach"
            ? "https://calmletics-production.up.railway.app/api/coach/sign"
            : "$baseUrl/player/sign";

    try {
      final response = await http.post(
        Uri.parse(signUpUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        }),
      );
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        final token = jsonResponse['token'];

        await TokenHelper.saveToken(token);

        return SignUpResponse.fromJson(jsonResponse);
      } else {
        return SignUpResponse(
          message: "Error: ${response.statusCode} - ${response.reasonPhrase}",
          token: '',
        );
      }
    } catch (e) {
      return SignUpResponse(
        message: "Failed to connect to the server.",
        token: '',
      );
    }
  }

  Future<LoginResponse> loginUser(
    String email,
    String password,
    String userRole,
  ) async {
    String loginUrl =
        userRole == "Coach"
            ? "https://calmletics-production.up.railway.app/api/coach/login"
            : "$baseUrl/player/login";

    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      final token = jsonResponse['token'];

      await TokenHelper.saveToken(token);

      return LoginResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to log in. Status code: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    String? token = await TokenHelper.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/player/userInfo'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getScore() async {
    String? token = await TokenHelper.getToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/player/getScore'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Failed to fetch score: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching score: $e");
      return null;
    }
  }

  Future<bool> saveScore(int score) async {
    String? token = await TokenHelper.getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/player/getScore'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({"score": score}),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error saving score: $e");
      return false;
    }
  }

  Future<bool> updateUserProfile(String name, String email, String flag) async {
    String? token = await TokenHelper.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/editprofile'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({"name": name, "email": email, "flag": flag}),
    );

    return response.statusCode == 200;
  }

  Future<bool> changePassword(
    String oldPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    String? token = await TokenHelper.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/updatepassword'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        "old_password": oldPassword,
        "password": newPassword,
        "password_confirmation": confirmPassword,
      }),
    );

    return response.statusCode == 200;
  }

  Future<bool> saveSelectedAvatar(String avatarUrl) async {
    String? token = await TokenHelper.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/player/image'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'image': avatarUrl}),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> getUserAnswers() async {
    String? token = await TokenHelper.getToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/player/getanswers'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);

        if (jsonResponse is Map<String, dynamic>) {
          return jsonResponse;
        } else if (jsonResponse is List) {
          return {"answers": jsonResponse};
        } else {
          print("Unexpected JSON format: $jsonResponse");
          return null;
        }
      } else {
        print("Failed to fetch answers: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching answers: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getStoredAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedAnswers = prefs.getString("user_answers");

    return jsonDecode(storedAnswers!);
  }

  Future<bool> saveCard(
    String name,
    String number,
    String date,
    String cvv,
  ) async {
    const String url = "$baseUrl/coach/card/store";
    String? token = await TokenHelper.getToken();
    print("TOKEN: $token");

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final Map<String, dynamic> body = {
      "name": name,
      "number": number,
      "date": date,
      "cvv": cvv,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error saving card: $e");
      return false;
    }
  }

  // cluster
  Future<Map<String, dynamic>?> sendAnswersToAI(
    Map<String, dynamic> answers,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:5000/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(answers),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Failed to send answers to AI API: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error sending answers to AI API: $e");
      return null;
    }
  }

  //cluster num
  Future<bool> sendClusterNumber(int clusterNumber) async {
    String? token = await TokenHelper.getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/player/cluster'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"cluster": clusterNumber}),
      );

      print("📡 Sending cluster number: $clusterNumber");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Error sending cluster number: $e");
      return false;
    }
  }

  Future<int?> forwardRecommendationAnswersToLocalAPI() async {
    String? token = await TokenHelper.getToken();

    try {
      // Step 1: Get recommendation answers from production API
      final response = await http.get(
        Uri.parse('$baseUrl/player/get_recommendation_answers'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final recommendationData = jsonDecode(response.body);
        // Step 2: Send the data to the local recommendation API
        final postResponse = await http.post(
          Uri.parse(
            'http://10.0.2.2:5000/recommend',
          ), // or 'http://10.0.2.2:5000/recommend' for Android emulator
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "anxiety_level": recommendationData["anxiety_level"],
            "Preferred_Content": recommendationData["Preferred_Content"],
            "Daily_App_Usage": recommendationData["Daily_App_Usage"],
          }),
        );

        print("🔁 Forwarded to Local API");
        print("Status Code: ${postResponse.statusCode}");

        if (postResponse.statusCode == 200) {
          final responseData = jsonDecode(postResponse.body);
          final recommendedPlanId = responseData["recommended_plan_id"];

          print("🎯 Recommended Plan ID: $recommendedPlanId");
          return recommendedPlanId;
        } else {
          print("❌ Local API failed: ${postResponse.statusCode}");
          return null;
        }
      } else {
        print("❌ Failed to get recommendation answers: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Error in forwarding recommendation answers: $e");
      return null;
    }
  }

  Future<bool> joinFreeCommunity() async {
    String? token = await TokenHelper.getToken();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/player/join'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📡 Sending request to get community status...");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error fetching community status: $e");
      return false;
    }
  }

  Future<bool> sendFlag(String flagCode) async {
    String? token = await TokenHelper.getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/player/flag'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"flag": flagCode}),
      );

      print("📡 Sending flag: $flagCode");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Error sending flag: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchSessions() async {
    String? token = await TokenHelper.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/player/get-sessions'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Session> sessions =
          (data['session_list'] as List)
              .map((json) => Session.fromJson(json))
              .toList();
      return {
        'percentage': data['Percentage'],
        'count': data['count'],
        'sessions': sessions,
      };
    } else {
      throw Exception('Failed to load sessions: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchSessionContent(int sessionId) async {
    String? token = await TokenHelper.getToken();

    final response = await http.get(
      Uri.parse(
        "https://calmletics-production.up.railway.app/api/player/get-session-content?session_id=$sessionId",
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load session content: ${response.statusCode}");
    }
  }

  // plans
  Future<List<Map<String, dynamic>>> fetchPlans(String level) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    try {
      final response = await http.get(
        Uri.parse(
          'https://calmletics-production.up.railway.app/api/coach/plans?level=${level.toLowerCase()}',
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📡 Fetching plans for level: $level");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['plans'] is List) {
          return List<Map<String, dynamic>>.from(data['plans']);
        } else {
          print("❌ Unexpected data format for 'plans'");
          return [];
        }
      } else {
        print("❌ Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ Error fetching plans: $e");
      return [];
    }
  }

  //create community
  Future<Map<String, dynamic>> createcom(
    String communityName,
    String level,
    String planId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");
    try {
      final response = await http.post(
        Uri.parse(
          'https://calmletics-production.up.railway.app/api/coach/compre/create',
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'name': communityName,
          'level': level,
          'plan_id': planId,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'Failed to create community. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  //all communities
  Future<List<Map<String, dynamic>>> fetchCommunities() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    final url = Uri.parse(
      "https://calmletics-production.up.railway.app/api/coach/communtities",
    );
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final communities = json['communities'] as List;
        return communities.map((e) => e as Map<String, dynamic>).toList();
      } else {
        print('Failed to fetch communities: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching communities: $e');
      return [];
    }
  }

  //Filter all Communities
  Future<List<Map<String, dynamic>>> fetchFilterCommunity(String level) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    try {
      final response = await http.get(
        Uri.parse(
          'https://calmletics-production.up.railway.app/api/coach/communtities?level=${level.toLowerCase()}',
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("📡 Fetching communities for level: $level");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['communities'] is List) {
          return List<Map<String, dynamic>>.from(data['communities']);
        } else {
          print("❌ Unexpected data format for 'communities'");
          return [];
        }
      } else {
        print("❌ Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ Error fetching communities: $e");
      return [];
    }
  }

  //all players in communities
  Future<List<Map<String, dynamic>>> fetchPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");
    final url = Uri.parse("$baseUrl/coach/players");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final players = json['players'] ?? json['data']['players'];

        if (players is List) {
          return players.map((e) => e as Map<String, dynamic>).toList();
        } else {
          if (kDebugMode) {
            print('Unexpected data format for players');
          }
          return [];
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch players: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching players: $e');
      }
      return [];
    }
  }

  //Filtered Players in all communities
  Future<List<Map<String, dynamic>>> fetchFilteredPlayers(String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");
    final url = Uri.parse("$baseUrl/coach/players?status=$status");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final players = json['players'] ?? json['data']?['players'];

        if (players is List) {
          return players.cast<Map<String, dynamic>>();
        } else {
          if (kDebugMode) print('Unexpected data format for players');
          return [];
        }
      } else {
        if (kDebugMode) {
          print('Failed to fetch players: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) print('Error fetching players: $e');
      return [];
    }
  }

  //all player number
  Future<int?> fetchPlayerCount() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");
    final url = Uri.parse("$baseUrl/coach/players-count");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['player_count'] as int;
      } else {
        if (kDebugMode) {
          print('Failed to fetch player count: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching player count: $e');
      }
      return null;
    }
  }

  //community details
  static Future<Map<String, dynamic>> comDetails(String communityId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    final url = Uri.parse(
      "https://calmletics-production.up.railway.app/api/coach/community-details?community_id=$communityId",
    );

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final communityName = data['community_name'];
        final communityCode = data['community_code'];
        final playersCount = data['players_count'];
        final communityLevel = data['community_level'];
        final players =
            (data['players'] as List?)?.cast<Map<String, dynamic>>() ?? [];
        final sessions =
            (data['sessions'] as List?)?.cast<Map<String, dynamic>>() ?? [];

        return {
          'community_name': communityName,
          'community_code': communityCode,
          'players_count': playersCount,
          'community_level': communityLevel,
          'players': players,
          'sessions': sessions,
        };
      } else {
        print('Failed to fetch community details: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error fetching community details: $e');
      return {};
    }
  }

  //top player
  static Future<List<Map<String, dynamic>>> fetchTopplayer(
    String communityId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    final url = Uri.parse(
      "https://calmletics-production.up.railway.app/api/coach/leaderboard?community_id=$communityId",
    );

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // تجيب others فقط
        List top3 = data['top3'] ?? [];

        return top3
            .map<Map<String, dynamic>>(
              (user) => {
                "name": user["name"],
                "image": user["image"],
                "flag": user["flag"],
                "com_pre_id": user["com_pre_id"],
                "user_id": user["user_id"],
                "total_score": user["total_score"],
                "rank": user["rank"],
              },
            )
            .toList();
      } else {
        print('Failed to fetch leaderboard: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }

  //community player
  static Future<List<Map<String, dynamic>>> fetchCommunityplayer(
    String communityId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    final url = Uri.parse(
      "https://calmletics-production.up.railway.app/api/coach/community-members-status?community_id=$communityId",
    );

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List players = data['players'] ?? [];

        return players
            .map<Map<String, dynamic>>(
              (player) => {
                "player_id": player["player_id"],
                "player_name": player["player_name"],
                "community_name": player["community_name"],
                "status_message": player["status_message"],
                "status_image": player["status_image"],
                "image": player["image"],
              },
            )
            .toList();
      } else {
        print('Failed to fetch players: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching players: $e');
      return [];
    }
  }

  // Filter player in community
  static Future<List<Map<String, dynamic>>> fetchCommunityFilterplayer(
    String communityId,
    String status,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");

    final url = Uri.parse(
      "https://calmletics-production.up.railway.app/api/coach/community-members-status"
      "?community_id=$communityId&status=$status",
    );

    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List players = data['players'] ?? [];

        return players.map<Map<String, dynamic>>((player) {
          return {
            "player_id": player["player_id"],
            "player_name": player["player_name"],
            "community_name": player["community_name"],
            "status_message": player["status_message"],
            "status_image": player["status_image"],
            "image": player["image"],
          };
        }).toList();
      } else {
        print('Failed to fetch filtered players: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching filtered players: $e');
      return [];
    }
  }

  // delate community
  static Future<Map<String, dynamic>> delateCommunity(
    String communityId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    final url = Uri.parse("$baseUrl/coach/delete-community");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = jsonEncode({"community_id": communityId});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": true,
          "message": data["message"] ?? "Community deleted successfully",
        };
      } else {
        print('Failed to delete community: ${response.statusCode}');
        print('Response body: ${response.body}');
        final errorData = jsonDecode(response.body);
        return {
          "success": false,
          "error":
              errorData["error"] ??
              "Failed to delete community. Status code: ${response.statusCode}",
        };
      }
    } catch (e) {
      print('Error deleting community: $e');
      return {"success": false, "error": "Exception occurred: $e"};
    }
  }

  Future<Map<String, dynamic>> fetchSessionsByPlanId(String planId) async {
    String? token = await TokenHelper.getToken();
    final response = await http.post(
      Uri.parse(
        'https://calmletics-production.up.railway.app/api/coach/sessions',
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'plan_id': planId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load sessions');
    }
  }

  //update-community-name
  static Future<Map<String, dynamic>> updateCommunityName(
    String communityId,
    String newName,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");

    if (token == null) {
      return {
        "success": false,
        "error": "Token not found. Please log in again.",
      };
    }

    final url = Uri.parse("$baseUrl/coach/update-community-name");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = jsonEncode({"community_id": communityId, 'new_name': newName});

    try {
      final response = await http.post(url, headers: headers, body: body);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": data["message"] ?? "Player removed successfully.",
        };
      } else {
        return {
          "success": false,
          "error": data["error"] ?? "Failed to remove player.",
        };
      }
    } catch (e) {
      return {"success": false, "error": "Exception occurred: $e"};
    }
  }

  //remove player
  static Future<Map<String, dynamic>> removePlayer(int playerId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("user_token");

    if (token == null) {
      return {
        "success": false,
        "error": "Token not found. Please log in again.",
      };
    }

    final url = Uri.parse("$baseUrl/coach/remove-player-from-community");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = jsonEncode({
      "player_id": playerId, // Required for identifying the player
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": data["message"] ?? "Player removed successfully.",
        };
      } else {
        return {
          "success": false,
          "error": data["error"] ?? "Failed to remove player.",
        };
      }
    } catch (e) {
      return {"success": false, "error": "Exception occurred: $e"};
    }
  }

  //coach leaderboard
  static Future<Map<String, List<Map<String, dynamic>>>> fetchCoachLeaderboard(
    String communityId,
    String time,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    final url = Uri.parse(
      "https://calmletics-production.up.railway.app/api/coach/leaderboard?time=$time&community_id=$communityId",
    );

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List top3 = data['top3'] ?? [];
        List others = data['others'] ?? [];

        List<Map<String, dynamic>> parseUsers(List<dynamic> users) {
          return users
              .map<Map<String, dynamic>>(
                (user) => {
                  "name": user["name"],
                  "image": user["image"],
                  "flag": user["flag"],
                  "com_pre_id": user["com_pre_id"],
                  "user_id": user["user_id"],
                  "total_score": user["total_score"],
                  "rank": user["rank"],
                },
              )
              .toList();
        }

        return {"top3": parseUsers(top3), "others": parseUsers(others)};
      } else {
        print('Failed to fetch leaderboard: ${response.statusCode}');
        return {"top3": [], "others": []};
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return {"top3": [], "others": []};
    }
  }

  //free leaderboard
  static Future<Map<String, List<Map<String, dynamic>>>> fetchFreeLeaderboard(
    String time,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    final url = Uri.parse("$baseUrl/player/leaderboard?time=$time");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List top3 = data['top3'] ?? [];
        List others = data['others'] ?? [];

        List<Map<String, dynamic>> parseUsers(List<dynamic> users) {
          return users
              .map<Map<String, dynamic>>(
                (user) => {
                  "name": user["name"],
                  "image": user["image"],
                  "flag": user["flag"],
                  "com_pre_id": user["com_pre_id"],
                  "user_id": user["user_id"],
                  "total_score": user["total_score"],
                  "rank": user["rank"],
                },
              )
              .toList();
        }

        return {"top3": parseUsers(top3), "others": parseUsers(others)};
      } else {
        print('Failed to fetch leaderboard: ${response.statusCode}');
        return {"top3": [], "others": []};
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return {"top3": [], "others": []};
    }
  }

  //pre leaderboard
  static Future<Map<String, List<Map<String, dynamic>>>> fetchPreLeaderboard(
    String time,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    final url = Uri.parse("$baseUrl/player/com_pre/leaderboard?time=$time");

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List top3 = data['top3'] ?? [];
        List others = data['others'] ?? [];

        List<Map<String, dynamic>> parseUsers(List<dynamic> users) {
          return users
              .map<Map<String, dynamic>>(
                (user) => {
                  "name": user["name"],
                  "image": user["image"],
                  "flag": user["flag"],
                  "com_pre_id": user["com_pre_id"],
                  "user_id": user["user_id"],
                  "total_score": user["total_score"],
                  "rank": user["rank"],
                },
              )
              .toList();
        }

        return {"top3": parseUsers(top3), "others": parseUsers(others)};
      } else {
        print('Failed to fetch leaderboard: ${response.statusCode}');
        return {"top3": [], "others": []};
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return {"top3": [], "others": []};
    }
  }

  //community player in edit
  static Future<List<Map<String, dynamic>>> fetchCommunityplayerInEdit(
    String communityId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("user_token");

    final url = Uri.parse(
      "https://calmletics-production.up.railway.app/api/coach/community-members-status?community_id=$communityId",
    );

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        List players = data['players'] ?? [];

        return players
            .map<Map<String, dynamic>>(
              (player) => {
                "player_id": player["player_id"],
                "player_name": player["player_name"],
                "community_name": player["community_name"],
                "status_message": player["status_message"],
                "status_image": player["status_image"],
                "image": player["image"],
              },
            )
            .toList();
      } else {
        print('Failed to fetch players: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching players: $e');
      return [];
    }
  }

  Future<bool> joinPreCommunity(String code) async {
    String? token = await TokenHelper.getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/player/pre-join'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "code": code, // Assuming the backend expects a JSON body with "code"
        }),
      );

      print("📡 Sending POST request to join pre-community...");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error sending join pre-community request: $e");
      return false;
    }
  }
}
