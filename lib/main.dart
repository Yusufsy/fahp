import 'package:fahp/homepage.dart';
import 'package:fahp/services/expert_notifier.dart';
import 'package:fahp/services/matrix_notifier.dart';
import 'package:fahp/services/qfd_notifier.dart';
import 'package:fahp/services/question_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MatrixNotifier()),
        ChangeNotifierProvider(create: (_) => ExpertNotifier()),
        ChangeNotifierProvider(create: (_) => QuestionNotifier()),
        ChangeNotifierProvider(create: (_) => QfdNotifier()),
      ],
      child: MaterialApp(
        title: 'Consensus AHP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
