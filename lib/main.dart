import 'package:activation/pages/lists/activation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Application Activation',
        home: const ActivationPage(),
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 60),
                backgroundColor: Colors.transparent,
                elevation: 0)));
  }
}
