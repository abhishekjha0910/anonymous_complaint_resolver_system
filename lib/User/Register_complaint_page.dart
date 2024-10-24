import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterComplaintPage extends StatefulWidget {
  @override
  _RegisterComplaintPageState createState() => _RegisterComplaintPageState();
}

class _RegisterComplaintPageState extends State<RegisterComplaintPage> {
  final TextEditingController _complaintTitleController = TextEditingController();
  final TextEditingController _complaintDescriptionController = TextEditingController();
  final TextEditingController _driveLinkController = TextEditingController();
  String? _selectedCategory;

  // Submit Complaint and save to Firestore and SharedPreferences
  Future<void> _submitComplaint() async {
    if (_complaintTitleController.text.isNotEmpty &&
        _complaintDescriptionController.text.isNotEmpty &&
        _selectedCategory != null) {

      // Save complaint to Firestore
      await FirebaseFirestore.instance.collection('complaints').add({
        'title': _complaintTitleController.text,
        'description': _complaintDescriptionController.text,
        'category': _selectedCategory,
        'driveLink': _driveLinkController.text.isEmpty ? null : _driveLinkController.text,
        'status': 'Pending',  // Set initial status
        'date': DateTime.now(),  // Add timestamp
      });

      // Save a copy to SharedPreferences
      await _saveComplaintToPreferences(
        _complaintTitleController.text,
        _complaintDescriptionController.text,
        _selectedCategory!,
      );

      // Clear the fields after submission
      _complaintTitleController.clear();
      _complaintDescriptionController.clear();
      _driveLinkController.clear();
      _selectedCategory = null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint Registered Successfully')),
      );

      // Navigate back to a previous page or show a success page
      Navigator.pop(context); // Redirect to the previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields.')),
      );
    }
  }

  // Save the complaint details in SharedPreferences
  Future<void> _saveComplaintToPreferences(String title, String description, String category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the existing complaints list
    List<String> complaints = prefs.getStringList('complaints') ?? [];

    // Add the new complaint (title, description, and category as a single string)
    complaints.add('$title - $category: $description');

    // Save the updated list back to SharedPreferences
    await prefs.setStringList('complaints', complaints);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register New Complaint'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _complaintTitleController,
                decoration: InputDecoration(
                  labelText: 'Complaint Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _complaintDescriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Complaint Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                items: ['HOD', 'Hostel Department', 'Warden', 'Other']
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _driveLinkController,
                decoration: InputDecoration(
                  labelText: 'Google Drive Link (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Submit Complaint',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

