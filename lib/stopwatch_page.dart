import 'package:flutter/material.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({Key? key}) : super(key: key);

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  List<String> lapTimes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스탑워치'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              formatTime(_stopwatch.elapsedMilliseconds),
              style: const TextStyle(fontSize: 40.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  if (_stopwatch.isRunning) {
                    _stopwatch.stop();
                  } else {
                    _stopwatch.start();
                    startTimer();
                  }
                },
                child: Row(
                  children: [
                    Icon(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow),
                    Text(_stopwatch.isRunning ? '정지' : '시작'),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  if (_stopwatch.isRunning) {
                    recordLapTime();
                  }
                },
                child: const Text('레코드'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  resetStopwatch();
                },
                child: const Text('초기화'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: lapTimes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 0.0),
                  title: Center(
                      child: Text('기록 ${index + 1} - ${lapTimes[index]}',
                          style: const TextStyle(fontSize: 20.0))),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void startTimer() {
    Future.delayed(const Duration(milliseconds: 10), () {
      if (_stopwatch.isRunning) {
        setState(() {});
        startTimer();
      }
    });
  }

  void recordLapTime() {
    setState(() {
      lapTimes.insert(0, formatTime(_stopwatch.elapsedMilliseconds));
    });
  }

  void resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      lapTimes.clear();
    });
  }

  String formatTime(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr.$hundredsStr';
  }
}
