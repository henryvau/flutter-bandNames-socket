import 'package:flutter/material.dart';
import 'pages/home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      routes: {'home':(_) => HomePage(),}
    );
  }
}
