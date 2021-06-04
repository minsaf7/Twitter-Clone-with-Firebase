import 'package:clone_twitter/Widgets/RoundedButton.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String firstName;
  late String lastName;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //top space
              SizedBox(
                height: 20,
              ),
//first name
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter your First name ",
                ),
                onChanged: (val) {
                  firstName = val;
                },
              ),
              SizedBox(
                height: 20,
              ),
//Last name
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter your Last name ",
                ),
                onChanged: (val) {
                  lastName = val;
                },
              ),
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

              RoundedButton(
                btnText: "Sign up",
                // onBtnPresses: () async {
                //   bool isValid = await AuthService.signUp(
                //       firstName, lastName, email, password);

                //   if (isValid) {
                //     Navigator.pop(context);
                //   } else {
                //     print("Something went wrong");
                //   }
                // },
                onBtnPresses: signUpBtn,
              )
            ],
          ),
        ),
      ),
    );
  }

  signUpBtn() {
    print("firdt" + firstName + " last" + lastName + " ema");
  }
}
