import 'package:clone_insta/pages/homePage.dart';
import 'package:clone_insta/pages/login_gape.dart';
import 'package:clone_insta/services/auth_service.dart';
import 'package:clone_insta/services/db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/member_model.dart';
class SignUpPage extends StatefulWidget {
  static final String id = "signup_page";
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  bool isLoading = false;
  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cpasswordController = TextEditingController();

  _doSignUp() async {
    String fullname = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String cpassword = cpasswordController.text.toString().trim();

    if (fullname.isEmpty || email.isEmpty || password.isEmpty ||
        cpassword.isEmpty) return;

    if (cpassword != password) return;

    setState(() {
      isLoading = true;
    });

   var response = AuthService.signUpUser(fullname, email, password);
   Member member = Member(fullname, email);
   DBService.storeMember(member).then((value) => {
     _storeMemberToDB(member),
   });
  }

   void _storeMemberToDB(Member member){
      setState(() {
        isLoading= false;
      });
      Navigator.pushReplacementNamed(context, HomePage.id);
    }

    _callSignInPage(){
    Navigator.pushReplacementNamed(context, LogInPage.id);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Stack(
            children: [
              Container(padding: EdgeInsets.only(left: 10,right: 10),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
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
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Instagram",style: TextStyle(fontSize: 30,fontFamily: "BIllabong"),),
                        SizedBox(height: 30,),
                        //fullname
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10,),
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2,color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: fullnameController,
                            decoration: InputDecoration(
                                hintText: "Fullname",
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        //Email
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10,),
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2,color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                                hintText: "Email",
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        ///Password
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2,color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Password",

                                border: InputBorder.none
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 10,right: 10),
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2,color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            controller: cpasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Confirm Password",
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        GestureDetector(
                          child: MaterialButton(
                            color: Colors.blue,
                            onPressed: (){
                              _doSignUp();
                            },
                            child: Text("Sign Up",style: TextStyle(color: Colors.black),),
                          ),
                        ),
                        SizedBox(height: 10,),
                        ///dont have an account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Have not an account ",style: TextStyle(color: Colors.grey,fontSize: 15),),
                            SizedBox(width: 10,),
                            GestureDetector(
                              onTap: (){
                                _callSignInPage();
                              },
                              child: Text("Sign In",style: TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                    isLoading? Center(
                      child: CircularProgressIndicator(),
                    ): SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
