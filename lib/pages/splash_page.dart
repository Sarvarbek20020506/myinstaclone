import 'dart:async';

import 'package:clone_insta/pages/login_gape.dart';
import 'package:clone_insta/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';
class SplashPage extends StatefulWidget {
  static final String id = "splash_page";
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
   bool isLoggingIn = false;
  _callNextPage(){
    Timer(Duration(seconds:3),(){
      if (AuthService.isLoggedin()) {
        Navigator.pushReplacementNamed(context, HomePage.id);
      }
      else{
        Navigator.pushReplacementNamed(context, LogInPage.id);
      }
    }
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _callNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(193, 53, 132,1),
              Color.fromRGBO(245, 96, 64,1),
            ]
          )
        ),
        child: Column(
          children: [
            Expanded(child:
            Container(
              height: 100,
              width: 100,
              child: Center(
                child: Image(image: AssetImage("assets/images/logoinsta.png"),
                ),
              ),
            ),),
            Text("All servise reserved"),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
