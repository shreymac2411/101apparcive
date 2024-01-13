import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'homepage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:lol_distributorsga_apps/constants.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

String accessTok = '';
String refreshTok = '';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<bool> login(String email, String password) async {
    try {
      http.Response response = await http.post(
          Uri.parse('https://dev.salesgent.xyz/api/authenticate'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{
            "username": email,
            "password": password,
            "type": "customer"
          }));
      print(email);
      print(password);
      print("Status code is");
      print(response.statusCode);
      if (response.statusCode == 200) {
        var temp = jsonDecode(response.body);
        accessTok = temp['result']['access'];
        refreshTok = temp['result']['refresh'];
        resData = jsonDecode(response.body.toString());
        print(resData);
        return true;
      } else {
        print('failed');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  var resData;
  bool showSpinner = false;
  String email = '';
  String password = '';
  bool checkedValue = false;

  void showFlashError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.deepOrange,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: RadialGradient(colors: [
              Color.fromRGBO(211, 35, 14, 1),
              Color.fromRGBO(123, 18, 5, 1)
            ]),
          ),
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Welcome back!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                            const SizedBox(
                              height: 7,
                            ),
                            const Text('Glad to see you, Again!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            const SizedBox(
                              height: 25,
                            ),
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: kTextfeildDecoration.copyWith(
                                filled: true,
                                fillColor: const Color.fromRGBO(247, 247, 247, 1),
                                hintText: 'Enter your email',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF8390A1),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                )
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextField(
                              obscureText: true,
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                password = value;
                              },
                              decoration: kTextfeildDecoration.copyWith(
                                  filled: true,
                                  fillColor:
                                      const Color.fromRGBO(247, 247, 247, 1),
                                  hintText: 'Enter your password',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF8390A1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  suffixIcon: const Icon(
                                      FluentIcons.eye_20_regular)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('Forget Password?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                  login(email, password).then((value) {
                                    if (value == true) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                  accessTok, refreshTok)));
                                    } else {
                                      print('try again');
                                      showFlashError(context,
                                          'An error occurred. Please try again.');
                                    }
                                  });
                                  setState(() {
                                    showSpinner = false;
                                  });
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromRGBO(250, 214, 27, 1)),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Container(
                                      height: 1,
                                      color:
                                          const Color.fromRGBO(232, 236, 244, 1),
                                    ),
                                  ),
                                ),
                                const Text(
                                  'Or',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Container(
                                      height: 1,
                                      color:
                                          const Color.fromRGBO(232, 236, 244, 1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Don’t have an account? ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: 'Register Now',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(250, 214, 27, 1)),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, SignupScreen.id);
                                      },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
