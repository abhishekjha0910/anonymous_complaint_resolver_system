import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'ComplaintDetailsPage.dart';

class ComplainBoxPage extends StatefulWidget {
  @override
  _ComplainBoxPageState createState() => _ComplainBoxPageState();
}

class _ComplainBoxPageState extends State<ComplainBoxPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedStatus = 'Pending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complain Box'),
        backgroundColor: Colors.orange,
        actions: [
          DropdownButton<String>(
            value: _selectedStatus,
            items: ['Pending', 'In Progress', 'Resolved']
                .map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore
            .collection('complaints')
            .where('status', isEqualTo: _selectedStatus)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading complaints.'));
          }

          var complaints = snapshot.data?.docs ?? [];

          if (complaints.isEmpty) {
            return Center(child: Text('No complaints available.'));
          }

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              var complaint = complaints[index].data();
              var complaintId = complaints[index].id;
              var filedTime = (complaint['filed_at'] as Timestamp?)?.toDate() ?? DateTime.now();
              var resolvedTime = (complaint['resolved_at'] as Timestamp?)?.toDate();
              var submittedBy = complaint['submitted_by'] ?? 'Unknown'; // Fetch the UID or username

              return Card(
                margin: EdgeInsets.all(10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  title: Text('Complaint: ${complaint['title'] ?? 'No Title'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${complaint['status'] ?? 'Pending'}'),
                      Text('Filed At: ${filedTime.toString()}'),
                      Text('Submitted By: $submittedBy'), // Display the UID or user info
                      if (resolvedTime != null)
                        Text('Resolved At: ${resolvedTime.toString()}'),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Update Status' &&
                          (complaint['status'] == 'Pending' ||
                              complaint['status'] == 'In Progress')) {
                        _showStatusUpdateDialog(complaintId, complaint['status']);
                      } else if (value == 'Delete') {
                        _deleteComplaint(complaintId);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        if (complaint['status'] != 'Resolved')
                          PopupMenuItem(
                            value: 'Update Status',
                            child: Text('Update Status'),
                          ),
                        PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComplaintDetailsPage(
                          complaint: complaint,
                          complaintId: complaintId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Method to delete a complaint
  Future<void> _deleteComplaint(String complaintId) async {
    try {
      await _firestore.collection('complaints').doc(complaintId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Complaint deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete complaint: $e')),
      );
    }
  }

  // Method to show a dialog for updating the status
  void _showStatusUpdateDialog(String complaintId, String currentStatus) {
    String newStatus = currentStatus; // Default to the current status

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Status'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                value: newStatus,
                items: ['Pending', 'In Progress', 'Resolved'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    newStatus = value!;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateComplaintStatus(complaintId, newStatus);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Method to update the complaint status
  Future<void> _updateComplaintStatus(String complaintId, String newStatus) async {
    try {
      Map<String, dynamic> updateData = {
        'status': newStatus,
      };

      if (newStatus == 'Resolved') {
        updateData['resolved_at'] = FieldValue.serverTimestamp();
      }

      await _firestore.collection('complaints').doc(complaintId).update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }
}


