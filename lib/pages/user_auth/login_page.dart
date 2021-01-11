import 'package:book_store_app/pages/main_screen.dart';
import 'package:book_store_app/pages/user_auth/forgot_password.dart';
import 'package:book_store_app/pages/user_auth/register_page.dart';
import 'package:book_store_app/utils/check_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMsg = "";
  bool _passwordVisible = false;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  void initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    _passwordVisible = false;
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
    if (value.length < 8) {
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
                            TextFormField(
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(),
                                  labelText: 'Password*',
                                  hintText: "*******"),
                              controller: pwdInputController,
                              obscureText: !_passwordVisible,
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
                                child: Text("Login"),
                                onPressed: () async {
                                  try {
                                    FirebaseUser user = await FirebaseAuth
                                        .instance
                                        .signInWithEmailAndPassword(
                                          email: emailInputController.text,
                                          password: pwdInputController.text,
                                        )
                                        .then((currentUser) => showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Colors.brown.shade200,
                                                    title: Text("Welcome"),
                                                    content: Text(
                                                        "Login Successful!"),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text("OK"),
                                                        onPressed: () {
                                                          emailInputController
                                                              .text = "";
                                                          pwdInputController
                                                              .text = "";
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator
                                                              .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MainScreen(
                                                                          name:
                                                                              currentUser.displayName,
                                                                          uid: currentUser
                                                                              .uid,
                                                                        )),
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  );
                                                }) //show dialog
                                            );
                                  } catch (e) {
                                    String exception = Auth.getExceptionText(e);

                                    Flushbar(
                                      backgroundColor: Colors.brown,
                                      title: "Network Error",
                                      message: exception,
                                      duration: Duration(seconds: 10),
                                    )..show(context);

                                    Flushbar(
                                      backgroundColor: Colors.brown,
                                      title: "Invalid Email Error",
                                      message: exception,
                                      duration: Duration(seconds: 10),
                                    )..show(context);

                                    Flushbar(
                                      backgroundColor: Colors.brown,
                                      title: "Invalid Password Error",
                                      message: exception,
                                      duration: Duration(seconds: 10),
                                    )..show(context);

                                    /*switch (e.code) {
                                      case "ERROR_USER_NOT_FOUND":
                                        {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UnregisterErrorDialog()));
                                        }
                                        break;

                                      case "ERROR_WRONG_PASSWORD":
                                        {
                                          pwdInputController.text = "";
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PasswordErrorDialog()));
                                        }
                                        break;
                                    }*/
                                  }
                                }),
                            Text(
                              "Don't have an account yet?",
                              textAlign: TextAlign.center,
                            ),
                            FlatButton(
                                child: Text(
                                  "Register here!",
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()),
                                  );
                                }),
                            InkWell(
                                child: Text(
                                  "Forgot Password",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.w500),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPasswordPage()),
                                  );
                                })
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

  static String getExceptionText(Exception e) {
    if (e is PlatformException) {
      switch (e.message) {
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          return 'User with this email address not found.';
          break;
        case 'The password is invalid or the user does not have a password.':
          return 'Invalid password.';
          break;
        case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
          return 'No internet connection.';
          break;
        case 'The email address is already in use by another account.':
          return 'This email address already has an account.';
          break;
        default:
          return 'Unknown error occured.';
      }
    } else {
      return 'Unknown error occured.';
    }
  }
}
