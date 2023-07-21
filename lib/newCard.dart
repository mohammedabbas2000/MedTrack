import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class newCard extends StatefulWidget {
  var dataOfUser;
  var dataOfPill;
  newCard(this.dataOfUser, this.dataOfPill);
  Map<String, Color> _Colors = {
    "orange": Color.fromARGB(255, 231, 146, 71),
    "blue": Color.fromARGB(255, 92, 107, 192)
  };

  @override
  State<newCard> createState() => _newCardState();
}

class _newCardState extends State<newCard> {
  Offset? _tapPosition;
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
                                '20 ${widget.dataOfPill['pillType']}, Take ${widget.dataOfPill['pillAmount']}',
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
        PopupMenuItem(
          child: Text(
            'Delete',
            style: TextStyle(
              color: Colors.red, // Customize the text color for "Delete"
              fontSize: 16.0, // Customize the font size for "Delete"
              fontWeight:
                  FontWeight.bold, // Customize the font weight for "Delete"
            ),
          ),
          value: 'delete',
        ),
        PopupMenuItem(
          child: Text(
            'Update',
            style: TextStyle(
              color: Colors.green, // Customize the text color for "Update"
              fontSize: 16.0, // Customize the font size for "Update"
              fontWeight:
                  FontWeight.bold, // Customize the font weight for "Update"
            ),
          ),
          value: 'update',
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 'delete') {
        // Handle delete action
        print('Delete option selected');
      } else if (value == 'update') {
        // Handle update action
        print('Update option selected');
      }
    });
  }
}
