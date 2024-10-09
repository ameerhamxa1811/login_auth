import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _passwordController = TextEditingController();

  Future<void> validatePassword(String password) async {
    final String chefId = "3";
    final String apiKey = "mobileapi19042024";
    final url = Uri.parse(
        "http://brownonions-002-site1.ftempurl.com/api/ChefRegister/ValidateChefPassword?ChefId=$chefId&CurrentPassword=$password&APIKey=$apiKey");

    try {
      final response = await http.get(url);

      print("Request URL: $url");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          if (responseData.containsKey('notify') && responseData['notify'].containsKey('isValidated')) {
            final bool isValidated = responseData['notify']['isValidated'];

            if (isValidated) {
              Fluttertoast.showToast(msg: "You are authorized");
              print("Login success: You are authorized");
            } else {
              Fluttertoast.showToast(msg: "Wrong password");
              print("Login failed: Wrong password");
            }
          } else {
            // If the expected keys are not found, print the entire response data
            print("Unexpected response structure: $responseData");
            Fluttertoast.showToast(msg: "Unexpected response format");
          }
        } catch (e) {
          // If JSON parsing fails, print an error
          print("Failed to parse response JSON: $e");
          Fluttertoast.showToast(msg: "Error parsing response");
        }
      } else {
        Fluttertoast.showToast(msg: "Login failed: Server error");
        print("Server error with status code: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
      print("Exception occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final password = _passwordController.text;
                if (password.isNotEmpty) {
                  validatePassword(password);
                } else {
                  Fluttertoast.showToast(msg: "Please enter a password");
                }
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
