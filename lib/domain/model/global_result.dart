import 'package:vocabulary_quiz/data/config.dart';


class GlobalResult {
  GlobalResult({
    this.errors = 0,
    this.failures = 0,
    this.successes = 0,
  });

  int errors;
  int failures;
  int successes;

  bool get mood => percentage > Config.percentageMoodBorder;

  int get percentage =>
      (successes*100) ~/ Config.quizWordsNum;

  void updateErrors(int _errors) {
    this.errors += _errors;
  }

  void incrementFailures() {
    this.failures++;
  }

  void incrementSuccesses() {
    this.successes++;
  }

  void clearAll() {
    this.errors = 0;
    this.failures = 0;
    this.successes = 0;
  }

  GlobalResult copyWith({
    int errors,
    int failures,
    int successes,
  }) => GlobalResult(
    errors: errors ?? this.errors,
    failures: failures ?? this.failures,
    successes: successes ?? this.successes,
  );
}
