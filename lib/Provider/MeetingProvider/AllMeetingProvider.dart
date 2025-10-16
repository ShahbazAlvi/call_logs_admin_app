import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/AllMeetingModel.dart';
 // path to your model

class AllMeetingProvider with ChangeNotifier {
  bool isLoading = false;
  List<Lead> meetings = [];

  Future<void> fetchMeetings() async {
    try {
      isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      if (token.isEmpty) throw Exception("Token not found");

      // final url = Uri.parse("https://call-logs-backend.vercel.app/api/meetings");
      // final response = await http.get(
      //   url,
      //   headers: {
      //     'Authorization': 'Bearer $token',
      //     'Content-Type': 'application/json',
      //   },
      // );
      //
      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   final apiResponse = ApiResponse.fromJson(data);
      //   meetings = apiResponse.data; // ✅ Proper model list
      // }
      //
      final url = Uri.parse("https://call-logs-backend.vercel.app/api/meetings");
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = apiResponseFromJson(response.body);
        meetings = apiResponse.data;
      }

      else {
        throw Exception("Failed to load meetings (${response.statusCode})");
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching meetings: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
