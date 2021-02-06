import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import 'package:vocabulary_quiz/domain/bloc/vocabulary_bloc.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';


class VariantGridTile extends StatelessWidget {
  VariantGridTile({
    @required Word word,
    @required this.fromOriginal,
  })  : this._word = word,
        assert(word != null);

  final Word _word;
  final bool fromOriginal;
  VocabularyBloc vocabularyBloc;

  @override
  Widget build(BuildContext context) {
    vocabularyBloc = Provider.of<VocabularyBloc>(context);
    return GridTile(
      footer: Center(
        child: Text(
          fromOriginal
            ? _word.translateList.elementAt(0)
            : _word.word,
          style: TextStyle(height: 5, fontSize: 20),
        ),
      ),
      header: InkWell(
        onTap: () async {
          await vocabularyBloc?.checkVariant.add(_word);
        },
        child: Image.asset(_word.imagePath),
      ),
      child: Container(),
    );
  }
}
