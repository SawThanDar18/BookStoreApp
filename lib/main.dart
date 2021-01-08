import 'file:///D:/Juicy/Work/book_store_app/book_store_app/lib/pages/user_auth/user_authentication.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(backgroundColor: Colors.white, primarySwatch: Colors.brown),
      home: UserAuthenticationPage(),
    );
  }
}
