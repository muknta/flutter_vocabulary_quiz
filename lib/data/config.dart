class Config {
  /// DB
  static const String sembastDBName = 'vocabulary.db';
  static const String wordFolderName = "words";
  static const String settingsRecordName = "settings";
  /// DB settings
  static const String fromOriginalTitle = "fromOriginal";
  static const bool defaultFromOriginalValue = true;

  /// assets
  static const String defaultImageLocalPath =
      'assets/cat_and_flower.png';

  /// constants from task description
  static const double percentageMoodBorder = 60;
  static const int quizWordsNum = 5;
  static const int quizVariantsNum = 4;
  static const int variantsInRow = 2;
  /// Taps on variants of the same screen
  static const int maxAttemptsNum = 2;
  static const int millisecondsDelayed = 300;
}
