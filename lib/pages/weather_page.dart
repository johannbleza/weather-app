import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Weather? _weather;
  var _now;

  void _fetchWeather() async {
    final weather = await WeatherService();
    try {
      setState(() {
        _weather = weather;
      });
      _now = DateTime.now();
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  String getWeatherAnimation(String mainCondition) {
    final description = mainCondition.toLowerCase();
    if (description.contains('rain') || description.contains('drizzle')) {
      return 'assets/rainy.json';
    } else if (description.contains('clouds')) {
      return 'assets/cloudy.json';
    } else if (description.contains('thunderstorm')) {
      return 'assets/thunder.json';
    } else {
      return 'assets/sunny.json';
    }
  }

  String checkSuspension(String mainCondition) {
    final description = mainCondition.toLowerCase();
    if (description.contains('heavy') || description.contains('extreme')) {
      return 'Suspended';
    } else {
      return 'No announcements ️';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "How's the weather pare?",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '${_weather?.temperature.round()}°C',
              style: const TextStyle(fontSize: 48),
            ),
            Lottie.asset(getWeatherAnimation(
                _weather?.mainCondition ?? "assets/sunny.json")),
            Text(
              _weather?.mainCondition ?? "",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              "De La Salle University – Dasmariñas",
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Last updated:',
              style: TextStyle(color: Colors.black38),
            ),
            Text(
              _now.toString().substring(0, 19),
              style: const TextStyle(color: Colors.black38),
            ),
            InkWell(
                onTap: () {
                  _fetchWeather();
                },
                child: const Text(
                  "Refresh",
                  style: TextStyle(
                      color: Colors.black54,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.black54),
                )),
            const SizedBox(
              height: 36,
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 240,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.announcement_outlined,
                                size: 44,
                              ),
                              Text(
                                checkSuspension(_weather?.mainCondition ?? ""),
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                child: const Text(
                                  "DLSUD University Student Government",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                                onTap: () async {
                                  await launchUrl(Uri.parse(
                                      "https://www.facebook.com/usg.dlsud"));
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                child: const Text(
                                  "Governor Jonvic Remulla",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                                onTap: () async {
                                  await launchUrl(Uri.parse(
                                      "https://www.facebook.com/JonvicRemullaJr"));
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: const Text(
                "Suspended?",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("// Johann.dev"),
          ],
        ),
      ),
    );
  }
}
