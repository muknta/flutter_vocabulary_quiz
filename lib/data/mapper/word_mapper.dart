import 'package:meta/meta.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';


class WordMapper {
  static Map<String, dynamic> toJson(Word word) {
    return {
      'primary_key': word.primaryKey,
      'word': word.word,
      'translate_list': word.translateList,
      'image_path': word.imagePath,
      'is_passed': word.isPassed,
      'does_selected_once': word.doesSelectedOnce,
    };
  }

  static Word fromJson(Map<String, dynamic> json) =>
      Word(
        primaryKey: json['primary_key'],
        word: json['word'],
        translateList: json['translate_list'],
        imagePath: json['image_path'],
        isPassed: json['is_passed'],
        doesSelectedOnce: json['does_selected_once'],
      );
}
