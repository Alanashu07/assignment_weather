import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/Screens/login_screen.dart';
import 'package:weather_app/Styles/app_style.dart';
import 'package:weather_app/Widgets/custom_text_field.dart';
import 'package:weather_app/constants.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherFactory _weatherFactory = WeatherFactory(openWeatherAPI);
  late String location = 'Bangalore';
  final TextEditingController _locationController = TextEditingController();

  Weather? _weather;

  @override
  void initState() {
    _weatherFactory.currentWeatherByCityName(location).then((value) {
      setState(() {
        _weather = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: _weather == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                child: SizedBox(
                    width: mq.width,
                    height: mq.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: mq.height * .05,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: (){
                                showDialog(context: context, builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Set your location'),
                                    content: CustomTextField(controller: _locationController, obscureText: false, suffixIcon: const Icon(CupertinoIcons.location), label: 'Location', hint: 'Enter City Name', color: _weather!.temperature!.celsius! >= 30 ? AppStyle.mainColor : AppStyle.winterColor),
                                    actions: [
                                      TextButton(onPressed: (){
                                        setState(() {
                                          location = _locationController.text;
                                          _weatherFactory.currentWeatherByCityName(location).then((value) {
                                            setState(() {
                                              _weather = value;
                                            });
                                          });
                                        });
                                        Navigator.pop(context);
                                      }, child: const Text('Set')),
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: const Text('Cancel')),
                                    ],
                                  );
                                });
                              },
                              child: Text(
                                _weather?.areaName ?? '',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500, color: _weather!.temperature!.celsius! >= 30 ? AppStyle.mainColor : AppStyle.winterColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mq.height * .1,
                        ),
                        Text(
                          DateFormat('h:mm a').format(_weather!.date!),
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEEE').format(_weather!.date!),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "  ${DateFormat('d.m.y').format(_weather!.date!)}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: mq.height * .3,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(
                                'https://openweathermap.org/img/wn/${_weather!.weatherIcon}@4x.png'),
                          )),
                        ),
                        Text(
                          _weather?.weatherDescription ?? '',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: mq.width * .5,
                          child: Column(
                            children: [
                              Text(
                                '${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C',
                                style: const TextStyle(
                                    fontSize: 68, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      'Min : ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C'),
                                  Text(
                                      'Max : ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C')
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                    child: LoginScreen(
                      temperature: _weather!.temperature!.celsius!,
                    ),
                    type: PageTransitionType.leftToRightWithFade),
                (route) => false);
          },
          child: const Icon(Icons.logout)),
    );
  }
}
