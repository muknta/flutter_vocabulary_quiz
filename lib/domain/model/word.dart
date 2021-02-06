import 'package:meta/meta.dart';


class Word {
  Word({
    @required this.word,
    @required this.translateList,
    this.imagePath,
    this.isPassed = false,
    this.doesSelectedOnce = false,
  });

  int primaryKey;
  final String word;
  final List<dynamic> translateList;
  final String imagePath;
  final bool isPassed;
  final bool doesSelectedOnce;

  Word copyWith({
    String word,
    List<dynamic> translateList,
    String imagePath,
    bool isPassed,
    bool doesSelectedOnce,
  }) {
    return Word(
      word: word ?? this.word,
      translateList: translateList ?? this.translateList,
      imagePath: imagePath ?? this.imagePath,
      isPassed: isPassed ?? this.isPassed,
      doesSelectedOnce: doesSelectedOnce ?? this.doesSelectedOnce,
    );
  }
}
