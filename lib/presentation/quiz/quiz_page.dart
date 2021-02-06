import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import 'package:vocabulary_quiz/internal/navigation/navigation.dart';
import 'package:vocabulary_quiz/internal/locator.dart';
import 'package:vocabulary_quiz/data/config.dart';
import 'package:vocabulary_quiz/domain/model/vocabulary.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';
import 'package:vocabulary_quiz/domain/bloc/vocabulary_bloc.dart';
import 'package:vocabulary_quiz/presentation/widgets/center_text_widget.dart';
import 'package:vocabulary_quiz/presentation/quiz/widgets/variant_grid_tile.dart';
import 'package:vocabulary_quiz/presentation/result/result_page.dart';


class QuizPage extends StatelessWidget {
  QuizPage({
    Key key,
    @required this.vocabulary
  }) : super(key: key);

  Vocabulary vocabulary;
  VocabularyBloc vocabularyBloc;
  Word _currWord;
  List<Word> _variants = [];
  // int _currWordNum = 1;

  @override
  Widget build(BuildContext context) {
    vocabularyBloc = Provider.of<VocabularyBloc>(context);

    return StreamBuilder<Word>(
      stream: vocabularyBloc?.quizWordStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _currWord = snapshot.data;
        }
        return _scaffold();
      },
    );
  }

  Widget _scaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quiz Word (${vocabularyBloc?.currQuizWordNum}/${Config.quizWordsNum})",
        ),
        actions: <Widget>[
          
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _variantsStream(),
      ),
    );
  }

  Widget _variantsStream() {
    return StreamBuilder<List<Word>>(
      stream: vocabularyBloc?.variantsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _variants = snapshot.data;
        }
        if (_variants.isEmpty) {
          return CenterTextWidget(
            message: "There is no variants",
          );
        }
        return _contentColumn();
      },
    );
  }

  Widget _contentColumn() {
    return Column(
      children: <Widget>[
        CenterTextWidget(message: "Quiz Page"),
        _generateVariantList(),
        vocabularyBloc.currQuizWordNum < Config.quizWordsNum
          ? _nextButton()
          : _getResultButton(),
      ],
    );
  }

  Widget _generateVariantList() {
    return GridView.builder(
      itemCount: _variants?.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Config.variantsInRow,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: VariantGridTile(
            word: _variants[index],
            isOriginal: true, // TODO: get from bloc
          ),
        );
      },
    );
  }

  Widget _nextButton() {
    return ElevatedButton(
      onPressed: () {

      },
      child: Text("Next"),
    );
  }

  Widget _getResultButton() {
    final double _percentage = vocabularyBloc?.calculateResult();

    return ElevatedButton(
      onPressed: () {
        locator<NavigationService>().navigateTo(
          Routes.result,
          arguments: {
            'percentage': _percentage,
          },
        );
      },
      child: Text("Get result"),
    );
  }
}
