import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/FollowUpModel.dart';


class FollowUpProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<FollowUpData> _followUps = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<FollowUpData> get followUps => _followUps;

  /// Replace with your actual API endpoint
  final String apiUrl = 'https://call-logs-backend.vercel.app/api/meetings/follow-date';

  Future<void> fetchFollowUps() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found for calendar meetings");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final followUpResponse = FollowUpResponse.fromJson(data);
        _followUps = followUpResponse.data;
      } else {
        _errorMessage =
        'Error ${response.statusCode}: ${response.reasonPhrase}';
      }
    } catch (e) {
      _errorMessage = 'Failed to load follow-ups: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
