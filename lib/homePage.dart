import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medtrack/Medicins/newMed.dart';
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
List<Map<String, dynamic>> medInDate = [];
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
    getTheMedicines();
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

  Future<void> getTheMedicines() async {
    setState(() {
      showSpinner = true;
    });

    await FirebaseFirestore.instance
        .collection('medicines')
        .doc(user!.email)
        .collection('dates')
        .doc(DateFormat("dd.MM.yy").format(selectedDay))
        .collection('medicinesList')
        .get()
        .then((querySnapshot) {
      List<Map<String, dynamic>> dataList = [];
      querySnapshot.docs.forEach((doc) {
        dataList.add(doc.data());
      });

      print(dataList);
      medInDate = dataList;
      setState(() {
        showSpinner = false;
      });
    }).catchError((error) {
      print("Error getting documents: $error");
      setState(() {
        showSpinner = false;
      });
    });

    // await FirebaseFirestore.instance
    //     .collection('medicines')
    //     .doc(user!.email)
    //     .collection('dates')
    //     .get()
    //     .then((querySnapshot) {
    //   List<Map<String, dynamic>> dataList = [];
    //   if (querySnapshot.docs.isNotEmpty) {
    //     print(querySnapshot);
    //     querySnapshot.docs.forEach((doc) {
    //       FirebaseFirestore.instance
    //           .collection('dates')
    //           .doc(doc.id)
    //           .collection('medicinesList')
    //           .get()
    //           .then((Snapshot2) {
    //         print("-------------------------");
    //         print(doc.id);
    //         print(Snapshot2.docs);
    //       });

    //       dataList.add(doc.data());
    //     });
    //   } else {
    //     print("Empty");
    //   }

    //   print(dataList);
    //   medInDate = dataList;
    //   setState(() {
    //     showSpinner = false;
    //   });
    // }).catchError((error) {
    //   print("Error getting documents: $error");
    //   setState(() {
    //     showSpinner = false;
    //   });
    // });

    //  try {
    //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //       .collection('medicines')
    //       .doc(user!.email)
    //       .collection('dates')
    //       .get();

    //   List<Map<String, dynamic>> dataList = [];
    //   if (querySnapshot.docs.isNotEmpty) {
    //     for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    //       QuerySnapshot subCollectionSnapshot = await FirebaseFirestore.instance
    //           .collection('medicines')
    //           .doc(user!.email)
    //           .collection('dates')
    //           .doc(doc.id)
    //           .collection('medicinesList')
    //           .get();

    //       List<Map<String, dynamic>> subDataList = [];
    //       subCollectionSnapshot.docs.forEach((subDoc) {

    //         subDataList.add(subDoc.data());
    //       });

    //       print('Date: ${doc.id}, Medicines List: $subDataList');
    //       dataList.addAll(subDataList);
    //     }
    //   } else {
    //     print('No data found in the "dates" subcollection for the user.');
    //   }

    //   setState(() {
    //     medInDate = dataList;
    //     showSpinner = false;
    //   });
    // } catch (error) {
    //   print('Error getting documents: $error');
    //   setState(() {
    //     showSpinner = false;
    //   });
    // }
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
                onPressed: () async {
                  await getTheMedicines();
                },
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => NewMedicine())
                      .then((result) async {
                    if (result != null && result == 'refresh') {
                      // The dialog returned a 'refresh' result, call the function to get the medicines.
                      await getTheMedicines();
                    }
                  });
                  ;
                },
              ),
            ],
          ),
        ],
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SizedBox(
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Selected Day, ${selectedDay.day} ${DateFormat.MMM().format(selectedDay)} ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: _Colors['blue']),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Today, ${focusedDay.day} ${DateFormat.MMM().format(focusedDay)} ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _Colors['orange']),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                medInDate.length == 0
                    ? noPill(context)
                    : Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: medInDate.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> medicineData =
                                medInDate[index];
                            return newCard(dataOfUser, medInDate[index]);
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
        onPressed: () async {},
        child: Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      bottomNavigationBar: BottomAppBar(
        height: 50,
        color: Color.fromARGB(255, 255, 255, 255),
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
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
              onPressed: () {
                Navigator.pushNamed(context, 'graphs');
              },
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

  Widget noPill(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.99,
              height: MediaQuery.of(context).size.height * 0.47,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/noPill.png'),
                ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: SizedBox(
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
          ),
        ],
      ),
    );
  }

  void _onDaySelected(DateTime _selectedDay, DateTime focusedDay) async {
    setState(() {
      selectedDay = _selectedDay;
    });
    await getTheMedicines();
  }
}
