import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/NewMed/newMed.dart';
import 'package:medtrack/newCard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
bool showSpinner = false;
Map<String, dynamic> dataOfUser = {};
Map<String, Color> _Colors = {
  "orange": Color.fromARGB(255, 231, 146, 71),
  "blue": Color.fromARGB(255, 92, 107, 192)
};

class _HomePageState extends State<HomePage> {
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  User? user = _auth.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    getDataOfUser();
    super.initState();
  }

  void getDataOfUser() async {
    setState(() {
      showSpinner = true;
    });
    final events =
        await _firestore.collection('userData').doc(user?.email).get();
    if (events != null) {
      print(events['Fullname']);
      dataOfUser['email'] = user?.email;
      dataOfUser['name'] = events['Fullname'];
    }
    setState(() {
      showSpinner = false;
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
          (dataOfUser['name']).toString(),
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  // Perform action when the icon is pressed
                },
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => NewMedicine());
                },
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
            height: 1000,
            child: Column(
              children: [
                TableCalendar(
                  rowHeight: 40,
                  firstDay: DateTime.utc(2010, 10, 20),
                  lastDay: DateTime.utc(2040, 10, 20),
                  focusedDay: focusedDay,
                  headerVisible: true,
                  daysOfWeekVisible: true,
                  sixWeekMonthsEnforced: true,
                  shouldFillViewport: false,
                  onDaySelected: _onDaySelected,
                  selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                  headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                          fontSize: 20,
                          color: _Colors['blue'],
                          fontWeight: FontWeight.w800)),
                  availableGestures: AvailableGestures.all,
                  calendarStyle: CalendarStyle(
                      todayTextStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  calendarFormat: CalendarFormat.week,
                ),
                Center(
                    child: Text(
                  'Today, ${focusedDay.day} ${DateFormat.MMM().format(focusedDay)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: _Colors['orange']),
                )),
                SizedBox(
                  height: 10,
                ),
                //noPill(context),
                Expanded(
                  //color: Color.fromARGB(255, 240, 240, 240),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount:
                        3, // Replace with the actual number of items in your list
                    itemBuilder: (BuildContext context, int index) {
                      return newCard(dataOfUser);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _Colors['orange'],
        //Floating action button on Scaffold
        onPressed: () async {
          //code to execute on button press
        },
        child: Icon(
          Icons.add,
          size: 30,
        ), //icon inside button
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,

      bottomNavigationBar: BottomAppBar(
        height: 50,
        //bottom navigation bar on scaffold
        color: Color.fromARGB(255, 255, 255, 255),
        shape: CircularNotchedRectangle(), //shape of notch
        notchMargin:
            5, //notche margin between floating button and bottom appbar
        child: Row(
          //children inside bottom appbar
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 110,
            ),
            IconButton(
              iconSize: 28,
              icon: Icon(
                Icons.analytics_outlined,
                color: _Colors['blue'],
              ),
              onPressed: () {},
            ),
            SizedBox(
              width: 30,
            ),
            IconButton(
              iconSize: 28,
              icon: Icon(
                Icons.history,
                color: _Colors['blue'],
              ),
              onPressed: () {},
            ),
            SizedBox(
              width: 30,
            ),
            IconButton(
              iconSize: 28,
              icon: Icon(
                Icons.medication,
                color: _Colors['blue'],
              ),
              onPressed: () {
                Navigator.pushNamed(context, 'medications');
              },
            ),
            SizedBox(
              width: 30,
            ),
            IconButton(
              iconSize: 28,
              icon: Icon(
                Icons.person_3_outlined,
                color: _Colors['blue'],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Column noPill(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.99,
          height: MediaQuery.of(context).size.height * 0.47,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/noPill.png'),
            ),
          ),
        ),
        Column(
          children: const [
            Text(
              'Monitor your med scedule',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'View your daily schedule and mark \n your meds when taken',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black38,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.07,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: _Colors['orange'],
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Add a Medicine',
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onDaySelected(DateTime _selectedDay, DateTime focusedDay) {
    setState(() {
      selectedDay = _selectedDay;
    });
  }
}
