import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medtrack/worngDialgo.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  String Fullname = '';
  bool obscure = true;
  bool password_conf = true;
  bool confirm_obscure = true;
  bool showSpinner = false;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late String email = '';
  late String password = '';
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  //A function that validate user entered password
  bool validatePassword(String pass) {
    String _password = pass.trim();
    if (pass_valid.hasMatch(_password)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35, top: 30),
              child: Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextFormField(
                                textInputAction: TextInputAction.next,
                                onChanged: (value) {
                                  Fullname = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter your full name.';
                                  } else {
                                    return null;
                                  }
                                },
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                decoration: kTextFieldDecoration.copyWith(
                                  hintText: 'Enter Full name',
                                  hintStyle: TextStyle(color: Colors.white),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                )),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                                textInputAction: TextInputAction.next,
                                onChanged: (value) {
                                  email = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter your Email.';
                                  } else {
                                    return null;
                                  }
                                },
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                decoration: kTextFieldDecoration.copyWith(
                                    hintText: 'Enter your email',
                                    hintStyle: TextStyle(color: Colors.white),
                                    prefixIcon: Icon(Icons.email,
                                        color: Colors.white.withOpacity(0.7)))),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              obscureText: obscure,
                              toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: false,
                                selectAll: false,
                              ),
                              onChanged: (value) {
                                password = value;
                              },
                              validator: (value) {
                                bool password_checker =
                                    validatePassword(value!);

                                if (value.isEmpty) {
                                  return 'Please Enter your Password.';
                                } else {
                                  if (password_checker) {
                                    return null;
                                  } else if (value.length <= 6) {
                                    return "should be at least 6 characters";
                                  } else {
                                    return "should contain [A-Z,a-z,0-9,Special characters]";
                                  }
                                }
                              },
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscure = !obscure;
                                    });
                                  },
                                  child: Icon(
                                      color: Colors.white,
                                      obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                ),
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.lock,
                                    color: Colors.white.withOpacity(0.7)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              obscureText: confirm_obscure,
                              toolbarOptions: const ToolbarOptions(
                                copy: true,
                                cut: true,
                                paste: false,
                                selectAll: false,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value == '') {
                                    print('hhhh');
                                  }
                                  if (value == password || value == '') {
                                    password_conf = true;
                                  } else {
                                    password_conf = false;
                                  }
                                });
                                //Do something with the user input.
                              },
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      confirm_obscure = !confirm_obscure;
                                    });
                                  },
                                  child: Icon(
                                      color: Colors.white,
                                      confirm_obscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                ),
                                hintText: 'Confirm your password',
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.lock,
                                    color: Colors.white.withOpacity(0.7)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0)),
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              padding: EdgeInsetsDirectional.only(
                                  start: 30, top: 10),
                              alignment: Alignment.centerLeft,
                              child: password_conf == false
                                  ? Text(
                                      "Password are not matching",
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : Text(''),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700),
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color(0xff4c505b),
                                  child: IconButton(
                                      color: Colors.white,
                                      onPressed: () async {
                                        try {
                                          if (!_formkey.currentState!
                                              .validate()) {
                                            return;
                                          }

                                          if (password_conf) {
                                            final newUser = await _auth
                                                .createUserWithEmailAndPassword(
                                                    email: email,
                                                    password: password);
                                            if (newUser != null) {
                                              await _firestore
                                                  .collection("userData")
                                                  .doc(email)
                                                  .set({
                                                'Fullname': Fullname,
                                              });
                                            }

                                            showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        worngDialgo(
                                                          text:
                                                              'You have successfully signed up..',
                                                          type: "correct",
                                                        ));

                                            //Navigator.pushNamed(context, 'userpage');
                                          } else {
                                            showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        worngDialgo(
                                                          text:
                                                              "Password are not matching",
                                                          type: 'worng',
                                                        ));
                                          }
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code ==
                                              'email-already-in-use') {
                                            showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        worngDialgo(
                                                          text:
                                                              'The email address is already in use by another account.',
                                                          type: "worng",
                                                        ));
                                            print("$e");
                                          }
                                        }
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward,
                                      )),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Sign In',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                  style: ButtonStyle(),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const kTextFieldDecoration = InputDecoration(
  hintText: '',
  prefixIcon: null,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
