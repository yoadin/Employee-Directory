class Weather {
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int weatherCode;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json["temperature_2m"],
      humidity: json["relative_humidity_2m"],
      windSpeed: json["wind_speed_10m"],
      weatherCode: json["weather_code"],
    );
  }
}