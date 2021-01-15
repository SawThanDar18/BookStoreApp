import 'dart:async';
import 'package:book_store_app/pages/user_auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class VerifyGmail extends StatefulWidget {
  @override
  _VerifyGmailState createState() => _VerifyGmailState();
}

class _VerifyGmailState extends State<VerifyGmail> {
  FirebaseUser currentUser;
  Timer timer;

  @override
  void initState() {
    this.getCurrentUser();
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void getCurrentUser() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    currentUser.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0, bottom: 0),
        child: Text(
          'Please check your Gmail Account and verify to continue....',
          style: TextStyle(
            color: Colors.brown,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    currentUser = await FirebaseAuth.instance.currentUser();
    await currentUser.reload();
    if (currentUser.isEmailVerified) {
      timer.cancel();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.brown.shade200,
              title: Text("Welcome"),
              content: Text("Verify Successful!"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                )
              ],
            );
          });
    } else {
      Flushbar(
        backgroundColor: Colors.brown,
        title: "Verification Email",
        message: 'Please check your gmail and verify!',
        duration: Duration(seconds: 2),
      )..show(context);
      return currentUser.uid;
    }
  }
}
