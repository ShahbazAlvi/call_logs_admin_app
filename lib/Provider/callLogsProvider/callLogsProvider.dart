import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/calllogsModels.dart';

class CallLogsProvider with ChangeNotifier {
  bool isLoading = false;
  List<CallLogData> callLogs = [];

  Future<void> fetchCallLogs() async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("❌ No token found!");
        return;
      }
      final response = await http.get(
        Uri.parse('https://call-logs-backend.onrender.com/api/meeting-calls'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final model = CallLogsModel.fromJson(data);
        callLogs = model.data;
      } else {
        debugPrint("❌ Failed to fetch call logs: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching call logs: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// ✅ Single updated delete function — same as your cURL
  Future<bool> deleteCallLog({
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // or 'authToken' if that’s what you stored

    if (token == null) {
      debugPrint("❌ No token found in SharedPreferences!");
      return false; // ✅ must return a bool
    }

    final url = 'https://call-logs-backend.onrender.com/api/meeting-calls/$id';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint('🔍 DELETE Response: ${response.statusCode}');
      debugPrint('🗑️ Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        callLogs.removeWhere((log) => log.id == id);
        notifyListeners();
        debugPrint('✅ Call log deleted successfully');
        return true;
      } else {
        debugPrint('❌ Failed to delete call log: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('⚠️ Error during deletion: $e');
      return false;
    }
  }

}
