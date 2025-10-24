import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/FollowUpTrackModel.dart';

class FollowUpTrackProvider with ChangeNotifier {
  bool isLoading = false;
  List<FollowUpData> allFollowUps = [];
  List<FollowUpData> filteredFollowUps = [];

  // Filters
  String? selectedStaffId;
  String? selectedStaffName;
  String? selectedProductId;
  String? selectedProductName;
  String? selectedDateRange;
  String searchQuery = '';

  String? token;

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  Future<void> fetchFollowUps({
    String? staffId,
    String? productId,
    String? date,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      if (token == null) await _loadToken();

      String url =
          'https://call-logs-backend.onrender.com/api/history/followup-track';

      List<String> params = [];
      if (staffId != null && staffId.isNotEmpty) params.add('staff=$staffId');
      if (productId != null && productId.isNotEmpty) {
        params.add('product=$productId');
      }
      if (date != null && date.isNotEmpty && date != 'all') {
        params.add('date=$date');
      }

      if (params.isNotEmpty) url += '?${params.join('&')}';

      debugPrint('🌍 Fetching FollowUps URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final model = FollowUpTrackModel.fromJson(jsonData);

        allFollowUps = model.data ?? [];
        filteredFollowUps = List.from(allFollowUps);
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching follow-ups: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔍 Search filter
  void setSearch(String value) {
    searchQuery = value;
    applyFilters();
  }

  // Staff filter
  void setStaff(String? id, String? name) {
    selectedStaffId = id;
    selectedStaffName = name;
    fetchFollowUps(
      staffId: selectedStaffId,
      productId: selectedProductId,
      date: selectedDateRange,
    );
  }

  // Product filter
  void setProduct(String? id, String? name) {
    selectedProductId = id;
    selectedProductName = name;
    fetchFollowUps(
      staffId: selectedStaffId,
      productId: selectedProductId,
      date: selectedDateRange,
    );
  }

  // Date range filter
  void setDateRange(String? value) {
    selectedDateRange = value;
    fetchFollowUps(
      staffId: selectedStaffId,
      productId: selectedProductId,
      date: selectedDateRange,
    );
  }

  // Apply local filters (search + dropdowns)
  void applyFilters() {
    filteredFollowUps = allFollowUps.where((m) {
      final matchesStaff =
          selectedStaffName == null || m.assignedStaff?.username == selectedStaffName;
      final matchesProduct =
          selectedProductName == null || m.product?.name == selectedProductName;

      final matchesSearch = m.companyName?.toLowerCase().contains(searchQuery.toLowerCase()) == true ||
          (m.persons?.any((p) =>
          p.fullName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ??
              false);

      return matchesStaff && matchesProduct && matchesSearch;
    }).toList();

    notifyListeners();
  }
}
