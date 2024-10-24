import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'User/Complaint_page.dart';
import 'User/login_page.dart';
import 'User/register_page.dart';
import 'Admin/admin_login_page.dart'; // Import the AdminLoginPage
import 'firebase_options.dart'; // Firebase configuration file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase configuration initialization
  );
  runApp(SpeakUpApp());
}

class SpeakUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speak Up',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Roboto', // Custom font
      ),
      initialRoute: '/', // Setting the initial route
      routes: {
        '/': (context) => MainPage(), // Home page for user to choose login type
        '/login': (context) => LoginPage(), // Route for student login
        '/register': (context) => RegisterPage(), // Route for registration
        '/complaints': (context) => ComplaintsPage(username: '', email: ''), // Placeholder for ComplaintsPage
        '/admin': (context) => AdminLoginPage(), // Route for admin login
      },
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.record_voice_over,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Speak Up',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 50),
            // Student Login Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Navigate to student login page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Student',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            // Admin Login Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin'); // Navigate to admin login page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Admin',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





