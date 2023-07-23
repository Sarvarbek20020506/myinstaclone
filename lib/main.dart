import 'package:clone_insta/pages/homePage.dart';
import 'package:clone_insta/pages/login_gape.dart';
import 'package:clone_insta/pages/signUpPage.dart';
import 'package:clone_insta/pages/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashPage(),
      routes: {
        HomePage.id : (context) => HomePage(),
        SplashPage.id : (context) => SplashPage(),
        SignUpPage.id : (context) => SignUpPage(),
        LogInPage.id : (context) => LogInPage(),
      },
    );
  }
}

