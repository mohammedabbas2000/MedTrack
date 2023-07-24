import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  const YesNoDialog({required this.text, required this.type});
  final String text;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 180,
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Flexible(
              child: Container(
                width: 80,
                child: Image.asset('assets/question-mark.png'),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop('yes');
                    },
                    child: Text("Yes")),
                SizedBox(
                  width: 80,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop('no');
                    },
                    child: Text("No"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
