import 'package:flutter/material.dart';
import 'login.dart';
import 'homepage.dart';

/// main class of the whole app, defines the theme data here

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        bottomAppBarColor: Colors.blue,
        backgroundColor: const Color(0xFFdaecf7),
        textSelectionColor: Colors.black87,
        disabledColor: Colors.white,
        buttonColor: Colors.grey,
      ),

      /// note that initial route means the first page where the app opens
      initialRoute: '/',

      /// define named routes for easy pop up
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
