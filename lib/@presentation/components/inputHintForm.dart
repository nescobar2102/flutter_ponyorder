import 'package:flutter/material.dart';

class InputHintForm extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final IconData iconCallback;

  const InputHintForm(
      {required this.hintText, required this.icon, required this.iconCallback});

  @override
  _InputHintFormState createState() => _InputHintFormState();
}

class _InputHintFormState extends State<InputHintForm> {
  bool focus = false;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Focus(
        onFocusChange: (e) {
          setState(() {
            focus = e;
          });
        },
        child: TextField(
          // controller: user,
          obscureText: true,
          decoration: InputDecoration(
            hintText: widget.hintText,
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.only(top: 20, bottom: 0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Color(0xffc7c7c7), width: 1.2),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 17.0, right: 12.0),
              child: Icon(
                widget.icon,
                color: focus ? Color(0xff0090ce) : Color(0xffc7c7c7),
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 15.0),
              child: Icon(
                widget.iconCallback,
                color: focus ? Color(0xff0090ce) : Color(0xffc7c7c7),
              ),
            ),
            hintStyle: TextStyle(fontSize: 16.0, color: Color(0xffc7c7c7)),
            labelStyle: TextStyle(
                fontFamily: 'Roboto', fontSize: 15, color: Colors.black),
            alignLabelWithHint: true,
          ),
        ),
      ),
    );
  }
}
