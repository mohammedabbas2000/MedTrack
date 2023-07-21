import 'dart:convert';
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

bool showSpinner = false;
Map<String, Color> _Colors = {
  "orange": Color.fromARGB(255, 231, 146, 71),
  "blue": Color.fromARGB(255, 92, 107, 192)
};

class _SettingsState extends State<Settings> {
  model model_x = new model();

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
          'Settings',
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
      bottomNavigationBar: model_x.buttomAppBar_app(context),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage("assets/set.jpg"))),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'updateSOS'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 6),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Text("Set SOS Phone Numbers",
                      style: TextStyle(
                        fontSize: 18,
                        color: _Colors['blue'],
                      )),
                ),
              )
              // CircleAvatar(
              //   radius: MediaQuery.of(context).size.width * 0.4,
              //   backgroundImage: AssetImage("assets/set.jpg"),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
