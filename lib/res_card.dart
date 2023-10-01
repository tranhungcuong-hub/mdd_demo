import 'package:flutter/material.dart';

class MyResultCard extends StatefulWidget {
  const MyResultCard({super.key, required this.words, required this.text});

  final Map<String, double> words;
  final String text;

  @override
  State<MyResultCard> createState() => _MyResultCardState();
}

class _MyResultCardState extends State<MyResultCard> {
  final Map<String, double> res = {
    'Today': 0.2,
    'a': 0,
    'beautiful': 0.85,
    'day': 0.12,
    'is': 0.32,
  };

  @override
  Widget build(BuildContext context) {
    String text = 'Today is a beautiful day';

    List<Widget> wordWidgets = text.split(' ').map((word) {
      double score = widget.words[word] ??
          1.0; // If the word is not found, set the default score to 1.0
      Color textColor = score < 0.8 ? Colors.green : Colors.red;

      return Text(
        '$word ',
        style: TextStyle(color: textColor, fontSize: 20),
      );
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: wordWidgets,
    );
  }
}
