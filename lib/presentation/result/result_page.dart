import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:vocabulary_quiz/internal/navigation/navigation.dart';
import 'package:vocabulary_quiz/internal/locator.dart';
import 'package:vocabulary_quiz/domain/model/vocabulary.dart';
import 'package:vocabulary_quiz/presentation/widgets/center_text_widget.dart';
import 'package:vocabulary_quiz/presentation/result/widgets/result_message.dart';
import 'package:vocabulary_quiz/presentation/home/home_page.dart';


class ResultPage extends StatelessWidget {
  const ResultPage({
    Key key,
    @required this.percentage,
  }) : super(key: key);

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Result"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _contentColumn(),
      ),
    );
  }

  Widget _contentColumn() {
    return Column(
      children: <Widget>[
        ResultMessage(
          percentage: percentage,
        ),
        _navigateToHomeButton(),
      ],
    );
  }

  Widget _navigateToHomeButton() {
    return ElevatedButton(
      onPressed: () {
        locator<NavigationService>().navigateTo(
            Routes.home);
      },
      child: Text("Move to home"),
    );
  }
}
