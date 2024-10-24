import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComplaintHistoryPage extends StatefulWidget {
  @override
  _ComplaintHistoryPageState createState() => _ComplaintHistoryPageState();
}

class _ComplaintHistoryPageState extends State<ComplaintHistoryPage> {
  List<String> _complaintList = [];

  @override
  void initState() {
    super.initState();
    _loadComplaintList();
  }

  // Load complaints from SharedPreferences
  Future<void> _loadComplaintList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _complaintList = prefs.getStringList('complaints') ?? [];
    });
  }

  // Delete complaint and update SharedPreferences
  Future<void> _deleteComplaint(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _complaintList.removeAt(index);
    });
    await prefs.setStringList('complaints', _complaintList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint History'),
        backgroundColor: Colors.orange,
      ),
      body: _complaintList.isEmpty
          ? Center(child: Text('No complaints filed yet.'))
          : ListView.builder(
        itemCount: _complaintList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListTile(
              leading: Icon(Icons.article, color: Colors.orange),
              title: Text(
                _complaintList[index],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteComplaint(index); // Delete complaint
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
