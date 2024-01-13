import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/rounded_button.dart';
import 'login.dart';
import 'package:lol_distributorsga_apps/constants.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool showSpinner = false;
  bool checkedValue1 = false;
  bool checkedValue2 = false;
  String Name = '';

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
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
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
                                    fontSize: 26,
                                    fontFamily: 'Poppins',
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
                                //email = value;
                              },
                              decoration: kTextfeildDecoration.copyWith(
                                  filled: true,
                                  fillColor:
                                      const Color.fromRGBO(247, 247, 247, 1),
                                  hintText: 'Username',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF8390A1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextField(
                              obscureText: true,
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                //password = value;
                              },
                              decoration: kTextfeildDecoration.copyWith(
                                  filled: true,
                                  fillColor:
                                      const Color.fromRGBO(247, 247, 247, 1),
                                  hintText: 'Email',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF8390A1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                //email = value;
                              },
                              decoration: kTextfeildDecoration.copyWith(
                                  filled: true,
                                  fillColor:
                                      const Color.fromRGBO(247, 247, 247, 1),
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF8390A1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextField(
                              obscureText: true,
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                //password = value;
                              },
                              decoration: kTextfeildDecoration.copyWith(
                                  filled: true,
                                  fillColor:
                                      const Color.fromRGBO(247, 247, 247, 1),
                                  hintText: 'Confirm password',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF8390A1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8))),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromRGBO(250, 214, 27, 1)),
                                ),
                                child: const Text(
                                  "Register",
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
                                      color: const Color.fromRGBO(
                                          232, 236, 244, 1),
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
                                      color: const Color.fromRGBO(
                                          232, 236, 244, 1),
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
                                    text: 'Already have an account? ',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextSpan(
                                    text: 'Login Now',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(250, 214, 27, 1)),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, LoginScreen.id);
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
