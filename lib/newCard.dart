import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:medtrack/homePage.dart';
import 'package:medtrack/yes_noDialog.dart';
import 'package:medtrack/openPage.dart';

class newCard extends StatefulWidget {
  var dataOfUser;
  var dataOfPill;
  final Function(String) isDelete;
  newCard(this.dataOfUser, this.dataOfPill, this.isDelete, {super.key});
  Map<String, Color> _Colors = {
    "orange": Color.fromARGB(255, 231, 146, 71),
    "blue": Color.fromARGB(255, 92, 107, 192)
  };

  @override
  State<newCard> createState() => _newCardState();
}

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;

class _newCardState extends State<newCard> {
  Offset? _tapPosition;
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
                '${widget.dataOfPill['medTime']}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onDoubleTap: () {
                DateTime now = DateTime.now();
                setState(() {
                  if (taked == true) {
                    print(widget.dataOfPill);
                    taked = false;
                    Map<String, dynamic> data = {
                      'medTime': widget.dataOfPill['medTime'],
                      'pillName': widget.dataOfPill['pillName'],
                      'medForm': widget.dataOfPill['medForm'],
                      'pillAmount': widget.dataOfPill['pillAmount'].toString(),
                      'pillType': widget.dataOfPill['pillType'].toString(),
                      'pillWeek': widget.dataOfPill['pillWeek'].toString(),
                      'medDate': widget.dataOfPill['medDate'].toString(),
                      'taked': taked
                    };

                    _firestore
                        .collection("Taked")
                        .doc(widget.dataOfPill['medTime'].toString() +
                            "-" +
                            widget.dataOfPill['medDate'].toString())
                        .set(data);
                  } else {
                    taked = true;

                    Map<String, dynamic> data = {
                      'medTime': widget.dataOfPill['medTime'],
                      'pillName': widget.dataOfPill['pillName'],
                      'medForm': widget.dataOfPill['medForm'],
                      'pillAmount': widget.dataOfPill['pillAmount'].toString(),
                      'pillType': widget.dataOfPill['pillType'].toString(),
                      'pillWeek': widget.dataOfPill['pillWeek'].toString(),
                      'medDate': widget.dataOfPill['medDate'].toString(),
                      'taked': taked,
                      'takedAt': DateFormat.Hm().format(now)
                    };

                    _firestore
                        .collection("Taked")
                        .doc(widget.dataOfPill['medTime'].toString() +
                            "-" +
                            widget.dataOfPill['medDate'].toString())
                        .set(data);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: Colors.black12, // Border color
                    width: 1.0, // Border width
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 255, 255), // First color
                      !taked
                          ? Color.fromARGB(255, 231, 146, 71)
                          : Colors.cyan, // Second color
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
                        onTapDown: (details) {
                          // Store the tap position when tapped
                          setState(() {
                            _tapPosition = details.globalPosition;
                          });
                        },
                        onLongPress: () {
                          _showPopupMenu(context);
                        },
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

  void _showPopupMenu(BuildContext context) async {
    if (_tapPosition == null) return;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          _tapPosition!, // Use the stored tap position
          _tapPosition!, // Use the stored tap position
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem(
          value: 'delete',
          child: Text(
            'Delete',
            style: TextStyle(
              color: Colors.red, // Customize the text color for "Delete"
              fontSize: 16.0, // Customize the font size for "Delete"
              fontWeight:
                  FontWeight.bold, // Customize the font weight for "Delete"
            ),
          ),
        ),
        const PopupMenuItem(
          value: 'deleteAll',
          child: Text(
            'Delete All',
            style: TextStyle(
              color: Colors.red, // Customize the text color for "Delete"
              fontSize: 16.0, // Customize the font size for "Delete"
              fontWeight:
                  FontWeight.bold, // Customize the font weight for "Delete"
            ),
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) async {
      if (value == 'delete') {
        // Handle delete action
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => const YesNoDialog(
                  text: 'Are you sure that need to delete this medicine',
                  type: "question",
                )).then((value) async {
          if (value == 'yes') {
            await deleteOne();
            widget.isDelete('refresh');
          }
        });

        print('Delete option selected');
      } else if (value == 'deleteAll') {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => const YesNoDialog(
                  text: 'Are you sure that need to delete this medicine',
                  type: "question",
                )).then((value) async {
          if (value == 'yes') {
            await deleteAll();
            widget.isDelete('refresh');
          }
        });
      }
    });
  }

  Future<void> deleteAll() async {
    try {
      String medicinesId =
          '${widget.dataOfPill['pillName']},${widget.dataOfPill['medForm']},${widget.dataOfPill['medTime']}';
      DateTime today = DateTime.now();
      DateTime twoWeeksAfterToday = today.add(Duration(days: 14));

      for (DateTime date = today;
          date.isBefore(twoWeeksAfterToday);
          date = date.add(Duration(days: 1))) {
        await FirebaseFirestore.instance
            .collection('medicines')
            .doc(user!.email)
            .collection('dates')
            .doc(DateFormat("dd.MM.yy").format(date))
            .collection('medicinesList')
            .doc(medicinesId)
            .delete();
      }
    } catch (error) {
      print("Error deleting documents: $error");
    }
  }

  Future<void> deleteOne() async {
    try {
      String medicinesId =
          '${widget.dataOfPill['pillName']},${widget.dataOfPill['medForm']},${widget.dataOfPill['medTime']}';
      DateTime today = DateTime.now();
      DateTime twoWeeksAfterToday = today.add(Duration(days: 14));
      print(widget.dataOfPill['medDate'] + '.23');
      print(medicinesId);
      await FirebaseFirestore.instance
          .collection('medicines')
          .doc(user!.email)
          .collection('dates')
          .doc(widget.dataOfPill['medDate'] + '.23')
          .collection('medicinesList')
          .doc(medicinesId)
          .delete();
    } catch (error) {
      print("Error deleting documents: $error");
    }
  }
}
