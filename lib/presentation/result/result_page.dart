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
    @required this.globalResult,
    @required this.percentage,
  }) : super(key: key);

  final Map<String, dynamic> globalResult;
  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Result"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _contentColumn(context),
      ),
    );
  }

  Widget _contentColumn(context) {
    return Column(
      children: <Widget>[
        ResultMessage(
          globalResult: globalResult,
          percentage: percentage,
        ),
        _navigateToHomeButton(context),
      ],
    );
  }

  Widget _navigateToHomeButton(context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 100),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          // locator<NavigationService>().navigateTo(
          //     Routes.home);
        },
        child: Text("Move to home"),
      ),
    );
  }
}
