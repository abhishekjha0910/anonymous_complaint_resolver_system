import 'package:flutter/material.dart';

class ComplaintDetailsPage extends StatelessWidget {
  final Map<String, dynamic> complaint; // Holds the complaint data
  final String complaintId; // Holds the complaint ID

  // Constructor
  ComplaintDetailsPage({required this.complaint, required this.complaintId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Details'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${complaint['title'] ?? 'No Title'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description: ${complaint['description'] ?? 'No Description'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Status: ${complaint['status'] ?? 'Pending'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Submitted By: ${complaint['submittedBy'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Add any other details you want to show here
          ],
        ),
      ),
    );
  }
}



