import 'package:flutter/material.dart';
import 'complaint_history_page.dart';
import 'register_complaint_page.dart';
import 'complaint_status_page.dart';
import 'login_page.dart';
import 'edit_profile_page.dart'; // Import the EditProfilePage

class ComplaintsPage extends StatefulWidget {
  final String username; // Pass the username as a parameter
  final String email; // Pass the email as a parameter

  ComplaintsPage({required this.username, required this.email});

  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints Dashboard'),
        backgroundColor: Colors.orange,
        actions: [
          // Profile icon button
          IconButton(
            icon: CircleAvatar(
              child: Text(
                widget.username.isNotEmpty ? widget.username[0].toUpperCase() : 'U', // Display the first letter of the username
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              // Navigate to the EditProfilePage and pass username and email
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    username: widget.username,
                    email: widget.email,
                  ),
                ),
              );
            },
          ),
          // Logout button
          IconButton(
            onPressed: () {
              // Sign out and navigate to the LoginPage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.report_problem,
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 40),
            // Register new complaint button
            ListTile(
              leading: const Icon(Icons.add_box_outlined, color: Colors.orange),
              title: const Text('Register new complaint'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterComplaintPage(),
                  ),
                );
              },
            ),
            const Divider(),
            // Check complaint status button
            ListTile(
              leading: const Icon(Icons.assignment_outlined, color: Colors.orange),
              title: const Text('Check complaint status'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComplaintStatusPage()),
                );
              },
            ),
            const Divider(),
            // Check complaint history button
            ListTile(
              leading: const Icon(Icons.history, color: Colors.orange),
              title: const Text('Check complaint history'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComplaintHistoryPage()),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

