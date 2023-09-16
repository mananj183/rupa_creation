import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modal/http_exception.dart';
import '../provider/auth.dart';

enum AuthMode { signup, login }

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              // alignment: Alignment.bottomRight,
              color: Colors.white,
              height: deviceSize.height,
              width: deviceSize.width,
              child: Container(
                  alignment: Alignment.bottomRight,
                  width: deviceSize.width,
                  height: deviceSize.height,
                  child: Image.asset(
                    'assets/images/login_bg.jpg',
                    fit: BoxFit.fitHeight,
                    width: deviceSize.width,
                    height: deviceSize.height,
                  )),
            ),
            Column(
              children: [
                Container(
                  height: 120,
                  width: deviceSize.width,
                  color: Colors.transparent,
                ),
                Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Container(
                          height: 110,
                          width: deviceSize.width / 1.25,
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent.shade400,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30)))),
                      Container(
                        height: 110,
                        width: deviceSize.width / 1.25,
                        decoration: const BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 10, right: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: deviceSize.width / 5,
                              height: deviceSize.width / 5,
                              color: Colors.transparent,
                              child: Image.asset('assets/images/rupa_logo.png',
                                  fit: BoxFit.cover),
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 3),
                                  width: deviceSize.width / 1.4 -
                                      deviceSize.width / 7,
                                  height: 45,
                                  color: Colors.transparent,
                                  child: const Text('Rupa',
                                      style: TextStyle(
                                          fontSize: 47,
                                          fontFamily: 'Alta',
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF221C35))),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 1),
                                  alignment: Alignment.centerRight,
                                  width: deviceSize.width / 1.4 -
                                      deviceSize.width / 7,
                                  height: 45,
                                  color: Colors.transparent,
                                  child: const Text('Creation',
                                      style: TextStyle(
                                          fontSize: 47,
                                          fontFamily: 'Alta',
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF221C35))),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: deviceSize.width > 600 ? 1 : 2,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {'email': '', 'name': ''};
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email']!,
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email']!,
          _authData['name']!,
        );

        setState(() {
          _authMode = AuthMode.login;
        });
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        border: Border.all(color: const Color(0xFF221C35), width: 2),
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: _authMode == AuthMode.signup ? 290 : 200,
      constraints:
          BoxConstraints(minHeight: _authMode == AuthMode.signup ? 300 : 240),
      width: deviceSize.width * 0.75,
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _authMode == AuthMode.signup
                  ? TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Your Name',
                          labelStyle: TextStyle(color: Color(0xFF221C35)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Color(0xFF221C35)))),
                      validator: (value) {
                        if (value!.length < 4 ||
                            RegExp(r"[^a-z ]", caseSensitive: false)
                                .hasMatch(value)) {
                          return 'Invalid Name!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['name'] = value!.trim();
                      },
                    )
                  : Container(),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Enter Username',
                    labelStyle: TextStyle(color: Color(0xFF221C35)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF221C35)),
                    )),
                validator: _authMode == AuthMode.signup
                    ? (value) {
                        if (value!.length < 4) {
                          return 'Use at least 4 characters';
                        }
                        return null;
                      }
                    : null,
                onSaved: (value) {
                  _authData['email'] = value!.trim();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange.shade500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 10.0),
                  ),
                  child: Text(
                    _authMode == AuthMode.login ? 'LOGIN' : 'SIGN UP',
                    style:
                        const TextStyle(color: Color(0xFF221C35), fontSize: 17),
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  '${_authMode == AuthMode.login ? 'Signup' : 'Login'} Instead?',
                  style: const TextStyle(
                      color: Colors.blueAccent,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
