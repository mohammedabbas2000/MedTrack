import 'dart:convert';
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:medtrack/updateSoS.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model.dart';

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
  List<String> people = ["0502661444"];
  model model_x = new model();
  var currentLocation;
  late String lat;
  late String long;
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      showSpinner = true;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // The user has denied location permissions
        // Handle this situation as appropriate for your app
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // The user has permanently denied location permissions
      //    Ask the user to grant permissions from the app settings
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lat = position.latitude.toString();
      long = position.longitude.toString();
      setState(() {
        // currentLocation = LatLng(position.latitude, position.longitude);

        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: _Colors['orange'],
        automaticallyImplyLeading: false,
        title: Text(
          'Emergency',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(),
        centerTitle: true,
      ),
      bottomNavigationBar: model_x.buttomAppBar_app(context),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
            height: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Send Emergency Message",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      updateSOS.numbers.forEach((key, value) {
                        print(value.getname() +
                            '---' +
                            value.getphone().toString());
                      });
                      List<String> numbers = [];

                      updateSOS.numbers.forEach(
                        (key, value) {
                          if (value.getphone().toString() != "") {
                            numbers.add(value.getphone().toString());
                          }
                        },
                      );
                      print(numbers);
                      _getCurrentLocation();
                      print(lat + '---' + long);
                      setState(() {
                        print(lat + "---" + long);
                      });
                      print(numbers);
                      if (numbers.isNotEmpty) {
                        sendSMS(
                            message:
                                "Emergency! I need help \n https://www.google.com/maps/search/?api=1&query=$lat,$long",
                            recipients: numbers);
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Error"),
                                content:
                                    Text("Error ! No phone numbers found."),
                              );
                            });
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Icon(
                          Icons.sos,
                          size: MediaQuery.of(context).size.width * 0.3,
                        )),
                  ),
                ),
                Container(
                  height: 100,
                  width: 250,
                  child: Text(
                    "Send Emergency to your doctor, family members ...",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
