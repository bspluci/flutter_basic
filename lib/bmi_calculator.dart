import 'package:flutter/material.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비만 측정기'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextField('키(cm)', heightController),
              const SizedBox(height: 20),
              buildTextField('몸무게(kg)', weightController),
              const SizedBox(height: 20),
              buildButtonRow(),
              const SizedBox(height: 20),
              Text(
                result,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildElevatedButton('BMI 계산하기', calculateBMI),
        const SizedBox(width: 10),
        buildElevatedButton('초기화', resetValues),
      ],
    );
  }

  Widget buildElevatedButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: Text(label),
    );
  }

  void calculateBMI() {
    double height = double.tryParse(heightController.text) ?? 0.0;
    double weight = double.tryParse(weightController.text) ?? 0.0;

    if (height > 0 && weight > 0) {
      double bmi = weight / ((height / 100) * (height / 100));
      String bmiResult = 'BMI: ${bmi.toStringAsFixed(2)}\n';

      String interpretation = '';
      if (bmi < 18.5) {
        interpretation = '저체중입니다';
      } else if (bmi >= 18.5 && bmi < 24.9) {
        interpretation = '정상입니다';
      } else if (bmi >= 25 && bmi < 29.9) {
        interpretation = '과체중입니다';
      } else {
        interpretation = '비만입니다';
      }

      setState(() {
        result = '$bmiResult\n$interpretation';
      });
    } else {
      setState(() {
        result = '키와 몸무게를 입력해주세요';
      });
    }
  }

  void resetValues() {
    setState(() {
      heightController.text = '';
      weightController.text = '';
      result = '';
    });
  }
}
