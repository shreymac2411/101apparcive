import 'package:flutter/material.dart';
import 'package:lol_distributorsga_apps/Screens/login.dart';
import 'package:lol_distributorsga_apps/Screens/signup.dart';
import 'package:lol_distributorsga_apps/Screens/homepage.dart';
import 'package:lol_distributorsga_apps/Screens/shoppingCart.dart';
import 'package:flutter/services.dart';
import 'Screens/selectionPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((value) => runApp(lol_Distributor()));
}


class lol_Distributor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Urbanist'),
      debugShowCheckedModeBanner: false,
      initialRoute: SelectionScreen.id,
      routes: {
        SelectionScreen.id: (context) => SelectionScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        HomeScreen.id: (context) => HomeScreen('',''),
        ShoppingCart.id: (context) => ShoppingCart(),
      },
    );
  }
}