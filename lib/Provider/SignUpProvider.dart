import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpProvider with ChangeNotifier {
  bool isLoading = false;
  String message = "";

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();

  Future<Map<String, dynamic>> signUp() async {
    isLoading = true;
    message = "";
    notifyListeners();

    try {
      final url =
      Uri.parse('https://call-logs-backend.onrender.com/api/auth/register');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': fullnameController.text.trim(),
          'username': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      isLoading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        message = "✅ Registration successful!";
        notifyListeners();
        return {'success': true, 'data': json.decode(response.body)};
      } else {
        final resBody = json.decode(response.body);
        message = resBody['message'] ?? '❌ Registration failed';
        notifyListeners();
        return {'success': false, 'message': message};
      }
    } catch (e) {
      isLoading = false;
      message = "❌ Error: $e";
      notifyListeners();
      return {'success': false, 'message': message};
    }
  }
}
