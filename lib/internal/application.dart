import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';

import 'package:vocabulary_quiz/data/db/sembast_db.dart';
import 'package:vocabulary_quiz/domain/bloc/vocabulary_bloc.dart';
import 'package:vocabulary_quiz/internal/navigation/navigation.dart';
import 'package:vocabulary_quiz/internal/locator.dart';
import 'package:vocabulary_quiz/internal/dependencies/sembast_db_module.dart';
import 'package:vocabulary_quiz/internal/dependencies/vocabulary_bloc_module.dart';
import 'package:vocabulary_quiz/presentation/home/home_page.dart';
import 'package:vocabulary_quiz/presentation/widgets/loader.dart';


class Application extends StatelessWidget {
  static const _title = 'Vocabulary Quiz';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<VocabularyBloc>(
          create: (_) async => await VocabularyBlocModule.vocabularyBloc(),
          // dispose: (_, VocabularyBloc vocabularyBloc) => vocabularyBloc.dispose(),
        ),
      ],
      child: FutureBuilder(
        future: locator.allReady(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return _materialApp();
          } else {
            return Loader();
          }
        },
      ),
    );
  }

  Widget _materialApp() {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: Routes.home,
      home: HomePage(),
    );
  }
}
