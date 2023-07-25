import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:medtrack/homePage.dart';
import 'package:medtrack/yes_noDialog.dart';
import 'package:medtrack/openPage.dart';

class HistoryCard extends StatefulWidget {
  var dataOfPill;

  HistoryCard(
    this.dataOfPill,
  );
  Map<String, Color> _Colors = {
    "orange": Color.fromARGB(255, 231, 146, 71),
    "blue": Color.fromARGB(255, 92, 107, 192)
  };

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;

class _HistoryCardState extends State<HistoryCard> {
  bool taked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Center(
              child: Text(
                '  Taked at ${widget.dataOfPill['takedAt']} \n ${widget.dataOfPill['medDate']}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 87, 87,
                      87), // Set the desired text color for the subtitle
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: Colors.black12, // Border color
                    width: 1.0, // Border width
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255, 255), // First color
                      Colors.cyan, // Second color
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        child: ListTile(
                          leading: Image.asset(
                            "assets/images/${widget.dataOfPill['medForm']}.png",
                            fit: BoxFit.cover,
                            width: 55.0,
                          ),
                          title: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.dataOfPill['pillName']
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '  Take ${widget.dataOfPill['pillAmount']} ${widget.dataOfPill['pillType']}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 87, 87,
                                        87), // Set the desired text color for the subtitle
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
