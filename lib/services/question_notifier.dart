import 'package:collection/collection.dart';
import 'package:fahp/utils/pairer.dart';
import 'package:flutter/material.dart';

class QuestionNotifier extends ChangeNotifier {
  List<int>? questionMatrix;
  List<String>? wrt;
  Map<int, List<String>> questionMatrixMap = {};
  Map<int, List<List<String>>> pairsGen = {};
  Map<List<String>, List<List<double>>> allMatrices = {};

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
    allMatrices.clear();
    questionMatrixMap.forEach((key, value) {
      pairsGen[key] = Pairer().paiarCriteria(value);
    });
    print(pairsGen);

    questionMatrixMap.forEach((key, value) {
      allMatrices[value] = [];
    });
    allMatrices.forEach(
      (key, value) {
        for (int i = 0; i < key.length; i++) {
          allMatrices[key]!.add([]);
        }
      },
    );
    allMatrices.forEach(
      (key, value) {
        for (int i = 0; i < key.length; i++) {
          for (int j = 0; j < key.length; j++) {
            allMatrices[key]![i].add(1.0);
          }
        }
      },
    );
    print(allMatrices);
  }

  void setMatrixValue(List<String> pair, double val, int index, int pos) {
    print(questionMatrixMap[index]);
    allMatrices.forEach((key, value) {
      if (key == questionMatrixMap[index]) {
        for (int i = 0; i < key.length; i++) {
          for (int j = 0; j < key.length; j++) {
            for (var element in pairsGen[index]!) {
              if (element == pair) {
                if ([key[i], key[j]].equals(element)) {
                  print('${[key[i], key[j]]} equal ${element}');
                  // myMatrix[criteria![i]]![j] = val;
                  // myMatrix[criteria![j]]![i] = 1 / val;
                  allMatrices[key]![i][j] = val;
                  allMatrices[key]![j][i] = 1 / val;
                }
              }
            }
          }
        }
      }
    });
    print(allMatrices);
  }
}
