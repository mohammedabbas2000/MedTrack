import 'dart:convert';
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class graphs extends StatefulWidget {
  // final meds;
  @override
  // graphs(this.meds);
  State<graphs> createState() => _graphsState();
}

bool showSpinner = false;
Map<String, Color> _Colors = {
  "orange": Color.fromARGB(255, 231, 146, 71),
  "blue": Color.fromARGB(255, 92, 107, 192)
};

class _graphsState extends State<graphs> {
  List graph_data = [];
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  final List<PieChartSectionData> pieChartData = [
    PieChartSectionData(
      value: 30,
      color: Colors.red,
      title: '30%',
      radius: 30,
      titleStyle: TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      value: 40,
      color: Colors.green,
      title: '40%',
      radius: 30,
      titleStyle: TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      value: 30,
      color: Colors.blue,
      title: '30%',
      radius: 30,
      titleStyle: TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Combined Charts Example'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection("Taked")
              .where("taked", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshots) {
            graph_data = [];
            List ml_med = [];
            List mg_med = [];

            print("snapshots for doc");
            snapshots.data?.docs.forEach((element) {
              print(element.data());
              graph_data.add(element.data());
            });

            graph_data.forEach((e) {
              if (e['pillType'] == "ml") {
                ml_med.add(e);
              }
              if (e['pillType'] == "mg") {
                mg_med.add(e);
              }
            });
            print("ml====");
            print(ml_med);
            print("mg====");
            print(mg_med);
// List<int> pillAmountList =
            // medicineData.map<int>((medicine) => medicine['pillAmount']).toList();
            final List<double> barChartData_ml = ml_med
                .map<double>((medicine) => double.parse(medicine['pillAmount']))
                .toList();
            final List<double> barChartData_mg = mg_med
                .map<double>(
                    (medicine) => double.parse(medicine['pillAmount']) / 1000)
                .toList();

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(widget.meds.toString()),
                  Expanded(
                    flex: 1,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 1000,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          leftTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                                color: Colors.blueGrey, fontSize: 10),
                            getTitles: (value) {
                              return value.toInt().toString();
                            },
                            margin: 8,
                            reservedSize: 30,
                          ),
                          bottomTitles: SideTitles(
                            showTitles: true,
                            getTextStyles: (value) => const TextStyle(
                                color: Colors.blueGrey, fontSize: 10),
                            getTitles: (value) {
                              switch (value.toInt()) {
                                case 0:
                                  return 'A';
                                case 1:
                                  return 'B';
                                case 2:
                                  return 'C';
                                case 3:
                                  return 'D';
                                case 4:
                                  return 'E';
                                case 5:
                                  return 'F';
                                default:
                                  return '';
                              }
                            },
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        barGroups: barChartData_ml
                            .asMap()
                            .map(
                              (index, value) => MapEntry(
                                index,
                                BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      y: value,
                                      colors: [Colors.blue],
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .values
                            .toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: PieChart(
                      PieChartData(
                        sections: pieChartData,
                        borderData: FlBorderData(show: false),
                        centerSpaceRadius: 30,
                        sectionsSpace: 0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class CombinedChartsExample extends StatelessWidget {
  final List<double> barChartData = [5, 10, 8, 12, 6, 15];
  final List<PieChartSectionData> pieChartData = [
    PieChartSectionData(
      value: 30,
      color: Colors.red,
      title: '30%',
      radius: 30,
      titleStyle: TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      value: 40,
      color: Colors.green,
      title: '40%',
      radius: 30,
      titleStyle: TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    ),
    PieChartSectionData(
      value: 30,
      color: Colors.blue,
      title: '30%',
      radius: 30,
      titleStyle: TextStyle(
          fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Combined Charts Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 20,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) =>
                          const TextStyle(color: Colors.blueGrey, fontSize: 10),
                      getTitles: (value) {
                        return value.toInt().toString();
                      },
                      margin: 8,
                      reservedSize: 30,
                    ),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (value) =>
                          const TextStyle(color: Colors.blueGrey, fontSize: 10),
                      getTitles: (value) {
                        switch (value.toInt()) {
                          case 0:
                            return 'A';
                          case 1:
                            return 'B';
                          case 2:
                            return 'C';
                          case 3:
                            return 'D';
                          case 4:
                            return 'E';
                          case 5:
                            return 'F';
                          default:
                            return '';
                        }
                      },
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: barChartData
                      .asMap()
                      .map(
                        (index, value) => MapEntry(
                          index,
                          BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                y: value,
                                colors: [Colors.blue],
                              ),
                            ],
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: PieChart(
                PieChartData(
                  sections: pieChartData,
                  borderData: FlBorderData(show: false),
                  centerSpaceRadius: 30,
                  sectionsSpace: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
