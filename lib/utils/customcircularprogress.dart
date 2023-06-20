import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double successPercentage;
  final double failedPercentage;

  const CustomCircularProgressIndicator({
    required this.successPercentage,
    required this.failedPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: 200 / 80,
            child: CircularProgressIndicator(
              value: successPercentage / 100,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              backgroundColor: Colors.green,
              strokeWidth: 10,
            ),
          ),
          Transform.scale(
            scale: 200 / 80,
            child: CircularProgressIndicator(
              value: failedPercentage / 100,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
              backgroundColor: Colors.transparent,
              strokeWidth: 10,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${successPercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const Text(
                  'Success',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
