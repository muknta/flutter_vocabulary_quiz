import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vocabulary_quiz/internal/navigation/navigation.dart';
import 'package:vocabulary_quiz/internal/locator.dart';
import 'package:vocabulary_quiz/data/config.dart';
import 'package:vocabulary_quiz/domain/model/word.dart';
import 'package:vocabulary_quiz/domain/model/vocabulary.dart';
import 'package:vocabulary_quiz/domain/bloc/vocabulary_bloc.dart';
import 'package:vocabulary_quiz/presentation/widgets/toast_widget.dart';
import 'package:vocabulary_quiz/presentation/widgets/center_text_widget.dart';
import 'package:vocabulary_quiz/presentation/widgets/dialog_widget.dart';
import 'package:vocabulary_quiz/presentation/home/widgets/word_list_tile.dart';
import 'package:vocabulary_quiz/presentation/quiz/quiz_page.dart';


class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  VocabularyBloc vocabularyBloc;
  Vocabulary _vocabulary;
  bool _fromOriginal = Config.defaultFromOriginalValue;
  final List<String> _fromOriginalList = ['from eng', 'from rus'];

  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _translateController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    vocabularyBloc = Provider.of<VocabularyBloc>(context);
    return StreamBuilder<bool>(
      stream: vocabularyBloc?.fromOriginalStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('snapshot _fromOriginal $snapshot');
          _fromOriginal = snapshot.data;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Vocabulary Quiz"),
            actions: <Widget>[
            _fromOriginalChooser(),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: _contentColumn(context),
          ),
        );
      },
    );
  }

  Widget _fromOriginalChooser() {
    return DropdownButton<String>(
      value: _fromOriginal ? _fromOriginalList[0] : _fromOriginalList[1],
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      onChanged: (String chosenTrans) {
        print('changed - $chosenTrans ${chosenTrans == _fromOriginalList[0]}');
        chosenTrans == _fromOriginalList[0]
          ? vocabularyBloc?.setFromOriginal.add(true)
          : vocabularyBloc?.setFromOriginal.add(false);
      },
      items: _fromOriginalList
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 20),
          ),
        );
      }).toList(),
    );
  }

  Widget _contentColumn(context) {
    return Column(
      children: <Widget>[
        _addOneMoreWordRow(context),
        _generateWordList(),
        _buildBeginButton(),
      ],
    );
  }

  Widget _addOneMoreWordRow(context) {
    return new Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    _inputLabel("Word:"),
                    _inputWidget(_wordController),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    _inputLabel("Translate:"),
                    _inputWidget(_translateController),
                  ],
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              final RegExp _regExp = RegExp(r'[a-zA-Zа-яА-Я]');
              if (_wordController.text.contains(_regExp)
                  && _translateController.text.contains(_regExp)) {
                bool _result = await vocabularyBloc?.checkIfWordUnique(
                                      _wordController.text);
                if (_result) {
                  await vocabularyBloc?.addWordWithTranslate.add({
                    'word': _wordController.text,
                    'translate': _translateController.text,
                  });
                  ToastWidget.show("Successfully added new translate", context, false);
                } else {
                  ToastWidget.show("Word already exist", context, false);
                }
              } else {
                ToastWidget.show("Fill the fields correctly", context, false);
              }
            },
            child: Text("Add one more"),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    bool _result = await vocabularyBloc?.deleteLastWord();
                    _result
                      ? ToastWidget.show("Successfully deleted last word", context, _result)
                      : ToastWidget.show("Error on deleting last word", context, _result);
                  },
                  child: Text("Delete last word"),
                ),
              ),
              VerticalDivider(
                width: 4,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    bool _result = await vocabularyBloc?.uploadTestSet();
                    _result
                      ? ToastWidget.show("Successfully uploaded test data", context, _result)
                      : ToastWidget.show("Error on uploading test data", context, _result);
                  },
                  child: Text("Upload test set"),
                ),
              ),
            ],
          ),
        ],
    );
  }

  Widget _inputLabel(String _label) {
    return Container(
      // width: 130,
      // height: 50,
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _inputWidget(dynamic _controller) {
    return Container(
      padding: EdgeInsets.all(5),
      width: 130,
      height: 50,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration.collapsed(
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _generateWordList() {
    List<Word> _wordList = [];

    return StreamBuilder<List<Word>>(
      stream: vocabularyBloc?.wordListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _wordList = snapshot.data;
        }
        if (_wordList?.isEmpty ?? true) {
          return CenterTextWidget(
            message: "There is no vocabulary data",
          );
        }
        return Expanded(
          child: ListView.builder(
            itemCount: _wordList?.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: WordListTile(word: _wordList[index]),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBeginButton() {
    return ElevatedButton(
      onPressed: () {
        locator<NavigationService>().navigateTo(
          Routes.quiz,
          arguments: {
            'vocabulary': _vocabulary,
          },
        );
      },
      child: Text('Begin test'),
    );
  }
}
