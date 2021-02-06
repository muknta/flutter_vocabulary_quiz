import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

import 'package:vocabulary_quiz/data/db/sembast_db.dart';
import 'package:vocabulary_quiz/domain/repository/vocabulary_repository.dart';
import 'package:vocabulary_quiz/internal/navigation/navigation_service.dart';
import 'package:vocabulary_quiz/internal/dependencies/vocabulary_data_repository_module.dart';
import 'package:vocabulary_quiz/internal/dependencies/sembast_db_module.dart';
import 'package:vocabulary_quiz/internal/dependencies/word_dao_module.dart';


GetIt locator = GetIt.instance;

void setupLocators() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => WordDaoModule.wordDao());
  locator.registerLazySingleton(() => VocabularyDataRepositoryModule.vocabularyDataRepository());
  locator.registerSingletonAsync<Database>(
      () async => await SembastDBModule.sembastDB().database);
}
