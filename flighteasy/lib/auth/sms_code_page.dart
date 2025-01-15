import 'package:flutter/material.dart';
import 'package:flighteasy/auth/auth_service.dart';

class SMSCodePage extends StatelessWidget {
  final String verificationId;
  final AuthService _authService = AuthService();

  SMSCodePage({required this.verificationId});

  final TextEditingController smsCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Verification Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: smsCodeController,
              decoration: InputDecoration(labelText: 'Enter SMS Code'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String smsCode = smsCodeController.text.trim();
                await _authService.verifyCode(verificationId, smsCode);
                Navigator.pop(context); // Navigate back after successful login
              },
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}