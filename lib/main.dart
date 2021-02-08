import 'dart:async';
import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vocabulary_quiz/internal/locator.dart';
import 'package:vocabulary_quiz/internal/application.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocators();

  runApp(Application());
}
