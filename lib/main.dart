import 'package:flutter/material.dart';
//import 'package:teemo_front/screens/login.dart';
import 'package:teemo_front/screens/test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: LoginPage(),
      // home: MapScreen(memberId: '2'),
      home: MyWidget(),
    );
  }
}
