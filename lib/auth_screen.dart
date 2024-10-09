import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';

import 'login_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> authenticate() async {
    bool isAuthenticated = false;

    bool isBiometricSupported = await auth.canCheckBiometrics;
    bool hasEnrolledBiometrics = await auth.isDeviceSupported();

    if (!isBiometricSupported || !hasEnrolledBiometrics) {
      Fluttertoast.showToast(msg: "Biometric authentication not supported or no biometrics enrolled.");
      return;
    }

    try {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to unlock',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Authentication error: $e");
      Fluttertoast.showToast(msg: "Authentication error: ${e.toString()}");
    }

    if (isAuthenticated) {
      Fluttertoast.showToast(msg: "You are authorized");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      Fluttertoast.showToast(msg: "Authentication failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authenticate")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: authenticate,
              child: Text("Authenticate"),
            ),
            // ElevatedButton(
            //   onPressed: validatePassword,
            //   child: Text("Validate Password"),
            // ),
          ],
        ),
      ),
    );
  }
}
