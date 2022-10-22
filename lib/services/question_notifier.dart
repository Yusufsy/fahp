import 'package:flutter/material.dart';

class QuestionNotifier extends ChangeNotifier {
  List<int>? questionMatrix;

  init(int numQuestions) {
    questionMatrix = [];
    for (int i = 0; i < numQuestions; i++) {
      questionMatrix!.add(2);
    }
    print(questionMatrix);
  }

  setMatrix(int pos, int value) {
    questionMatrix![pos] = value;
    print(questionMatrix);
  }

  addMatrix(int pos, int val) {
    questionMatrix![pos] = questionMatrix![pos] + 1;
    print(questionMatrix);
  }
}
