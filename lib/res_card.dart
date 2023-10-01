import 'package:flutter/material.dart';

class MyResultCard extends StatefulWidget {
  const MyResultCard({super.key, required this.words});

  final Map<String, double> words;

  @override
  State<MyResultCard> createState() => _MyResultCardState();
}

class _MyResultCardState extends State<MyResultCard> {
  final Map<String, double> wordMap = {
    'Today': 0.2,
    'is': 0.32,
    'a': 0,
    'beautiful': 0.85,
    'day': 0.12,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: wordMap.keys.map((word) {
          var value = wordMap[word];
          var color = value! < 0.8 ? Colors.green : Colors.red;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20, color: color),
                children: [
                  TextSpan(
                      text: word,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
