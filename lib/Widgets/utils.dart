import 'package:flutter/material.dart';
import 'package:weather_app/Styles/app_style.dart';


void showSnackBar(BuildContext context, String text, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), backgroundColor: color));
}