import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplainStatisticsPage extends StatefulWidget {
  @override
  _ComplainStatisticsPageState createState() => _ComplainStatisticsPageState();
}

class _ComplainStatisticsPageState extends State<ComplainStatisticsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int totalComplaints = 0;
  int pendingComplaints = 0;
  int inProgressComplaints = 0;
  int resolvedComplaints = 0;
  String selectedChartType = 'Bar Chart'; // Default to Bar Chart

  // Fetch complaint data from Firestore
  void fetchComplaintData() {
    _firestore.collection('complaints').get().then((snapshot) {
      var complaints = snapshot.docs;
      calculateStatistics(complaints);
    }).catchError((error) {
      print("Error fetching complaints: $error");
    });
  }

  // Function to calculate statistics
  void calculateStatistics(List<QueryDocumentSnapshot<Map<String, dynamic>>> complaints) {
    totalComplaints = complaints.length;
    pendingComplaints = complaints.where((c) => c.data().containsKey('status') && c['status'] == 'Pending').length;
    inProgressComplaints = complaints.where((c) => c.data().containsKey('status') && c['status'] == 'In Progress').length;
    resolvedComplaints = complaints.where((c) => c.data().containsKey('status') && c['status'] == 'Resolved').length;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchComplaintData(); // Fetch data on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Statistics'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Complaint Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedChartType,
              items: <String>['Bar Chart', 'Pie Chart'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedChartType = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            // Conditionally render the chart based on the selectedChartType
            Expanded(
              child: selectedChartType == 'Bar Chart'
                  ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(20.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceEvenly,
                    maxY: (totalComplaints > 0) ? totalComplaints.toDouble() : 2,
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: pendingComplaints.toDouble(),
                            color: Colors.redAccent,
                            width: 18,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: inProgressComplaints.toDouble(),
                            color: Colors.orangeAccent,
                            width: 18,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: resolvedComplaints.toDouble(),
                            color: Colors.greenAccent,
                            width: 18,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ],
                      ),
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return Text('Pending', style: TextStyle(fontWeight: FontWeight.bold));
                              case 1:
                                return Text('In Progress', style: TextStyle(fontWeight: FontWeight.bold));
                              case 2:
                                return Text('Resolved', style: TextStyle(fontWeight: FontWeight.bold));
                              default:
                                return Text('');
                            }
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipPadding: const EdgeInsets.all(5),
                        tooltipRoundedRadius: 8,
                        tooltipMargin: 8,
                        fitInsideVertically: true,
                        fitInsideHorizontally: true,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String status;
                          switch (group.x.toInt()) {
                            case 0:
                              status = 'Pending';
                              break;
                            case 1:
                              status = 'In Progress';
                              break;
                            case 2:
                              status = 'Resolved';
                              break;
                            default:
                              status = '';
                          }
                          return BarTooltipItem(
                            '$status\n',
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${rod.toY.toInt()} complaints',
                                style: TextStyle(
                                  color: Colors.yellow,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              )
                  : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(20.0),
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.redAccent,
                        value: (pendingComplaints / totalComplaints * 100).isFinite
                            ? pendingComplaints / totalComplaints * 100
                            : 0,
                        title: 'Pending',
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      PieChartSectionData(
                        color: Colors.orangeAccent,
                        value: (inProgressComplaints / totalComplaints * 100).isFinite
                            ? inProgressComplaints / totalComplaints * 100
                            : 0,
                        title: 'In Progress',
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      PieChartSectionData(
                        color: Colors.greenAccent,
                        value: (resolvedComplaints / totalComplaints * 100).isFinite
                            ? resolvedComplaints / totalComplaints * 100
                            : 0,
                        title: 'Resolved',
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                    centerSpaceRadius: 40,
                    sectionsSpace: 5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






