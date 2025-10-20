import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/AllMeetingModel.dart';


class NoDateMeetingProvider with ChangeNotifier {
  List<MeetingData> _meetings = [];
  bool _isLoading = false;

  List<MeetingData> get meetings => _meetings;
  bool get isLoading => _isLoading;

  Future<void> fetchMeetings() async {
    _isLoading = true;
    notifyListeners();

    const url = 'https://call-logs-backend.onrender.com/api/meetings/no-follow-date';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        debugPrint("❌ No token found for calendar meetings");
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint("🟡 Response status: ${response.statusCode}");
      debugPrint("🟡 Raw response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          final model = NoDateMeetingModel.fromJson(decoded);
          _meetings = model.data;
          debugPrint("✅ Meetings fetched: ${_meetings.length}");
        } else {
          debugPrint("❌ Unexpected data format: $decoded");
          _meetings = [];
        }
      } else if (response.statusCode == 401) {
        debugPrint("🚫 Unauthorized — Invalid or expired token.");
        _meetings = [];
      } else {
        debugPrint('❌ Error fetching meetings: ${response.body}');
        _meetings = [];
      }
    } catch (e) {
      debugPrint('⚠️ Exception while fetching meetings: $e');
      _meetings = [];
    }

    _isLoading = false;
    notifyListeners();
  }


  Future<void> deleteMeeting(String id,) async {
    final url =
        'https://call-logs-backend.onrender.com/api/meetings/$id';
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("❌ No token found for calendar meetings");
        return;
      }

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _meetings.removeWhere((m) => m.id == id);
        notifyListeners();
      } else {
        debugPrint('❌ Delete failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('⚠️ Exception during delete: $e');
    }
  }
  Future<void> updateMeeting({
    required String id,
    required String timeline, // e.g. "Follow Up"
    required String companyName,
    required String personId,
    required String productId,
    required String staffId,
    String? designation,
    String? nextDate,
    String? nextTime,
    String? details,
    String? referenceProvidedBy,
    String? detailsOption,
    String? contactMethod,
  }) async {
    final url = 'https://call-logs-backend.onrender.com/api/meetings/$id';

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        debugPrint("❌ No token found for updateMeeting");
        return;
      }

      Map<String, dynamic> payload;

      if (timeline == "Follow Up") {
        payload = {
          "companyName": companyName,
          "person": personId,
          "designation": designation,
          "product": productId,
          "Timeline": timeline, // ✅ Correct field name
          "followDates": [nextDate ?? ""],
          "followTimes": [nextTime ?? ""],
          "details": [details ?? ""],
          "action": detailsOption ?? "",
          "reference": referenceProvidedBy ?? "",
          "referToStaff": staffId,
          "contactMethod": contactMethod ?? "",
        };
      } else {
        payload = {
          "companyName": companyName,
          "person": personId,
          "designation": designation,
          "product": productId,
          "Timeline": timeline, // ✅ Correct field name
        };
      }

      debugPrint("🟡 Payload Sent: ${jsonEncode(payload)}");

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Meeting updated successfully: ${response.body}");
        fetchMeetings();
        notifyListeners();
      } else {
        debugPrint("❌ Update failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("⚠️ Error updating meeting: $e");
    }
  }








}
