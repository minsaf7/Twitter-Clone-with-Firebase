import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onBtnPresses;

  const RoundedButton(
      {Key? key, required this.btnText, required this.onBtnPresses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Colors.blue,
      //color: Color(00bfff),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: MaterialButton(
          onPressed: onBtnPresses,
          minWidth: 300,
          height: 50,
          child: Text(btnText),
        ),
      ),
    );
  }
}
