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

  void setMatrixValue(
      List<String> pair, double val, int index, int pos, int respect) {
    print(questionMatrixMap[index]);
    allMatrices.forEach((key, value) {
      if (key == questionMatrixMap[index]) {
        for (int i = 0; i < key.length; i++) {
          for (int j = 0; j < key.length; j++) {
            for (var element in pairsGen[index]!) {
              if (element == pair) {
                if ([key[i], key[j]].equals(element)) {
                  print('${[key[i], key[j]]} equal $element');
                  if (respect == 0) {
                    allMatrices[key]![i][j] = val;
                    allMatrices[key]![j][i] = 1 / val;
                  } else {
                    allMatrices[key]![i][j] = 1 / val;
                    allMatrices[key]![j][i] = val;
                  }
                }
              }
            }
          }
        }
      }
    });
    print(allMatrices);
  }

  void calculatePriorities() {
    Map<List<String>, List<double>> logs = {};
    allPriorities.clear();
    allWeights.clear();
    logs.clear();
    gci.clear();
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
    });
    print(gci);
  }
}
