import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/home_screen.dart';
import 'package:flutter_crud/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "Firebase Crud",
      theme: ThemeData(
        primarySwatch: Colors.deepOrange
      ),
      debugShowCheckedModeBanner: false,
      home:LoginPage()

    );
  }
}



