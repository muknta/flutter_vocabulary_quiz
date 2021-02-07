import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:vocabulary_quiz/data/config.dart';
import 'package:vocabulary_quiz/domain/model/global_result.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';


class ResultMessage extends StatelessWidget {
  const ResultMessage({
    @required this.globalResult,
  });

  final GlobalResult globalResult;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Center(
                child: Text("\nGlobal result:\n"
                  + "errors - ${globalResult.errors}\n"
                  + "invalid answers - ${globalResult.failures}\n"
                  + "valid answers - ${globalResult.successes}\n",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            globalResult.mood
              ? PositiveMessage(globalResult.percentage)
              : NegativeMessage(globalResult.percentage),
          ],
        ),
      ),
    );
  }
}


class PositiveMessage extends StatelessWidget {
  const PositiveMessage(this.percentage);

  final int percentage;

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

  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${percentage}%\nYou can better :)",
      style: TextStyle(fontSize: 20),
    );
  }
}
