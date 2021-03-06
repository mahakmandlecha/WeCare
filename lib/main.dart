import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shehacks_team_055/screens/authentication.dart';
import 'package:shehacks_team_055/screens/homepage.dart';
import 'package:shehacks_team_055/screens/login_screen.dart';
import 'package:shehacks_team_055/screens/onboarding_screen.dart';
import 'package:shehacks_team_055/screens/register.dart';
import 'package:shehacks_team_055/screens/signup_screen.dart';
import 'package:shehacks_team_055/screens/slide.dart';

import 'screens/homepage.dart';
import 'screens/homepage.dart';
import 'screens/onboarding_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/onboarding_screen.dart';
//import 'package:app_onboarding/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth appAuth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Authentication(),
          )
        ],
        child: MaterialApp(
          title: 'SheHacks',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "GoogleSans",
            primarySwatch: Colors.amberAccent[600],
          ),
          home: OnboardingScreen(),
          routes: {
            SignupScreen.routeName: (ctx) => SignupScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            RegisterPage.routeName: (ctx) => RegisterPage(this.appAuth),
            HomePage.routeName: (ctx) => HomePage(),
            OnboardingScreen.routeName: (ctx) => OnboardingScreen(),
          },
        ));
  }
}
