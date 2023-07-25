import 'dart:convert';
import 'dart:ffi';
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/model.dart';
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

  Map<String, double> get_right_data_plus_sum(List list) {
    Map<String, double> sumByPillName = {};

    // Calculate the sum of pillAmount for each pillName
    for (var medicine in list) {
      String pillName = medicine['pillName'];
      double pillAmount = double.parse(medicine['pillAmount']);

      if (sumByPillName.containsKey(pillName)) {
        double temp = sumByPillName[pillName] as double;
        sumByPillName[pillName] = pillAmount + temp;
      } else {
        sumByPillName[pillName] = pillAmount;
      }
    }

    return sumByPillName;
  }

  Widget virtical_chart(Map MED, List<double> barChartData) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 1000,
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
              final List<String> barChartData_ml_pillname =
                  MED.keys.toList() as List<String>;

              for (int i = 0; i < barChartData_ml_pillname.length; i++) {
                if (value.toInt() == i) {
                  return barChartData_ml_pillname[i];
                }
              }

              return "";
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
    );
  }

  List<PieChartSectionData> bie_data_func(Map MED) {
    final List<PieChartSectionData> bie_data = [];
    List<Color> primaryColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
      Colors.indigo,
    ];
    int color_indx = 0;
    MED.forEach(
      (key, value) {
        double sum = MED.values
            .fold(0, (previousValue, element) => previousValue + element);
        double result = ((value / sum) * 100);
        String formattedNumber = result.toStringAsFixed(2);
        result = double.parse(formattedNumber);
        PieChartSectionData temp = PieChartSectionData(
          showTitle: true,
          value: result,
          color: primaryColors[color_indx],
          title: '${result}% ${key}',
          radius: 80,
          titleStyle: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
        );
        color_indx++;
        bie_data.add(temp);
      },
    );
    return bie_data;
  }

  model buttomBar = new model();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buttomBar.buttomAppBar_app(context),
      appBar: AppBar(
        backgroundColor: _Colors['orange'],
        title: Text('Statistics and analytics'),
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
            Map ML_MED = get_right_data_plus_sum(ml_med);
            print(ML_MED);
            Map MG_MED = get_right_data_plus_sum(mg_med);

            print("mg====");
            print(MG_MED);

            final List<double> barChartData_ml =
                ML_MED.values.toList() as List<double>;
            final List<double> barChartData_mg =
                MG_MED.values.toList() as List<double>;

            print("bie_data_ml");

            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16.0),
              child: Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(widget.meds.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Bar Chart",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text("To show",
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Text("the consumption of medicine in milliliters (ml)"),
                        SizedBox(
                          height: 20,
                        ),
                        virtical_chart(ML_MED, barChartData_ml),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Bar Chart",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text("To show",
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Text("the consumption of medicine in milligrams (mg)"),
                        SizedBox(
                          height: 20,
                        ),
                        virtical_chart(MG_MED, barChartData_mg),
                        SizedBox(
                          height: 50,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Pie Chart",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            Text("To show",
                                style: TextStyle(
                                    color: Colors.black38,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                "the Percentage of medicines in milliliters (ml)"),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 250,
                              child: PieChart(
                                PieChartData(
                                  sections: bie_data_func(ML_MED),
                                  borderData: FlBorderData(show: false),
                                  centerSpaceRadius: 30,
                                  sectionsSpace: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Pie Chart",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text("To show",
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Text("the Percentage of medicines in milliliters (ml)"),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 250,
                          child: PieChart(
                            PieChartData(
                              sections: bie_data_func(MG_MED),
                              borderData: FlBorderData(show: false),
                              centerSpaceRadius: 30,
                              sectionsSpace: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
