import 'package:flutter/material.dart';

class worngDialgo extends StatelessWidget {
  const worngDialgo({required this.text, required this.type});
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
            Flexible(
              child: Container(
                width: 80,
                child: type == "correct"
                    ? Image.asset('assets/correct.png')
                    : Image.asset('assets/worng.png'),
              ),
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
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"))
          ],
        ),
      ),
    );
  }
}
