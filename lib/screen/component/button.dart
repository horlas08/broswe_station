import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final void Function()? press;
  final String text;
  final Widget? prefixIcon;
  const Button(
      {super.key, this.press, required this.text, this.prefixIcon = null});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText(
            text,
            maxLines: 1,
            style: const TextStyle(
              // color: Colors.white,
              fontSize: 20,
            ),
          ),
          if (prefixIcon != null) prefixIcon!
        ],
      ),
    );
  }
}
