import 'package:flutter/material.dart';
import 'package:thunder_vpn/ui/screens/terms/privacy_policy_page.dart';
import 'package:thunder_vpn/ui/screens/terms/terms_service_page.dart';


import '../../core/utils/navigations.dart';
import '../../core/utils/preferences.dart';
import 'main_screen.dart';

class ConsentPage extends StatefulWidget {
  @override
  State<ConsentPage> createState() => _ConsentPageState();
}

class _ConsentPageState extends State<ConsentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.blue.shade900],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: const Icon(
                Icons.security_rounded,
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              "Keep Your Privacy Safe",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "We protect your privacy by changing your IP address. No Sign in! Stay anonymous!\n\n"
                "By tapping Continue, you agree to our ",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ),
            // Terms & Privacy Links
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    startScreen(context, TermsServiceScreen());
                  },
                  child: const Text(
                    "Terms of Service",
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
                const Text(" and ", style: TextStyle(color: Colors.white70)),
                GestureDetector(
                  onTap: () {
                    startScreen(context, PrivacyPolicyPage());
                  },
                  child: const Text(
                    "Privacy Policy",
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Agree & Continue Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Preferences.instance().then((pref) {
                      pref.setTermsAccepted(true);
                    });
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()),
                      (route) => false, // this removes all previous routes
                    );
                  },
                  child: const Text(
                    "Agree & Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
