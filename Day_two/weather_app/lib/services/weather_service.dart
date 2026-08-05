import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {

  Future<Weather> fetchWeather() async {

    final url = Uri.parse(
      "https://api.open-meteo.com/v1/forecast?latitude=8.9806&longitude=38.7578&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m,wind_direction_10m"
    );

    final response = await http.get(url);

    if(response.statusCode == 200){

      final data = jsonDecode(response.body);

      return Weather.fromJson(data["current"]);

    }else{

      throw Exception("Failed to load weather");

    }

  }

}