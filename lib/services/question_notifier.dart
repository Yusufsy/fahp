import 'package:fahp/utils/pairer.dart';
import 'package:flutter/material.dart';

class QuestionNotifier extends ChangeNotifier {
  List<int>? questionMatrix;
  List<String>? wrt;
  Map<int, List<String>> questionMatrixMap = {};
  Map<int, List<List<String>>> pairsGen = {};

  init(int numQuestions) {
    questionMatrix = [];
    wrt = [];
    questionMatrixMap.clear();
    pairsGen.clear();
    for (int i = 0; i < numQuestions; i++) {
      questionMatrix!.add(2);
      questionMatrixMap[i] = ['', ''];
      wrt!.add('');
    }
    print(questionMatrix);
    print(questionMatrixMap);
  }

  setMatrix(int pos, int value) {
    questionMatrix![pos] = value;
    questionMatrixMap[pos] = [];
    for (int i = 0; i < value; i++) {
      questionMatrixMap[pos]!.add('');
    }
    print(questionMatrixMap);
  }

  setCriteria(int key, int pos, String value) {
    questionMatrixMap[key]![pos] = value;
    print(questionMatrixMap);
  }

  void setWrt(int pos, String value) {
    wrt![pos] = value;
    print(wrt);
  }

  void generatePairs() {
    questionMatrixMap.forEach((key, value) {
      pairsGen[key] = Pairer().paiarCriteria(value);
    });
    print(pairsGen);
  }
}
