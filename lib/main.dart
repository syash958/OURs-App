import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:our/screens/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Ours',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: welcome(),
     // home: welcome(),
    );
  }
}


//await FirebaseAuth.instance.signOut();
