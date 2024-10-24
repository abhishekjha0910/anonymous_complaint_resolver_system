import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'complain_box.dart';
import 'Admin_Complaint_statistics.dart'; // Ensure this file is imported

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int totalComplaints = 0;
  int pendingComplaints = 0;
  int inProgressComplaints = 0;
  int resolvedComplaints = 0;

  // Function to calculate statistics
  void calculateStatistics(List<QueryDocumentSnapshot<Map<String, dynamic>>> complaints) {
    totalComplaints = complaints.length;
    pendingComplaints = complaints.where((c) => c.data().containsKey('status') && c['status'] == 'Pending').length;
    inProgressComplaints = complaints.where((c) => c.data().containsKey('status') && c['status'] == 'In Progress').length;
    resolvedComplaints = complaints.where((c) => c.data().containsKey('status') && c['status'] == 'Resolved').length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Handle logout action
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('complaints').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading complaints.'));
          }

          var complaints = snapshot.data?.docs ?? [];
          calculateStatistics(complaints); // Calculate the statistics

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // Handle Alerts action
                  },
                  icon: Icon(Icons.notifications, color: Colors.orange),
                  label: Text(
                    'Alerts',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      _buildDashboardCard(
                        context: context,
                        title: 'Complain Box',
                        icon: Icons.inbox,
                        color: Colors.amber,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ComplainBoxPage()),
                          );
                        },
                      ),
                      _buildDashboardCard(
                        context: context,
                        title: 'Complain Statistics',
                        icon: Icons.bar_chart,
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ComplainStatisticsPage()), // Updated
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      ),
    );
  }
}










