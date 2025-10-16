import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardProvider with  ChangeNotifier{
  String? errorMessage;
  int? totalProducts;
  int? totalCustomers;
  int? totalStaffs;
  int? totalTransactions;
  bool isLoading=false;
  double successRate=0;
  double pendingCalls=0;
  double followUps=0;
  double totalMeetings=0;
  int totalCalls = 0;
  List<Map<String, dynamic>> monthlyTrends = [];
  List<Map<String, dynamic>> weeklyData = [];
  int totalWeeklyCalls = 0;

  Future<void>Performance_Summary()async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('save the token');
    print('save token');
    print(token);

    if (token == null) {
      print("No token found!");
      return;
    }
    isLoading =true;
    notifyListeners();
    const url='https://call-logs-backend.vercel.app/api/dashboard/performance-summary';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': "application/json",
        },
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result["success"] == true) {
          final data = result["data"];
          print("Parsed Data: $data");

          successRate = double.tryParse(data["successRate"].toString()) ?? 0.0;
          pendingCalls = double.tryParse(data["pendingCalls"].toString()) ?? 0.0;
          followUps = double.tryParse(data["followUps"].toString()) ?? 0.0;
          totalMeetings = double.tryParse(data["totalMeetings"].toString()) ?? 0.0;

        } else {
          print("API returned success = false");
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) print("Error: $e");
    }

    isLoading = false;
    notifyListeners();


  }
  List<Map<String, dynamic>> get chartData => [
    {"title": "Success Rate", "value": successRate, "color": const Color(0xFF4CAF50)},
    {"title": "Pending Calls", "value": pendingCalls, "color": const Color(0xFF2196F3)},
    {"title": "Follow Ups", "value": followUps, "color": Colors.orange},
    {"title": "Total Meetings", "value": totalMeetings, "color": const Color(0xFFF44336)},
  ];
  List<DateTime> meetingDates = [];

  Future<void> fetchCalendarMeetings() async {
    final now = DateTime.now();
    final formattedMonth = "${now.year}-${now.month.toString().padLeft(2, '0')}";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found for calendar meetings");
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      final url = 'https://call-logs-backend.vercel.app/api/dashboard/calendar-meetings?month=$formattedMonth';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': "application/json",
        },
      );

      print("📅 Calendar Response: ${response.statusCode}");
      print("📅 Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true && data["data"] is List) {
          meetingDates = (data["data"] as List)
              .map((item) => DateTime.parse(item["date"]))
              .toList();
          print("✅ Parsed Meeting Dates: $meetingDates");
        } else {
          print("⚠️ Calendar data format unexpected");
        }
      }
    } catch (e) {
      debugPrint("❌ Error fetching meetings: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Check if date has meeting
  bool isMeetingDay(DateTime day) {
    return meetingDates.any(
          (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
  }




  Future<void> fetchMonthlyTrends() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      debugPrint("❌ No token found!");
      return;
    }

    const url = 'https://call-logs-backend.vercel.app/api/dashboard/monthly-trends';
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': "application/json",
        },
      );

      debugPrint("📡 Status: ${response.statusCode}");
      debugPrint("📦 Response: ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result["success"] == true) {
          totalCalls = result["totalCalls"] ?? 0;
          monthlyTrends = List<Map<String, dynamic>>.from(result["data"]);
        }
      } else {
        debugPrint("⚠️ Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  
  Future<void>CountProduct()async{
    isLoading=true;
    notifyListeners();
    try{
      final response= await http.get(Uri.parse('https://call-logs-backend.vercel.app/api/products/count'));
      if(response.statusCode==200){
        final data=jsonDecode(response.body);
        totalProducts = data['totalProducts'] ?? 0; // ✅ match your API key
      } else {
        errorMessage =
        'Error ${response.statusCode}: ${response.reasonPhrase ?? "Unknown error"}';
      }

      
    }catch(e){
      
    }
    finally {
      isLoading = false;
      notifyListeners();
    }
    
  }
  Future<void>CountCustomer()async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found for calendar meetings");
      return;
    }
    isLoading=true;
    notifyListeners();
    try{
      final response= await http.get(Uri.parse('https://call-logs-backend.vercel.app/api/customers/count'),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': "application/json",
        },

      );
      if(response.statusCode==200){
        final data=jsonDecode(response.body);
        totalCustomers = data['totalCustomers'] ?? 0; // ✅ match your API key
      } else {
        errorMessage =
        'Error ${response.statusCode}: ${response.reasonPhrase ?? "Unknown error"}';
      }


    }catch(e){

    }
    finally {
      isLoading = false;
      notifyListeners();
    }

  }
  Future<void>CountStaff()async{
    isLoading=true;
    notifyListeners();
    try{
      final response= await http.get(Uri.parse('https://call-logs-backend.vercel.app/api/group-users/count'));
      if(response.statusCode==200){
        final data=jsonDecode(response.body);
        totalStaffs = data['totalUsers'] ?? 0; // ✅ match your API key
      } else {
        errorMessage =
        'Error ${response.statusCode}: ${response.reasonPhrase ?? "Unknown error"}';
      }


    }catch(e){

    }
    finally {
      isLoading = false;
      notifyListeners();
    }

  }
  Future<void>CountTransaction()async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found for calendar meetings");
      return;
    }
    isLoading=true;
    notifyListeners();
    try{
      final response= await http.get(Uri.parse('https://call-logs-backend.vercel.app/api/orders/total'),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': "application/json",
        },);
      if(response.statusCode==200){
        final data=jsonDecode(response.body);
        totalTransactions = data['totalSales'] ?? 0; // ✅ match your API key
      } else {
        errorMessage =
        'Error ${response.statusCode}: ${response.reasonPhrase ?? "Unknown error"}';
      }


    }catch(e){

    }
    finally {
      isLoading = false;
      notifyListeners();
    }

  }



  Future<void> fetchWeeklyTrends() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      debugPrint("❌ No token found!");
      return;
    }

    const url = 'https://call-logs-backend.vercel.app/api/dashboard/weekly-volume';
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': "Bearer $token",
          'Accept': "application/json",
        },
      );

      debugPrint("📡 Status: ${response.statusCode}");
      debugPrint("📦 Response: ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result["success"] == true && result["data"] != null) {
          weeklyData = List<Map<String, dynamic>>.from(result["data"]);
          totalWeeklyCalls = weeklyData.fold<int>(
            0,
                (sum, item) => sum + ((item["count"] ?? 0) as int),
          );

        } else {
          debugPrint("⚠️ Invalid response data format");
        }
      } else {
        debugPrint("⚠️ Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


}