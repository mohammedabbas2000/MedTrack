import 'dart:convert';
import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/Medicins/MedicineTypeForm/medicineType.dart';
import 'package:medtrack/Medicins/MedicineTypeForm/medicineTypeCard.dart';
import 'package:medtrack/worngDialgo.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

class NewMedicine extends StatefulWidget {
  @override
  State<NewMedicine> createState() => _NewMedicineState();
}

final _auth = FirebaseAuth.instance;
bool showSpinner = false;
Map<String, Color> _Colors = {
  "orange": Color.fromARGB(255, 231, 146, 71),
  "blue": Color.fromARGB(255, 92, 107, 192)
};
final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
String pillName = '';
String pillAmount = '';
String pillType = '';
int pillWeek = 1;
String medForm = '';

final List<String> weightValues = ["ml", "mg"];
var _currentSliderValue = 2;
DateTime setDate = DateTime.now();
final List<MedicineType> medicineTypes = [
  MedicineType("Syrup", Image.asset("assets/images/syrup.png"), true),
  MedicineType("Pills", Image.asset("assets/images/pills.png"), false),
  MedicineType("Capsule", Image.asset("assets/images/capsule.png"), false),
  MedicineType("Cream", Image.asset("assets/images/cream.png"), false),
  MedicineType("Drops", Image.asset("assets/images/drops.png"), false),
  MedicineType("Syringe", Image.asset("assets/images/syringe.png"), false),
];

class _NewMedicineState extends State<NewMedicine> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void medicineTypeClick(MedicineType medicine) {
    setState(() {
      medicineTypes.forEach((medicineType) => medicineType.isChoose = false);
      medicineTypes[medicineTypes.indexOf(medicine)].isChoose = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusScope.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                // First color
                Color.fromARGB(255, 231, 146, 71),
                Color.fromARGB(255, 255, 255, 255), // Second color
              ],
            )),
        height: MediaQuery.of(context).size.height * 0.73,
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Text(
                    textAlign: TextAlign.center,
                    'New Medicine',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    thickness: 3,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Flexible(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          pillName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            setState(() {
                              showSpinner = false;
                            });
                            return 'Please Enter ${medicineTypes[medicineTypes.indexWhere((element) => element.isChoose == true)].name} Name.';
                          } else {
                            return null;
                          }
                        },
                        decoration: Decoration(
                          "${medicineTypes[medicineTypes.indexWhere((element) => element.isChoose == true)].name} Name",
                          Icon(
                            Icons.medication_liquid_sharp,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                pillAmount = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  return 'Please Enter ${medicineTypes[medicineTypes.indexWhere((element) => element.isChoose == true)].name} Amount.';
                                } else {
                                  return null;
                                }
                              },
                              decoration: Decoration(
                                "${medicineTypes[medicineTypes.indexWhere((element) => element.isChoose == true)].name} Amount",
                                null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  showSpinner = false;
                                });
                                return 'Please Enter Pill Type.';
                              } else {
                                return null;
                              }
                            },
                            onTap: () => focus.unfocus(),
                            items: weightValues
                                .map((weight) => DropdownMenuItem(
                                      child: Text(weight),
                                      value: weight,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              pillType = value!;
                            },
                            decoration: Decoration(
                              "type",
                              null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "How long?",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.white,
                        overlayColor: Color.fromARGB(106, 231, 146, 71),
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 10.0),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 25.0),
                        thumbColor: Color.fromARGB(255, 255, 255, 255)),
                    child: Slider(
                      value: _currentSliderValue.toDouble(),
                      min: 1,
                      max: 10,
                      inactiveColor: Color(0xFF8D8E98),
                      onChanged: (double newValue) {
                        pillWeek = newValue.toInt();
                        setState(() {
                          _currentSliderValue = newValue.toInt();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text('$_currentSliderValue weeks',
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Medicine form?",
                        style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          ...medicineTypes.map((type) =>
                              MedicineTypeCard(type, medicineTypeClick))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(216, 255, 255, 255),
                                ),
                                onPressed: () => openTimePicker(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat.Hm().format(setDate),
                                      style: const TextStyle(
                                          fontSize: 35,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Icon(
                                        Icons.access_time,
                                        size: 30,
                                        color:
                                            Color.fromARGB(255, 231, 146, 71),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(216, 255, 255, 255),
                                ),
                                onPressed: () => openDatePicker(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat("dd.MM").format(setDate),
                                      style: const TextStyle(
                                          fontSize: 35,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Icon(
                                        Icons.event,
                                        size: 30,
                                        color:
                                            Color.fromARGB(255, 231, 146, 71),
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
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          color: Colors.black12, // Border color
                          width: 1.0, // Border width
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 231, 146, 71),
                            shadowColor: Colors.black38),
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          if (!_formkey.currentState!.validate()) {
                            return;
                          }
                          await addMedicinesForWeeks(pillWeek);
                          Navigator.pop(context, 'refresh');

                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => worngDialgo(
                                    text:
                                        'You have successfully add the medicine..',
                                    type: "correct",
                                  ));
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openTimePicker() async {
    await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            helpText: "Choose Time")
        .then((value) {
      DateTime newDate = DateTime(
          setDate.year,
          setDate.month,
          setDate.day,
          value != null ? value.hour : setDate.hour,
          value != null ? value.minute : setDate.minute);
      setState(() => setDate = newDate);
      print(newDate.hour);
      print(newDate.minute);
    });
  }

  Future<void> openDatePicker() async {
    await showDatePicker(
            context: context,
            initialDate: setDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 100000)))
        .then((value) {
      DateTime newDate = DateTime(
          value != null ? value.year : setDate.year,
          value != null ? value.month : setDate.month,
          value != null ? value.day : setDate.day,
          setDate.hour,
          setDate.minute);
      setState(() => setDate = newDate);
      print(setDate.day);
      print(setDate.month);
      print(setDate.year);
    });
  }

  Future<void> createMedicineDate(DateTime date) async {
    User? user = _auth.currentUser;
    try {
      FirebaseFirestore.instance
          .collection('medicines')
          .doc(user!.email)
          .collection('dates')
          .doc(DateFormat("dd.MM.yy").format(date))
          .collection('medicinesList')
          .doc(
              '$pillName,${medicineTypes[medicineTypes.indexWhere((element) => element.isChoose == true)].name.toLowerCase()},${DateFormat.Hm().format(setDate)}')
          .set({
        'pillName': pillName,
        'pillAmount': pillAmount,
        'pillType': pillType,
        'pillWeek': pillWeek,
        'medForm': medicineTypes[
                medicineTypes.indexWhere((element) => element.isChoose == true)]
            .name
            .toLowerCase(),
        'medTime': DateFormat.Hm().format(setDate),
        'medDate': DateFormat("dd.MM").format(setDate)
      });

      setState(() {
        showSpinner = false;
      });
      print('Medicine date created successfully!');
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print('Error creating medicine date: $e');
    }
  }

  Future<void> addMedicinesForWeeks(int numberOfWeeks) async {
    if (numberOfWeeks < 1 || numberOfWeeks > 10) {
      throw ArgumentError("Number of weeks should be between 1 and 10.");
    }

    DateTime today = DateTime.now();
    DateTime weeksLater = today.add(Duration(days: numberOfWeeks * 7));

    for (DateTime date = today;
        date.isBefore(weeksLater);
        date = date.add(Duration(days: 1))) {
      createMedicineDate(date);
    }
  }

  InputDecoration Decoration(String text, dynamic icon) {
    return InputDecoration(
      filled: true,
      labelText: text,
      labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      prefixIcon: icon,
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
    );
  }
}
