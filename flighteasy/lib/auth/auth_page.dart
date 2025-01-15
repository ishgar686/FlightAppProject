import 'package:flutter/material.dart';
import 'package:flighteasy/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flighteasy/auth/email_signin_page.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flighteasy/auth/need_help_page.dart';
import 'package:flighteasy/auth/sms_code_page.dart';

class AuthPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    String countryCode = '+1'; // Default country code
    TextEditingController phoneNumberController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white, // Background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Log in or sign up',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            thickness: 1,
            color: Colors.grey[300], // Faint line below the title
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Welcome to FlightEasy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),
            // Country Code Box
            Stack(
              children: [
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Country Code',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  initialCountryCode: 'US', // Default country
                  showDropdownIcon: true, // Ensure the dropdown icon is visible
                  disableLengthCheck: true, // Remove length checker
                  onChanged: (phone) {
                    countryCode = phone.countryCode; // Capture the selected country code
                    print('Selected Country Code: $countryCode');
                  },
                ),
                Positioned(
                  top: 5,
                  left: 50,
                  right: 5,
                  bottom: 5,
                  child: Container(
                    alignment: Alignment.centerLeft, // Align the text inside the box
                    padding: EdgeInsets.only(left: 8), // Add padding for better alignment
                    color: Colors.white, // Background color for the box
                    child: Text(
                      'Country Code', // Text to display
                      style: TextStyle(
                        fontSize: 16, // Font size for the text
                        color: Colors.grey[800], // Text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Phone Number Box
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[200]!),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (phoneNumberController.text.trim().isEmpty) {
                  print('Phone number is required.');
                  return;
                }
                try {
                  String phoneNumber = '$countryCode${phoneNumberController.text.trim()}';

                  final AuthService _authService = AuthService();
                  await _authService.sendCode(
                    phoneNumber,
                    (String verificationId) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SMSCodePage(verificationId: verificationId),
                        ),
                      );
                    },
                  );
                  print('SMS sent successfully');
                } catch (e) {
                  print('Error sending SMS: $e');
                }
              },
              child: Text('Continue'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.black, // Black text
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "We'll call or text you to confirm your number. Standard message and data rates apply.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black, // Black text
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey[400], thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('or'),
                ),
                Expanded(child: Divider(color: Colors.grey[400], thickness: 1)),
              ],
            ),
            SizedBox(height: 20),
            // Google Sign-In Button
            ElevatedButton.icon(
              onPressed: () async {
                User? user = await _authService.signInWithGoogle();
                if (user != null) {
                  print("Google Sign-In successful: ${user.email}");
                  // Navigate to the next screen
                } else {
                  print("Google Sign-In canceled or failed");
                }
              },
              icon: Icon(Icons.g_mobiledata, color: Colors.black),
              label: Text('Continue with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // White background
                foregroundColor: Colors.black, // Black text
                side: BorderSide(color: Colors.black, width: 1), // Black border
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            // Email Sign-In Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmailSignInPage()),
                );
              },
              icon: Icon(Icons.email, color: Colors.black),
              label: Text('Continue with Email'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // White background
                foregroundColor: Colors.black, // Black text
                side: BorderSide(color: Colors.black, width: 1), // Black border
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NeedHelpPage()),
                );
              },
              child: Text(
                'Need help?',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}