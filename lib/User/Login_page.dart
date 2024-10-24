import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'complaint_page.dart';
import 'register_page.dart';  // Import the RegisterPage for navigation to registration

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false; // Toggle password visibility
  bool _isLoading = false; // Show loading indicator
  String _errorMessage = ''; // For showing login error

  // Login logic
  Future<void> _login() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userUID = userCredential.user?.uid ?? '';
      String userEmail = userCredential.user?.email ?? '';

      // Navigate to ComplaintsPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ComplaintsPage(username: userUID, email: userEmail)),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Error logging in';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Password reset logic
  void _resetPassword() {
    String email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    _auth.sendPasswordResetEmail(email: email).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent!')),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending reset email.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speak Up'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.record_voice_over, size: 100, color: Colors.orange),
              SizedBox(height: 20),
              Text(
                'Sign in to your Account',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 30),

              // Email field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),

              SizedBox(height: 20),

              // Password field with visibility toggle
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resetPassword,
                  child: Text('Forgot Password?', style: TextStyle(color: Colors.green)),
                ),
              ),

              SizedBox(height: 20),

              // Error message display
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
                ),

              // Loading indicator
              if (_isLoading) CircularProgressIndicator(),

              // Login button
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              SizedBox(height: 30),

              // Register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                    },
                    child: Text('Register Now', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}





