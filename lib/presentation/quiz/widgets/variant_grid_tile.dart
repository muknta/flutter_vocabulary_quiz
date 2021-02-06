import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import 'package:vocabulary_quiz/domain/bloc/vocabulary_bloc.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';


class VariantGridTile extends StatelessWidget {
  VariantGridTile({
    Key key,
    @required Word word,
    @required this.fromOriginal,
  })  : assert(word != null),
        this._word = word,
        super(key: key);

  final Word _word;
  final bool fromOriginal;
  bool _variantResult;
  bool _tapped = false;
  VocabularyBloc vocabularyBloc;

  @override
  Widget build(BuildContext context) {
    vocabularyBloc = Provider.of<VocabularyBloc>(context);
    return StreamBuilder<bool>(
      stream: vocabularyBloc?.variantResultStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && _tapped) {
          _variantResult = snapshot.data;
        }
        _tapped = false;
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 5.0,
              color: _variantResult == null
                ? Colors.white
                : _variantResult
                  ? Colors.green
                  : Colors.red
            ),
          ),
          child: InkWell(
            onTap: () async {
              _tapped = true;
              await vocabularyBloc?.checkVariant.add(_word);
            },
            child: GridTile(
              footer: Center(
                child: Text(
                  fromOriginal
                    ? _word.translateList.elementAt(0)
                    : _word.word,
                  style: TextStyle(height: 5, fontSize: 20),
                ),
              ),
              child: Container(),
              header: Image.asset(_word.imagePath),
            ),
          ),
        );
      },
    );
  }
}
