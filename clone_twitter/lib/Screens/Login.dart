import 'package:clone_twitter/Widgets/RoundedButton.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/logo.png",
          height: 40,
          width: 40,
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //top space
            SizedBox(
              height: 20,
            ),

            //email textfield
            TextField(
              decoration: InputDecoration(
                hintText: "Enter your username/email ",
              ),
              onChanged: (val) {
                email = val;
              },
            ),
            //space inbetween email and password
            SizedBox(
              height: 20,
            ),

            //password tectfield
            TextField(
              decoration: InputDecoration(
                hintText: "Enter your password ",
              ),
              obscureText: true,
              onChanged: (val) {
                password = val;
              },
            ),
//space between pasword and button
            SizedBox(
              height: 20,
            ),

            //submit button

            RoundedButton(btnText: "Login", onBtnPresses: loginBtn)
          ],
        ),
      ),
    );
  }

  loginBtn() {
    print(email + " " + password);
  }
}
