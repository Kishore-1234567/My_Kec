import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Progress extends StatelessWidget {
  const Progress({
    Key? key,
    required this.totalScore,
    required this.divisor,
  }) : super(key: key);

  final int totalScore;
  final int divisor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircularPercentIndicator(
          radius: 50,
          percent: totalScore > divisor ? 1 : totalScore / divisor,
          center: Text(
            '$totalScore',
            style: const TextStyle(fontSize: 40),
          ),
          animation: true,
          progressColor: Colors.green,
          backgroundColor: const Color.fromARGB(255, 223, 212, 212),
          circularStrokeCap: CircularStrokeCap.round,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Max Score : $divisor'),
            Text(
                'Needed points : ${(divisor - totalScore) < 0 ? 0 : divisor - totalScore}'),
          ],
        ),
      ],
    );
  }
}
