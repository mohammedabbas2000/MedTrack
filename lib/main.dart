import 'package:flutter/material.dart';
// import 'package:medtrack/NewMed/newMed.dart';
import 'package:medtrack/graphs.dart';
import 'package:medtrack/medications.dart';
import 'package:medtrack/openPage.dart';
import 'package:medtrack/register.dart';
import 'package:medtrack/homePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medtrack/settings.dart';
import 'package:medtrack/updateSoS.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("mohammed $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stuck Service',
      initialRoute: 'MyHomePage',
      routes: {
        'MyHomePage': (context) => MyHomePage(),
        'register': (context) => MyRegister(),
        'homepage': (context) => HomePage(),
        'medications': (context) => Medications(),
        'settings': (context) => Settings(),
        'updateSOS': (context) => updateSOS(),
        'graphs': (context) => graphs(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: //AuthService().handleAuthState(),
          OpenPage(),
    ));
  }
}
