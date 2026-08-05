import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/hourly_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService service = WeatherService();

  late Future<Weather> weather;

  @override
  void initState() {
    super.initState();
    weather = service.fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff111827),

      // Bottom Navigation (Static)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff1B1C31),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: "",
          ),
        ],
      ),

      body: FutureBuilder<Weather>(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;

          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff2B2E4A),
                  Color(0xff111827),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.menu, color: Colors.white),
                          Icon(Icons.calendar_today, color: Colors.white),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // City
                      const Text(
                        "Addis Ababa",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Weather Image
                      Image.asset(
                        "assets/images/cloud.jpg",
                        width: 170,
                        height: 170,
                      ),

                      const SizedBox(height: 15),

                      // Temperature
                      Text(
                        "${data.temperature}°C",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Description
                      Text(
                        getWeatherDescription(data.weatherCode),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 22,
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Weather Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Column(
                            children: [
                              const Icon(Icons.air, color: Colors.white),
                              const SizedBox(height: 5),
                              Text(
                                "${data.windSpeed} km/h",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),

                          Column(
                            children: [
                              const Icon(Icons.water_drop,
                                  color: Colors.white),
                              const SizedBox(height: 5),
                              Text(
                                "${data.humidity}%",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),

                          const Column(
                            children: [
                              Icon(Icons.wb_sunny, color: Colors.white),
                              SizedBox(height: 5),
                              Text(
                                "8 hr",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Hourly Forecast",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 150,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: const [

                            HourlyCard(
                              time: "Now",
                              temperature: "21°",
                              image: "assets/images/cloud.jpg",
                            ),

                            HourlyCard(
                              time: "15 min",
                              temperature: "21°",
                              image: "assets/images/cloud.jpg",
                            ),

                            HourlyCard(
                              time: "30 min",
                              temperature: "22°",
                              image: "assets/images/cloud.jpg",
                            ),

                            HourlyCard(
                              time: "45 min",
                              temperature: "22°",
                              image: "assets/images/cloud.jpg",
                            ),

                            HourlyCard(
                              time: "60 min",
                              temperature: "23°",
                              image: "assets/images/cloud.jpg",
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String getWeatherDescription(int code) {
    if (code == 0) {
      return "Clear Sky";
    } else if (code >= 1 && code <= 3) {
      return "Cloudy";
    } else if (code >= 51) {
      return "Rainy";
    } else {
      return "Unknown";
    }
  }
}