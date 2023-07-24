import 'package:flutter/material.dart';

import 'package:medtrack/Medicins/MedicineTypeForm/medicineType.dart';

class MedicineTypeCard extends StatelessWidget {
  final MedicineType pillType;
  final Function handler;
  MedicineTypeCard(this.pillType, this.handler);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => handler(pillType),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.black12, // Border color
                width: 1.0, // Border width
              ),
              color: pillType.isChoose
                  ? Color.fromARGB(255, 231, 146, 71)
                  : Color.fromARGB(216, 255, 255, 255),
            ),
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5.0,
                ),
                Container(width: 50, height: 50.0, child: pillType.image),
                SizedBox(
                  height: 7.0,
                ),
                Container(
                    child: Text(
                  pillType.name,
                  style: TextStyle(
                      color: pillType.isChoose ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500),
                )),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        )
      ],
    );
  }
}
