import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/Screens/login_screen.dart';
import 'package:weather_app/Styles/app_style.dart';
import 'package:weather_app/firebase_options.dart';

import 'constants.dart';

late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initFirebase();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final WeatherFactory _weatherFactory = WeatherFactory(openWeatherAPI);

  Weather? _weather;


  @override
  void initState() {
    _weatherFactory.currentWeatherByCityName('Trivandrum').then((value) {
      setState(() {
        _weather = value;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final temperature = _weather?.temperature?.celsius;
    return _weather == null ? const Center(child: CircularProgressIndicator(color: Colors.deepOrange,),) : MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: temperature! >= 30 ? Colors.deepOrange : CupertinoColors.systemBlue),
        appBarTheme: AppBarTheme(backgroundColor: temperature >= 30 ? AppStyle.mainColor : AppStyle.winterColor),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: LoginScreen(temperature: temperature,),
    );
  }
}


_initFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
}