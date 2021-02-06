import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:vocabulary_quiz/domain/model/word.dart';


class ResultMessage extends StatelessWidget {
  ResultMessage({
    @required this.globalResult,
    @required this.percentage,
  });

  final Map<String, dynamic> globalResult;
  final double percentage;
  bool isPositive;

  /// Constants
  final double percentageMoodBorder = 60;

  @override
  Widget build(BuildContext context) {
    isPositive = _getMood();
    return Expanded(
      child: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Center(
                child: Text("\nGlobal result:\n"
                  + "failures - ${globalResult['failures']}\n"
                  + "errors - ${globalResult['errors']}\n"
                  + "successes - ${globalResult['successes']}\n",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            isPositive
              ? PositiveMessage(percentage)
              : NegativeMessage(percentage),
          ],
        ),
      ),
    );
  }

  bool _getMood() {
    return percentage > percentageMoodBorder
      ? true
      : false;
  }
}


class PositiveMessage extends StatelessWidget {
  const PositiveMessage(this.percentage);

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${percentage}%\nCongrats!\nGood result.",
      style: TextStyle(fontSize: 20),
    );
  }
}

class NegativeMessage extends StatelessWidget {
  const NegativeMessage(this.percentage);

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${percentage}%\nYou can better :)",
      style: TextStyle(fontSize: 20),
    );
  }
}
