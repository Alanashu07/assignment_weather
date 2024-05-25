import 'package:flutter/material.dart';
import 'package:weather_app/Styles/app_style.dart';

class CustomButton extends StatelessWidget {
  final double? height;
  final double? width;
  final VoidCallback onPressed;
  final Widget child;
  final Color startColor;
  final Color endColor;

  const CustomButton(
      {super.key,
      this.height = 50,
      this.width = double.infinity,
      required this.onPressed,
      required this.child,
      required this.startColor,
      required this.endColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [startColor, endColor],
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5)
              ]),
          alignment: Alignment.center,
          child: child,
        ));
  }
}
