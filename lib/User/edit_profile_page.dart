import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class EditProfilePage extends StatefulWidget {
  final String username;
  final String email;

  EditProfilePage({required this.username, required this.email});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username; // Initialize username
    _emailController.text = widget.email; // Initialize email
  }

  Future<void> _updateProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Update email if not empty
      if (_emailController.text.isNotEmpty && _emailController.text != widget.email) {
        await user?.updateEmail(_emailController.text);
      }

      // Update password if not empty
      if (_passwordController.text.isNotEmpty) {
        await user?.updatePassword(_passwordController.text);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context); // Optionally navigate back or reset fields
    } on FirebaseAuthException catch (e) {
      // Handle errors like weak password or email already in use
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error updating profile')),
      );
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without logging out
              },
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () {
                FirebaseAuth.instance.signOut(); // Sign out from Firebase
                // Navigate to login page and remove all previous routes
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false, // Clear the stack
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Non-editable username field
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              readOnly: true, // Username is non-editable
            ),
            SizedBox(height: 20),
            // Editable email field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            // Editable password field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Save Changes Button
            ElevatedButton(
              onPressed: _updateProfile, // Update profile method
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text('Save Changes'),
            ),
            SizedBox(height: 20),
            // Logout Button
            ElevatedButton(
              onPressed: _logout, // Logout method
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose(); // Clean up controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
