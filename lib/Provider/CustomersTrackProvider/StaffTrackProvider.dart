import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/StaffTrackModel.dart';

class StaffTrackProvider with ChangeNotifier {
  bool isLoading = false;
  List<User> staffList = [];
  String? token;

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  Future<void> fetchStaffTrack() async {
    try {
      isLoading = true;
      notifyListeners();

      //if (token == null) await _loadToken();

      const url = 'https://call-logs-backend.onrender.com/api/auth/staff-track';
      debugPrint('🌍 Fetching StaffTrack: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final model = StaffTrackModel.fromJson(jsonData);
        staffList = model.users ?? [];
      } else {
        debugPrint('❌ Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching staff track: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
