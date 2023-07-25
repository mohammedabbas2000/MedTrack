import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medtrack/Medicins/newMed.dart';
import 'package:medtrack/graphs.dart';
import 'package:medtrack/historyCard.dart';
import 'package:medtrack/newCard.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class History extends StatefulWidget {
  @override
  State<History> createState() => _HistoryState();
}

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
bool showSpinner = false;

List<dynamic> dataOfTakedMed = [];

Map<String, Color> _Colors = {
  "orange": Color.fromARGB(255, 231, 146, 71),
  "blue": Color.fromARGB(255, 92, 107, 192)
};

class _HistoryState extends State<History> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  User? user = _auth.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    getTheTakedMedicines();
    super.initState();
  }

  Future<void> getTheTakedMedicines() async {
    setState(() {
      showSpinner = true;
    });
    dataOfTakedMed = [];
    await FirebaseFirestore.instance
        .collection('Taked')
        .where('taked', isEqualTo: true)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        dataOfTakedMed.add(doc.data());
      });
      dataOfTakedMed.sort((a, b) => b["medDate"].compareTo(a["medDate"]));
      dataOfTakedMed.sort((a, b) => b["takedAt"].compareTo(a["takedAt"]));
      print(dataOfTakedMed[1]);
      setState(() {
        showSpinner = false;
      });
    }).catchError((error) {
      print("Error getting documents: $error");
      setState(() {
        showSpinner = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: _Colors['orange'],
        automaticallyImplyLeading: false,
        title: Text(
          'History',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SizedBox(
            height: 1000,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: dataOfTakedMed.length,
                    itemBuilder: (BuildContext context, int index) {
                      return HistoryCard(dataOfTakedMed[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
