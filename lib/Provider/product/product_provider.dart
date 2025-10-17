import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/productModel.dart';

class ProductProvider with ChangeNotifier {
  bool isLoading = false;
  List<Data> products = [];

  Future<void> fetchProducts() async {
    const url = "https://call-logs-backend.onrender.com/api/products"; // 🔹 Replace with actual API
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final productModel = ProductModel.fromJson(jsonResponse);

        products = productModel.data ?? [];
        if (kDebugMode) {
          print("✅ Loaded ${products.length} products");
        }
      } else {
        if (kDebugMode) {
          print("❌ Failed to load products: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("⚠️ Error fetching products: $e");
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found for calendar meetings");
      return;
    }
    final url = Uri.parse(
        'https://call-logs-backend.onrender.com/api/products/$productId');
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(url,
        headers: {
          'Authorization': "Bearer $token",
          'Accept': "application/json",
        },);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        fetchProducts();
        print('✅ Product deleted successfully: $data');
      } else {
        print('❌ Failed to delete product. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('⚠️ Error deleting product: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required String price,
    required String totalOrders,
    File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found!");
      return;
    }

    final url = Uri.parse(
        "https://call-logs-backend.onrender.com/api/products/$id");

    var request = http.MultipartRequest('PUT', url);

    // Add headers including Authorization
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    // Add form fields
    request.fields['name'] = name;
    request.fields['price'] = price;
    request.fields['totalOrders'] = totalOrders;

    // Add image if provided
    if (imageFile != null) {
      request.files.add(
          await http.MultipartFile.fromPath('image', imageFile.path));
    }

    // Send request
    final response = await request.send();

    if (response.statusCode == 200) {
      print("✅ Product updated successfully!");
      fetchProducts(); // Refresh product list
    } else {
      print("❌ Failed to update product: ${response.statusCode}");
      print(await response.stream.bytesToString()); // log API error details
    }
  }



  Future<void> addProduct({
    required String name,
    required String price,
    required bool isEnable,
    required File imageFile,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? ''; // 🔹 stored token

      final url = Uri.parse('https://call-logs-backend.onrender.com/api/products');
      var request = http.MultipartRequest('POST', url);

      request.headers['Authorization'] = 'Bearer $token';

      request.fields['name'] = name;
      request.fields['price'] = price;
      request.fields['isEnable'] = isEnable.toString();

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Product added: ${responseBody.body}');
      } else {
        print('❌ Failed: ${response.statusCode} - ${responseBody.body}');
      }
    } catch (e) {
      print('⚠️ Error adding product: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
