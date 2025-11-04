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
  final String apiUrl = 'https://call-logs-backend.onrender.com/api/meetings/follow-date';

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




  // 🔹 PATCH API call to update follow-up
  Future<void> updateFollowUp({
    required String id,
    required String date,
    required String time,
    required String remark,
    required String status,
    String? companyName,
    String? phone,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found for calendar meetings");
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // 🔹 Map frontend statuses to valid backend enum values
      final validStatuses = {
        'Follow Up Required': 'Hold',
        'In Progress': 'Hold',
        'Completed': 'Completed',
        'Closed': 'Close',
      };

      final timelineValue = validStatuses[status] ?? status;

      final url = Uri.parse(
          'https://call-logs-backend.onrender.com/api/meetings/$id/followup');

      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "date": date,
          "time": time,
          "detail": remark,
          "timeline": timelineValue,
        }),
      );

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        debugPrint('✅ Follow-up updated: $resData');
        await fetchFollowUps();
      } else {
        debugPrint('❌ Failed to update: ${response.body}');
        _errorMessage = 'Failed to update follow-up';
      }
    } catch (e) {
      debugPrint('⚠️ Exception: $e');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // 🔹 Optional: Delete follow-up
  Future<void> deleteFollowUp(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint("❌ No token found for deleting meeting");
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final url = Uri.parse(
          'https://call-logs-backend.onrender.com/api/meetings/$id');

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Meeting deleted successfully');
        // Optionally refresh list after deletion
        _followUps.removeWhere((item) => item.id == id);
        notifyListeners();
      } else {
        debugPrint('❌ Failed to delete: ${response.body}');
        _errorMessage = 'Failed to delete meeting';
      }
    } catch (e) {
      debugPrint('⚠️ Exception while deleting: $e');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


}
