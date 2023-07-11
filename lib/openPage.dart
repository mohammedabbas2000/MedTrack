import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medtrack/worngDialgo.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class OpenPage extends StatefulWidget {
  @override
  State<OpenPage> createState() => _OpenPageState();
}

class _OpenPageState extends State<OpenPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool obscure = true;
  late String email;
  late String password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/openPage.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.2,
                    top: MediaQuery.of(context).size.height * 0.2),
                child: Text(
                  'Welcome\nBack',
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/openPage2.png'),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.62),
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
                                  email = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    return 'Please Enter your Email.';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 225, 239, 248),
                                  labelText: "Enter your Email",
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 62, 37, 233)),

                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Color.fromARGB(255, 62, 37, 233),
                                  ),
                                  //hintText: 'Enter your email',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 62, 37, 233),
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 62, 37, 233),
                                        width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                obscureText: obscure,
                                onChanged: (value) {
                                  password = value;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    return 'Please Enter your Password.';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 225, 239, 248),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obscure = !obscure;
                                      });
                                    },
                                    child: Icon(
                                        color: Color.fromARGB(255, 62, 37, 233),
                                        obscure
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                  ),
                                  labelText: "Enter your password.",
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 62, 37, 233)),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Color.fromARGB(255, 62, 37, 233),
                                  ),
                                  //hintText: 'Enter your password.',
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 62, 37, 233),
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 62, 37, 233),
                                        width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sign in',
                                    style: TextStyle(
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Color(0xff4c505b),
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          setState(() {
                                            showSpinner = true;
                                          });
                                          if (!_formkey.currentState!
                                              .validate()) {
                                            return;
                                          }
                                          try {
                                            final user = await _auth
                                                .signInWithEmailAndPassword(
                                                    email: email,
                                                    password: password);
                                            final dataUser = await _firestore
                                                .collection('userData')
                                                .doc(email)
                                                .get();
                                            //setFCM(email);

                                            if (user != null) {
                                              Navigator.pushNamed(
                                                context,
                                                'homepage',
                                              );
                                            }
                                            setState(() {
                                              showSpinner = false;
                                            });
                                          } catch (e) {
                                            setState(() {
                                              showSpinner = false;
                                            });
                                            showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        worngDialgo(
                                                          text:
                                                              'email or password is invalid.',
                                                          type: "worng",
                                                        ));
                                            print(e);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, 'register');
                                    },
                                    child: Text(
                                      'Sign Up',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff4c505b),
                                          fontSize: 18),
                                    ),
                                    style: ButtonStyle(),
                                  ),
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Forgot Password',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff4c505b),
                                          fontSize: 18,
                                        ),
                                      )),
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
      ),
    );
  }
}
