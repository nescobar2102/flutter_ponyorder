import 'package:flutter/material.dart';

class BtnRounded extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback callback;

  const BtnRounded(
      {required this.text, required this.color, required this.callback});

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Container(
      width: _size.width,
      height: 50.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0), color: color),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25.0),
          // splashColor: Color(0xff1E437A),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          onTap: callback,
        ),
      ),
    );
  }
}
