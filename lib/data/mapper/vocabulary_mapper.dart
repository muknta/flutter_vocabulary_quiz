import 'package:vocabulary_quiz/domain/model/vocabulary.dart';


class VocabularyMapper {
  static Map<String, dynamic> toJson(Vocabulary vocabulary) {
    return {
      'word_list': vocabulary.wordList,
    };
  }

  static Vocabulary fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      wordList: json['word_list'],
    );
  }
}
