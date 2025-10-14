import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'package:infinity/model/staffModel.dart';

class StaffProvider with ChangeNotifier{
  bool isLoading =false;
  List<Data> staffs = [];

  Future<void>fetchStaff()async{
    const url='https://call-logs-backend.vercel.app/api/staff';
    isLoading=true;
    notifyListeners();
    try{
      final response= await http.get(Uri.parse(url));
      if(response.statusCode==200){
        final JsonResponse=jsonDecode(response.body);
        final staffModel=StaffModel.fromJson(JsonResponse);
        staffs=staffModel.data??[];
        if (kDebugMode) {
          print("✅ Loaded ${staffs.length} products");
        }
      } else {
        if (kDebugMode) {
          print("❌ Failed to load products: ${response.statusCode}");
        }
      }

    }catch(e){
      if (kDebugMode) {
        print("⚠️ Error fetching products: $e");
      }
    }
    isLoading = false;
    notifyListeners();

  }
}