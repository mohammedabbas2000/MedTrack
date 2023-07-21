import 'dart:convert';
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class updateSOS extends StatefulWidget {
  @override
  State<updateSOS> createState() => _updateSOSState();
}

bool showSpinner = false;
Map<String, Color> _Colors = {
  "orange": Color.fromARGB(255, 231, 146, 71),
  "blue": Color.fromARGB(255, 92, 107, 192)
};

class _updateSOSState extends State<updateSOS> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  Widget text_field_for_phone(String name) {
    return Row(
      children: [
        Text(name + ": ", style: TextStyle(fontSize: 20)),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.09,
            width: MediaQuery.of(context).size.width * 0.95,
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.black12,
                  filled: true),
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: _Colors['orange'],
        automaticallyImplyLeading: false,
        title: Text(
          'Update SOS Phone Numbers',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(),
        actions: [],
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            height: 1000,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                text_field_for_phone("Doctor"),
                text_field_for_phone("Family")
              ],
            )),
      ),
    );
  }
}
