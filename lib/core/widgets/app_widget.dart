import 'package:flutter/material.dart';
import 'package:rotaract/constants/constants.dart';
import 'package:rotaract/features/auth/presentation/widgets/auth_widget.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.kAppTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
          centerTitle: false,
        ),
      ),
      home: const AuthWidget(),
    );
  }
}
