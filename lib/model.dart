import 'package:flutter/material.dart';

class model {
  Map<String, Color> _Colors = {
    "orange": Color.fromARGB(255, 231, 146, 71),
    "blue": Color.fromARGB(255, 92, 107, 192)
  };

  Widget buttomAppBar_app(context) {
    return BottomAppBar(
      height: 50,
      color: Color.fromARGB(255, 255, 255, 255),
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 30,
          ),
          IconButton(
            iconSize: 28,
            icon: Icon(
              Icons.home,
              color: _Colors['blue'],
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'homepage');
            },
          ),
          SizedBox(
            width: 30,
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
            onPressed: () {
              Navigator.pushNamed(context, 'settings');
            },
          ),
        ],
      ),
    );
  }
}
