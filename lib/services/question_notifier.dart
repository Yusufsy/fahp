import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fahp/utils/pairer.dart';
import 'package:flutter/material.dart';

class QuestionNotifier extends ChangeNotifier {
  List<int>? questionMatrix;
  List<String>? wrt;
  Map<int, List<String>> questionMatrixMap = {};
  Map<int, List<List<String>>> pairsGen = {};
  Map<List<String>, List<List<double>>> allMatrices = {};
  Map<List<String>, List<double>> allPriorities = {};
  Map<List<String>, List<double>> allWeights = {};
  List<double> gci = [];
  List<double> cr = [];
  List<Map<int, List<String>>> exQuestionMatrixMap = [];
  List<Map<List<String>, List<List<double>>>> exAllMatrices = [];
  Map<int, double> kN = {
    3: 3.147,
    4: 3.526,
    5: 3.717,
    6: 3.755,
    7: 3.755,
    8: 3.744,
    9: 3.733,
    10: 3.709,
    11: 3.698,
    12: 3.685,
    13: 3.674,
    14: 3.663,
    15: 3.646,
    16: 3.646,
  };

  init(int numQuestions, int numExperts) {
    questionMatrix = [];
    wrt = [];
    questionMatrixMap.clear();
    pairsGen.clear();
    for (int i = 0; i < numQuestions; i++) {
      questionMatrix!.add(2);
      questionMatrixMap[i] = ['', ''];
      wrt!.add('');
    }
    // print(questionMatrix);
    // print(questionMatrixMap);
    for (int i = 0; i < numExperts; i++) {
      exQuestionMatrixMap.add(questionMatrixMap);
    }
    print(exQuestionMatrixMap);
  }

  setMatrix(int pos, int value) {
    questionMatrix![pos] = value;
    questionMatrixMap[pos] = [];
    for (int i = 0; i < value; i++) {
      questionMatrixMap[pos]!.add('');
    }
    for (int i = 0; i < exQuestionMatrixMap.length; i++) {
      exQuestionMatrixMap[i] = questionMatrixMap;
    }
    print(exQuestionMatrixMap);
  }

  setCriteria(int key, int pos, String value) {
    questionMatrixMap[key]![pos] = value;
    // print(questionMatrixMap);
    for (int i = 0; i < exQuestionMatrixMap.length; i++) {
      exQuestionMatrixMap[i] = questionMatrixMap;
    }
    print(exQuestionMatrixMap);
  }

  void setWrt(int pos, String value) {
    wrt![pos] = value;
    print(wrt);
  }

  void generatePairs() {
    allMatrices.clear();
    exAllMatrices.clear();
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
    // print(allMatrices);
    for (int i = 0; i < exQuestionMatrixMap.length; i++) {
      exAllMatrices.add(allMatrices);
    }
    print(exAllMatrices);
  }

  void setMatrixValue(int exIndex, List<String> pair, double val, int index,
      int pos, int respect) {
    print(exIndex);
    // print(exQuestionMatrixMap[exIndex][index]);
    Map matrix = exAllMatrices[exIndex];
    // exAllMatrices[exIndex].forEach((key, value) {
    // if (key == exQuestionMatrixMap[exIndex][index]) {
    for (int i = 0; i < matrix.keys.toList()[index].length; i++) {
      for (int j = 0; j < matrix.keys.toList()[index].length; j++) {
        for (var element in pairsGen[index]!) {
          if (element == pair) {
            if ([matrix.keys.toList()[index][i], matrix.keys.toList()[index][j]]
                .equals(element)) {
              print('${[
                matrix.keys.toList()[index][i],
                matrix.keys.toList()[index][j]
              ]} equal $element');
              if (respect == 0) {
                matrix[matrix.keys.toList()[index]]![i][j] = val;
                matrix[matrix.keys.toList()[index]]![j][i] = 1 / val;
              } else {
                matrix[matrix.keys.toList()[index]]![i][j] = 1 / val;
                matrix[matrix.keys.toList()[index]]![j][i] = val;
              }
            }
          }
        }
      }
    }
    // }
    // });
    print(matrix);
    // for (int i = 0; i < exQuestionMatrixMap.length; i++) {
    //   if (i == exIndex) {
    //     exAllMatrices[i] = matrix;
    //   }
    // }
    print(exAllMatrices);
  }

  void calculatePriorities() {
    print(exAllMatrices);
    Map<List<String>, List<double>> logs = {};
    allPriorities.clear();
    allWeights.clear();
    logs.clear();
    gci.clear();
    cr.clear();
    allMatrices.forEach((key, value) {
      allPriorities[key] = [];
      allWeights[key] = [];
      logs[key] = [];
    });
    allMatrices.forEach((key, value) {
      for (var rate in value) {
        double product = rate.reduce((value, element) => value * element);
        allPriorities[key]!.add(pow(product, 1 / value.length).toDouble());
      }
    });
    allPriorities.forEach((key, value) {
      double sum = value.sum;
      for (double rgm in value) {
        allWeights[key]!.add(rgm / sum);
      }
    });
    // print(allWeights);
    allMatrices.forEach((key, value) {
      int pos = 1;
      for (var row in allMatrices[key]!) {
        int i = pos;
        for (int j = i; j <= row.length; j++) {
          if (j < row.length) {
            // print('$pos ${row[j]}');
            // print(allWeights[key]![pos - 1]);
            // print(allWeights[key]![j]);
            logs[key]!.add(pow(
                    log(row[j]) -
                        log(allWeights[key]![pos - 1] / allWeights[key]![j]),
                    2)
                .toDouble());
            // logs[key]!.add(pow((log(4) - log(0.6145 / 0.2246)), 2).toDouble());
          }
        }
        pos++;
      }
    });
    print(logs);
    logs.forEach((key, value) {
      print(key.length);
      double totalLogs = value.sum;
      double upper = 2 * totalLogs;
      double lower = (key.length - 2) * (key.length - 2);
      double fraction = upper / lower;
      double computeGCI = fraction * totalLogs;
      gci.add(computeGCI);
      cr.add(computeGCI / kN[key.length]!);
    });
    print('GCI: $gci CR: $cr');
  }
}
