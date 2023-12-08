import 'package:flutter/material.dart';

import 'styleData/main_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int btnRowCount = 2; // 한 행에 표시할 버튼의 개수
    int btnColCount = 3; // 한 열에 표시할 버튼의 개수
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / btnColCount;
    final double itemWidth = size.width / btnRowCount;
    final double childAspectRatio = itemWidth / itemHeight;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Flutter App', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: btnRowCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          itemCount: mainButtonData.length,
          itemBuilder: (context, idx) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: mainButtonData[idx]['buttonColor'],
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => mainButtonData[idx]['buttonPage']),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(mainButtonData[idx]['buttonIcon'],
                      color: mainButtonData[idx]['buttonTextColor']),
                  Text(mainButtonData[idx]['buttonName'],
                      style: TextStyle(
                          color: mainButtonData[idx]['buttonTextColor'])),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
