import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NeedHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Need Help?'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text('Email'),
              subtitle: Text('ishgar686@gmail.com'),
              onTap: () async {
                final Uri emailUri = Uri(
                    scheme: 'mailto',
                    path: 'youremail@example.com',
                    query: Uri.encodeQueryComponent('subject=Need Help&body=Hello, I need assistance.'),
                );
                if (await canLaunchUrl(emailUri)) {
                    await launchUrl(emailUri);
                } else {
                    print('Could not launch email client.');
                }
            }),
            Divider(),
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Return to the authentication page
              },
              child: Text(
                'Go Back',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}