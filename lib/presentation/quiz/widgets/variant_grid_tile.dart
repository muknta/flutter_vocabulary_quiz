import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:vocabulary_quiz/domain/model/word.dart';


class VariantGridTile extends StatelessWidget {
  const VariantGridTile({
    @required Word word,
    @required this.isOriginal,
  })  : this._word = word,
        assert(word != null);

  final Word _word;
  final bool isOriginal;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Text(
        isOriginal
          ? _word.word
          : _word.translateList[0],
      ),
    );
  }
}
