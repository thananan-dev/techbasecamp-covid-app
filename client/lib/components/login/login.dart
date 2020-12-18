import 'package:client/components/app/mainScreen.dart';
import 'package:client/components/register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: LoginScreen(),
      ),
    );
  }
}

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;

  String password;

  @override
  Widget build(context) {
    final _formKey = GlobalKey<FormState>();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Future<void> _handleSignIn() async {
      try {
        await _googleSignIn.signIn().then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen())));
      } catch (error) {
        print(error);
      }
    }

    void _showMessage(String message) {
      setState(() {});
    }

    Future<Null> _login() async {
      final FacebookLoginResult result =
          await LoginScreen.facebookSignIn.logIn(['email']);

      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          final FacebookAccessToken accessToken = result.accessToken;
          _showMessage('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

          return Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
          break;
        case FacebookLoginStatus.cancelledByUser:
          _showMessage('Login cancelled by the user.');
          break;
        case FacebookLoginStatus.error:
          _showMessage('Something went wrong with the login process.\n'
              'Here\'s the error Facebook gave us: ${result.errorMessage}');
          break;
      }
    }

    void _onClickLogin() async {
      var url =
          'https://us-central1-covid-reporter-ae343.cloudfunctions.net/api/auth';
      await http.post(url, body: {"email": email, "password": password}).then(
          (value) {
        var getStatus = convert.jsonDecode(value.body);
        //print(getStatus['status']);
        if (getStatus['status'] == "succes")
          return Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
      }).catchError((onError) => print("Errors : $onError"));
      //var jsonResponse = convert.jsonDecode(response.body);
      //print('Response body: $jsonResponse');
      //Navigator.push(context, MaterialPageRoute(builder: (context) => Score()));
    }

    void _onClickRegister() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Register()));
    }

    void _onClickForgotpassword() {
      print("Route to forgotten()");
    }

    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text("Space for Icon"),
            ),
          ),
          Expanded(
              flex: 3,
              child: Container(
                  child: Center(
                      child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: (screenWidth * 5) / 100),
                child: Column(
                  children: [
                    // =================================================== Form layout ===================================================
                    Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            onChanged: (value) => {email = value},
                            decoration:
                                InputDecoration(hintText: "Email address"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            obscureText: true,
                            onChanged: (value) => {password = value},
                            decoration: InputDecoration(hintText: "Password"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: (screenHeight * 3) / 100,
                                    bottom: (screenHeight * 4) / 100),
                                child: RaisedButton(
                                  color: Colors.red[400],
                                  textColor: Colors.white,
                                  child: Text("LOGIN"),
                                  padding: EdgeInsets.symmetric(
                                      vertical: (screenWidth * 2) / 100),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _onClickLogin();
                                    }
                                  },
                                ),
                              ))
                        ])),

                    Container(
                      margin: EdgeInsets.only(bottom: (screenHeight * 5) / 100),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                                child: Center(
                                    child: GestureDetector(
                              onTap: () {
                                _onClickRegister();
                              },
                              child: Text(
                                'Register account',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ))),
                          ),
                          Expanded(
                            child: Container(
                                child: Center(
                                    child: GestureDetector(
                              onTap: () {
                                _onClickForgotpassword();
                              },
                              child: Text(
                                'Forgot password',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ))),
                          ),
                        ],
                      ),
                    ),

                    // =================================================== Google button ===================================================
                    SizedBox(
                        width: double.infinity,
                        child: SignInButton(
                          Buttons.Google,
                          onPressed: () {
                            _handleSignIn();
                          },
                        )),

                    // =================================================== Facebook button ===================================================
                    SizedBox(
                        width: double.infinity,
                        child: SignInButton(
                          Buttons.Facebook,
                          onPressed: () {
                            _login();
                          },
                        )),
                  ],
                ),
              )))),
        ],
      ),
    );
  }
}
