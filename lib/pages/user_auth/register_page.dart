import 'package:book_store_app/pages/user_auth/login_page.dart';
import 'package:book_store_app/widgets/already_register_error_dialog.dart';
import 'package:book_store_app/widgets/confim_password_error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String errorMsg = "";
  String _displayName;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController nameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  void initState() {
    nameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    super.initState();
  }

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

  String pwdValidator(String value) {
    if (value.length < 6) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
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
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade200,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(16.0),
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Name*',
                                    hintText: "Saw Thandar"),
                                controller: nameInputController,
                              ),
                              const SizedBox(height: 10.0),
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
                              TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password*',
                                    hintText: "*******"),
                                controller: pwdInputController,
                                obscureText: true,
                                validator: pwdValidator,
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Confirm Password*',
                                    hintText: "*******"),
                                controller: confirmPwdInputController,
                                obscureText: true,
                                validator: pwdValidator,
                              ),
                              const SizedBox(height: 10.0),
                              RaisedButton(
                                  color: Colors.brown,
                                  textColor: Colors.brown.shade200,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text("Signup"),
                                  onPressed: () async {
                                    if (_registerFormKey.currentState
                                        .validate()) {
                                      if (pwdInputController.text ==
                                          confirmPwdInputController.text) {
                                        try {
                                          FirebaseUser user = await FirebaseAuth
                                              .instance
                                              .createUserWithEmailAndPassword(
                                            email: emailInputController.text,
                                            password: pwdInputController.text,
                                          );
                                          UserUpdateInfo updateInfo =
                                              new UserUpdateInfo();
                                          updateInfo.displayName =
                                              nameInputController.text;
                                          user
                                              .updateProfile(updateInfo)
                                              .then((currentUser) {
                                            Firestore.instance
                                                .collection('users')
                                                .document()
                                                .setData({
                                              "uid": user.uid,
                                              "name": nameInputController.text,
                                              "email":
                                                  emailInputController.text,
                                            }).then((value) {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Colors.brown.shade200,
                                                      title: Text("Welcome"),
                                                      content: Text(
                                                          "Register Successful!"),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                          child: Text("OK"),
                                                          onPressed: () {
                                                            nameInputController
                                                                .text = "";
                                                            emailInputController
                                                                .text = "";
                                                            pwdInputController
                                                                .text = "";
                                                            confirmPwdInputController
                                                                .text = "";
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          LoginPage()
                                                                  /*MainScreen(
                                                                            name:
                                                                                nameInputController.text,
                                                                            uid:
                                                                                user.uid,
                                                                          )*/
                                                                  ),
                                                            );
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            });
                                          });
                                        } catch (error) {
                                          switch (error.code) {
                                            case "ERROR_EMAIL_ALREADY_IN_USE":
                                              {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AlreadyRegisteredErrorDialog()));
                                              }
                                              break;
                                          }
                                        }
                                      } else {
                                        confirmPwdInputController.text = "";
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ConfirmPasswordErrorDialog()));
                                      }
                                    }
                                  }),
                              Text(
                                "Already have an acoount?",
                                textAlign: TextAlign.center,
                              ),
                              FlatButton(
                                child: Text(
                                  "Login here!",
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
