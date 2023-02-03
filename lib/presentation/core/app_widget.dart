import 'package:flutter/material.dart';
import 'package:notes_firebase_ddd/presentation/sign_in/sign_in_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      home: SignInPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.green[800],
        colorScheme:
          ColorSheme.fromSwatch().copyWith(
            secondary: Colors.blueAccent,
          ),
        inputDecorationTheme:
          InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      ),
    );
  }
}
