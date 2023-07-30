import 'package:clone_insta/pages/homePage.dart';
import 'package:clone_insta/pages/signUpPage.dart';
import 'package:clone_insta/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {

  static final String id= "login_page";
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  int? counta;
  bool isLoading = false;
  bool emailValid = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _callHomePage(){
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();

    if(email.isEmpty || password.isEmpty) return;
    setState(() {
      isLoading = true;
    });
    print("working1");
      AuthService.signInUser(email, password).then((value) => {
      _responseSignIn(value!),});
  }

  _responseSignIn(User firebaseUser){
    setState(() {
      isLoading = false;
    });
    print("working");
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _callSignUpPage(){
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _callHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                    ///Username
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
                            hintText: "example@gmail.com",
                            border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
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
                        decoration: InputDecoration(
                            hintText: "Password",
                            border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      child: MaterialButton(
                        color: Colors.blue,
                        onPressed: (){
                          _callHomePage();                        },
                        child: const Text("Log In",style: TextStyle(color: Colors.black),),
                      ),
                    ),
                    SizedBox(height: 15,),
                    ///dont have an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Have not an account ",style: TextStyle(color: Colors.grey,fontSize: 15),),
                        SizedBox(width: 10,),
                        GestureDetector(
                          onTap: (){
                            _callSignUpPage();
                          },
                          child: Text("Sign Up",style: TextStyle(color: Colors.blue,fontSize: 17,fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
                isLoading? Center(
                  child: CircularProgressIndicator(),
                ) : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
