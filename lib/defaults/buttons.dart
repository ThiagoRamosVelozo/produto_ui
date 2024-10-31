import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final LinearGradient gradient;

  const GradientButton(
      {required this.onPressed,
      required this.text,
      required this.gradient,
      super.key});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
              gradient: gradient, borderRadius: BorderRadius.circular(5)),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
}
