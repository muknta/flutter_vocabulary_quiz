import 'package:vocabulary_quiz/domain/bloc/vocabulary_bloc.dart';
import 'vocabulary_data_repository_module.dart';


class VocabularyBlocModule {
  static VocabularyBloc _vocabularyBloc;

  static Future<VocabularyBloc> vocabularyBloc() async {
    if (_vocabularyBloc == null) {
      _vocabularyBloc = await VocabularyBloc.init(
        VocabularyDataRepositoryModule.vocabularyDataRepository(),
      );
    }
    return _vocabularyBloc;
  }
}
