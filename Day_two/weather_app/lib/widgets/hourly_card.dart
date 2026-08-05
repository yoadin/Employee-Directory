import 'package:flutter/material.dart';

class HourlyCard extends StatelessWidget {
  final String time;
  final String temperature;
  final String image;

  const HourlyCard({
    super.key,
    required this.time,
    required this.temperature,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),

          Image.asset(
            image,
            width: 40,
          ),

          Text(
            temperature,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}