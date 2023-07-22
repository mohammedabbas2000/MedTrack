import 'dart:convert';
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class updateSOS extends StatefulWidget {
  static Map<String, field_w> numbers = {
    'Doctor': field_w("Doctor"),
    'Family': field_w("Family"),
  };
  updateSOS();
  @override
  State<updateSOS> createState() => _updateSOSState();
}

bool showSpinner = false;
Map<String, Color> _Colors = {
  "orange": Color.fromARGB(255, 231, 146, 71),
  "blue": Color.fromARGB(255, 92, 107, 192)
};

class _updateSOSState extends State<updateSOS> {
  // updateSOS temp = new updateSOS();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void _update_widget(String key) {}
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
                for (var element in updateSOS.numbers.keys) ...[
                  updateSOS.numbers[element.toString()] as Widget,
                ],
                IconButton(
                  color: _Colors["blue"],
                  onPressed: () {
                    setState(() {
                      updateSOS.numbers['phone' +
                          (updateSOS.numbers.length + 2)
                              .toString()] = field_w(
                          'phone ' + (updateSOS.numbers.length + 1).toString());
                      // text_field_for_phone(
                      //     'phone' + (numbers.length + 2).toString());
                    });
                  },
                  icon: Icon(
                    Icons.add_circle,
                    size: MediaQuery.of(context).size.width * 0.15,
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class field_w extends StatefulWidget {
  final String name;
  var phone = "";
  field_w(this.name);

  @override
  State<field_w> createState() => _field_wState();

  getphone() {
    return phone;
  }

  void setphone(var p) {
    this.phone = p;
  }

  String getname() {
    return name;
  }
}

class _field_wState extends State<field_w> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.name + ": ", style: TextStyle(fontSize: 20)),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.09,
            width: MediaQuery.of(context).size.width * 0.95,
            child: TextFormField(
              initialValue: widget.phone,
              onChanged: (value) {
                setState(() {
                  widget.phone = value;
                });

                //updateSOS.numbers.update(widget.name, (v) => new field_w(name));
                // updateSOS.numbers
              },
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
}
