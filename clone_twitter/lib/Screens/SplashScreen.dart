import 'package:clone_twitter/Screens/Login.dart';
import 'package:clone_twitter/Screens/SignUp.dart';
import 'package:clone_twitter/Widgets/RoundedButton.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    // width: 30.0,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Image.asset(
                    'assets/logo.png',
                    height: 200,
                    width: 200,
                  ),
                  Text(
                    "Minsaf's twitter clone",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
                child:
                    RoundedButton(btnText: "Login", onBtnPresses: loginButton),
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: RoundedButton(
                    btnText: "Sign Up", onBtnPresses: signUpButton),
              ),
              SizedBox(
                height: 250.0,
              ),
              Container(
                // margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Minsaf's Twitter clone ©",
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  loginButton() {
    print("object");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  signUpButton() {
    print("object");
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }
}
