import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MatrixNotifier extends ChangeNotifier {
  Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
  List<String>? criteria;
  int? numOfComp;
  Map<String, List<double>> myMatrix = {};
  List<List<String>>? pairs;
  List<double>? priorities;
  List<double>? geoMean;
  Map<String, List<double>> myMatrixCrtW = {};
  List<double>? wSumCrt;
  List<double>? difWSumCrt;
  double? consistAvg;
  double? consistIndex;
  double? consistRatio;

  Map<int, double> randomIndex = {
    2: 0.0,
    3: 0.58,
    4: 0.9,
    5: 1.12,
    6: 1.24,
    7: 1.32,
    8: 1.41,
    9: 1.45,
    10: 1.49,
    11: 1.51,
    12: 1.48,
    13: 1.56,
    14: 1.57,
    15: 1.59,
    16: 1.605,
    17: 1.61,
    18: 1.615,
    19: 1.62,
    20: 1.625
  };

  void updateMatrix(String crt, int value, int pos) {}

  void updateCriteria(List<String> cri, List<List<String>> pairsSet) {
    myMatrix.clear();
    pairs = pairsSet;
    criteria = cri;
    numOfComp = cri.length;
    print(numOfComp);
    for (int i = 0; i < numOfComp!; i++) {
      myMatrix[cri[i]] = [];
    }
    for (int i = 0; i < numOfComp!; i++) {
      for (int i = 0; i < numOfComp!; i++) {
        myMatrix[cri[i]]!.add(1);
      }
    }
    myMatrix.forEach(
      (key, value) {
        print(key + ' ' + value.toString());
      },
    );
    // print(myMatrix);
  }

  void setMatrixValue(List<String> cri, double val, int pos) {
    for (int i = 0; i < criteria!.length; i++) {
      for (int j = 0; j < criteria!.length; j++) {
        if ([criteria![i], criteria![j]].equals(pairs![pos])) {
          print('${[criteria![i], criteria![j]]} equal ${pairs![pos]}');
          myMatrix[criteria![i]]![j] = val;
          myMatrix[criteria![j]]![i] = 1 / val;
        }
      }
    }
  }

  void generatePriorities() {
    geoMean = [];
    priorities = [];
    wSumCrt = [];
    difWSumCrt = [];
    myMatrixCrtW.clear();
    myMatrix.forEach(
      (key, value) {
        double product = value.reduce((value, element) => value * element);
        print(product);
        geoMean!.add(pow(product, (1 / numOfComp!)).toDouble());
      },
    );
    print(geoMean);
    for (double val in geoMean!) {
      priorities!.add((val / geoMean!.sum));
    }
    print(priorities);
    // print(priorities!.sum);
    myMatrix.forEach((key, value) {
      myMatrixCrtW[key] = [];
    });
    myMatrix.forEach((key, value) {
      for (double val in value) {
        myMatrixCrtW[key]!.add(val * priorities![value.indexOf(val)]);
      }
    });
    print(myMatrixCrtW);
    myMatrixCrtW.forEach((key, value) {
      double sum = value.sum;
      wSumCrt!.add(sum);
    });
    print(wSumCrt);
    for (int i = 0; i < criteria!.length; i++) {
      var dif = wSumCrt![i] / priorities![i];
      difWSumCrt!.add(dif);
    }
    print(difWSumCrt);
    consistAvg = difWSumCrt!.sum / difWSumCrt!.length; //Principal Eigen Value
    print('Consistency average $consistAvg');
    consistIndex =
        (consistAvg! - difWSumCrt!.length) / (difWSumCrt!.length - 1);
    print('Consistency index $consistIndex');
    consistRatio = consistIndex! / randomIndex[criteria!.length]!;
    print('Consistency ratio $consistRatio');
  }
}
