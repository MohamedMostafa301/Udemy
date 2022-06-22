import 'package:flutter/material.dart';
import 'package:todo/screens/homePage.dart';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes:{
        HomePage.routeName:(context)=>HomePage(),
      },
      initialRoute: HomePage.routeName,
    );
  }
}
