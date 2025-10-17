import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MeetingProvider with ChangeNotifier {
  bool isLoading = false;
  String message = '';
  List<Map<String, dynamic>> meetings = [];

  Future<void> fetchUpcomingMeetings() async {
    try {
      isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        message = "❌ No token found";
        isLoading = false;
        notifyListeners();
        return;
      }

      final url = Uri.parse('https://call-logs-backend.onrender.com/api/meetings/calendar'); // 🔹 Change to your API URL
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          meetings = List<Map<String, dynamic>>.from(data['data']);
        } else {
          message = "No upcoming meetings found";
        }
      } else {
        message = "Failed to fetch meetings (${response.statusCode})";
      }
    } catch (e) {
      message = "Error: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Get meetings for a specific date
  List<Map<String, dynamic>> getMeetingsForDate(DateTime date) {
    final formatted = DateTime(date.year, date.month, date.day);
    return meetings.where((m) {
      final List<dynamic> dates = m['dates'];
      for (var d in dates) {
        final meetingDate = DateTime.parse(d);
        if (meetingDate.year == formatted.year &&
            meetingDate.month == formatted.month &&
            meetingDate.day == formatted.day) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  /// Check if a day has a meeting
  bool isMeetingDay(DateTime date) {
    return getMeetingsForDate(date).isNotEmpty;
  }
}
