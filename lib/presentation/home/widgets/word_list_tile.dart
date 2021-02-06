import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:vocabulary_quiz/domain/model/word.dart';


class WordListTile extends StatelessWidget {
  const WordListTile({
    @required Word word,
  })  : this._word = word,
        assert(word != null);

  final Word _word;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration (
        color: _word.isPassed && _word.doesSelectedOnce
          ? Colors.green
          : !_word.isPassed && _word.doesSelectedOnce
            ? Colors.red
            : Colors.white,
      ),
      child: ListTile(
        leading: Image.asset(_word.imagePath),
        title: _buildTitle(),
        trailing: Icon(Icons.volume_up),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: <Widget>[
        Text(_word.word),
        Column(
          children: _getTextTranslates(),
        ),
      ],
    );
  }

  List<Widget> _getTextTranslates() {
    return _word.translateList?.map((transl) =>
        _translateText(transl))?.toList() ?? [];
  }

  Widget _translateText(String _translate) {
    return Text(
      _translate,
      style: TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.black.withOpacity(0.5),
      ),
    );
  }
}
