import 'package:flutter/material.dart';
import '../bmi_calculator.dart';
import '../stopwatch_page.dart';
import '../web_browser.dart';
import '../brick_breaker.dart';
import '../sensor_pack.dart';
import '../piano.dart';

List<Map<String, dynamic>> mainButtonData = [
  {
    'buttonName': '비만 측정기',
    'buttonPage': const BMICalculator(),
    'buttonColor': Colors.red,
    'buttonTextColor': Colors.white,
    'buttonIcon': Icons.favorite,
  },
  {
    'buttonName': '스탑워치',
    'buttonPage': const StopwatchPage(),
    'buttonColor': Colors.orange,
    'buttonTextColor': Colors.white,
    'buttonIcon': Icons.timer,
  },
  {
    'buttonName': '웹 브라우저',
    'buttonPage': const WebView(),
    'buttonColor': Colors.yellow,
    'buttonTextColor': Colors.black,
    'buttonIcon': Icons.web,
  },
  {
    'buttonName': '벽돌 깨기',
    'buttonPage': const BrickBreakerGame(),
    'buttonColor': Colors.green,
    'buttonTextColor': Colors.white,
    'buttonIcon': Icons.gamepad,
  },
  {
    'buttonName': '모션 감지기',
    'buttonPage': const SensorPack(),
    'buttonColor': Colors.blue,
    'buttonTextColor': Colors.white,
    'buttonIcon': Icons.motion_photos_auto,
  },
  {
    'buttonName': '피아노',
    // 'buttonPage': null,
    'buttonPage': const PianoApp(),
    'buttonColor': Colors.purple,
    'buttonTextColor': Colors.white,
    'buttonIcon': Icons.sensors,
  },
];
