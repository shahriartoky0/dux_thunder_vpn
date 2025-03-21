import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "We value your privacy. This policy explains how we handle your data...",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "1. Data Collection",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "We do not collect any personal information...",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "2. Security Measures",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "We use strong encryption to protect your data...",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                "3. Third-Party Services",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "This app does not share data with third parties...",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
