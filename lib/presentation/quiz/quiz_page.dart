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
  bool _fromOriginal = true;
  // int _currWordNum = 1;

  @override
  Widget build(BuildContext context) {
    vocabularyBloc = Provider.of<VocabularyBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await vocabularyBloc.onStartQuiz();
    });

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
        return StreamBuilder<bool>(
          stream: vocabularyBloc?.fromOriginalStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _fromOriginal = snapshot.data;
            }
            return _contentColumn();
          },
        );
      },
    );
  }

  Widget _contentColumn() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(35),
          child: Text(
            _fromOriginal
              ? _currWord?.word
              : _currWord?.translateList.elementAt(0),
            style: TextStyle(fontSize: 30),
          ),
        ),
        _generateVariantList(),
        // vocabularyBloc.currQuizWordNum < Config.quizWordsNum
        //   ? _nextButton()
        //   : _getResultButton(),
      ],
    );
  }

  Widget _generateVariantList() {
    return Expanded(
      child: GridView.builder(
        itemCount: _variants?.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Config.variantsInRow,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: VariantGridTile(
              word: _variants.elementAt(index),
              fromOriginal: _fromOriginal,
            ),
          );
        },
      ),
    );
  }

  // Widget _nextButton() {
  //   return ElevatedButton(
  //     onPressed: () {

  //     },
  //     child: Text("Next"),
  //   );
  // }

  // Widget _getResultButton() {
  //   final double _percentage = vocabularyBloc?.calculateResult();

  //   return ElevatedButton(
  //     onPressed: () {
  //       locator<NavigationService>().navigateTo(
  //         Routes.result,
  //         arguments: {
  //           'percentage': _percentage,
  //         },
  //       );
  //     },
  //     child: Text("Get result"),
  //   );
  // }
}
