import 'package:flutter/material.dart';

class ComplaintStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Status'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Track your Complaint',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Complaint tracking steps
            Expanded(
              child: ListView(
                children: [
                  ComplaintStep(
                    stepNumber: 1,
                    stepTitle: 'Complaint Registered',
                    stepDescription: 'Your complaint has been registered successfully.',
                    isCompleted: true, // Marking this step as complete
                  ),
                  ComplaintStep(
                    stepNumber: 2,
                    stepTitle: 'Complaint Under Review',
                    stepDescription: 'Your complaint is currently being reviewed by the team.',
                    isCompleted: true, // Marking this step as complete
                  ),
                  ComplaintStep(
                    stepNumber: 3,
                    stepTitle: 'Action Taken',
                    stepDescription: 'Necessary action has been taken regarding your complaint.',
                    isCompleted: false, // Still pending or in progress
                  ),
                  ComplaintStep(
                    stepNumber: 4,
                    stepTitle: 'Complaint Resolved',
                    stepDescription: 'Your complaint has been resolved successfully.',
                    isCompleted: false, // Still pending
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to display each step in the complaint tracking process
class ComplaintStep extends StatelessWidget {
  final int stepNumber;
  final String stepTitle;
  final String stepDescription;
  final bool isCompleted;

  const ComplaintStep({
    required this.stepNumber,
    required this.stepTitle,
    required this.stepDescription,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isCompleted ? Colors.orange : Colors.grey,
                child: Icon(
                  isCompleted ? Icons.check : Icons.radio_button_unchecked,
                  color: Colors.white,
                ),
              ),
              if (stepNumber < 4) // Show a vertical line if it's not the last step
                Container(
                  width: 4,
                  height: 60,
                  color: isCompleted ? Colors.orange : Colors.grey,
                ),
            ],
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stepTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? Colors.black87 : Colors.grey,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  stepDescription,
                  style: TextStyle(
                    fontSize: 16,
                    color: isCompleted ? Colors.black54 : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

