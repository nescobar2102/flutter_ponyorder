import 'package:flutter/material.dart';

class InputCallback extends StatefulWidget {
  final String hintText;
  final IconData iconCallback;
  final VoidCallback callback;

  const InputCallback(
      {required this.hintText,
      required this.iconCallback,
      required this.callback});

  @override
  _InputCallbackState createState() => _InputCallbackState();
}

class _InputCallbackState extends State<InputCallback> {
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
          decoration: InputDecoration(
            hintText: widget.hintText,
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.only(top: 20, bottom: 0, left: 15.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Color(0xff0f538d),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Color(0xffc7c7c7), width: 1.2),
            ),
            suffixIcon: GestureDetector(
              onTap: widget.callback,
              child: Padding(
                padding: const EdgeInsets.only(left: 17.0, right: 12.0),
                child: Icon(
                  widget.iconCallback,
                  color: focus ? Color(0xff0f538d) : Color(0xffc7c7c7),
                ),
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
