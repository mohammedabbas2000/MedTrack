import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class Medications extends StatefulWidget {
  @override
  State<Medications> createState() => _MedicationsState();
}

bool showSpinner = false;
Map<String, Color> _Colors = {
  "orange": Color.fromARGB(255, 231, 146, 71),
  "blue": Color.fromARGB(255, 92, 107, 192)
};

class _MedicationsState extends State<Medications> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: _Colors['orange'],
        automaticallyImplyLeading: false,
        title: Text(
          'Medication Database',
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
            height: 1000,
            child: Column(
              children: [],
            )),
      ),
    );
  }
}
