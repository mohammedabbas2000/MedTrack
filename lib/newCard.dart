import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class newCard extends StatefulWidget {
  var dataOfUser;
  var dataOfPill;
  newCard(this.dataOfUser);
  Map<String, Color> _Colors = {
    "orange": Color.fromARGB(255, 231, 146, 71),
    "blue": Color.fromARGB(255, 92, 107, 192)
  };
  @override
  State<newCard> createState() => _newCardState();
}

class _newCardState extends State<newCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            width: 100,
            child: Center(
              child: Text(
                '8:00 AM',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
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
                    Color.fromARGB(255, 231, 146, 71), // Second color
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
                    ListTile(
                      leading: Image.asset(
                        "assets/pill.png",
                        fit: BoxFit.cover,
                        width: 40.0,
                      ),
                      title: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'OPTALGIN',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              '20 mg, Take 1',
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
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
