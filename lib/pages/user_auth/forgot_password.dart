import 'package:book_store_app/pages/user_auth/login_page.dart';
import 'package:book_store_app/utils/check_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordPage extends StatefulWidget {
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailInputController =
      new TextEditingController();

  bool _loadingVisible = false;

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  static Future<void> forgotPasswordEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/book.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            color: Colors.black54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade200,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(16.0),
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Email*',
                                  hintText: "sawthandar1998.pw@gmail.com"),
                              controller: emailInputController,
                              keyboardType: TextInputType.emailAddress,
                              validator: emailValidator,
                            ),
                            const SizedBox(height: 10.0),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                onPressed: () {
                                  _forgotPassword(
                                      email: emailInputController.text,
                                      context: context);
                                },
                                padding: EdgeInsets.all(12),
                                color: Theme.of(context).primaryColor,
                                child: Text('FORGOT PASSWORD',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            InkWell(
                                child: Text(
                                  "Log in Here!",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  void _forgotPassword({String email, BuildContext context}) async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    try {
      await _changeLoadingVisible();
      await forgotPasswordEmail(email);
      await _changeLoadingVisible();
      Flushbar(
        backgroundColor: Colors.brown,
        title: "Password Reset Email Sent",
        message:
            'Check your email and follow the instructions to reset your password.',
        duration: Duration(seconds: 20),
      )..show(context);
    } catch (e) {
      _changeLoadingVisible();
      String exception = Auth.getExceptionText(e);
      Flushbar(
        backgroundColor: Colors.brown,
        title: "Error",
        message: exception,
        duration: Duration(seconds: 10),
      )..show(context);
    }
  }
}
