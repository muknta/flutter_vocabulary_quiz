import 'package:flutter/material.dart';

import 'package:vocabulary_quiz/presentation/home/home_page.dart';
import 'package:vocabulary_quiz/presentation/quiz/quiz_page.dart';
import 'package:vocabulary_quiz/presentation/result/result_page.dart';


class Routes {
  static const String home = '/';
  static const String quiz = '/quiz';
  static const String result = '/result';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return Routes.getPageRoute(
          routeName: settings.name,
          viewToShow: HomePage(),
        );
      case Routes.quiz: {
        final dynamic args = settings.arguments;
        return Routes.getPageRoute(
          routeName: settings.name,
          viewToShow: QuizPage(
            vocabulary: args["vocabulary"],
          ),
        );
      }
      case Routes.result: {
        final dynamic args = settings.arguments;
        return Routes.getPageRoute(
          routeName: settings.name,
          viewToShow: ResultPage(
            globalResult: args["global_result"],
            percentage: args["percentage"],
          ),
        );
      }
      default:
        return MaterialPageRoute(
          builder: (_) =>
              Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}')
                ),
              ),
        );
    }
  }

  static PageRoute getPageRoute({
    String routeName,
    Widget viewToShow,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow,
    );
  }
}
