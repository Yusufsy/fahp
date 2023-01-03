import 'dart:math';

import 'package:fahp/utils/constants.dart';
import 'package:flutter/material.dart';

class ExpertNotifier extends ChangeNotifier {
  List<double>? expertWi;
  Map<String, Map<String, List<List<double>>>> expValues = {};
  Map<String, Map<String, List<List<double>>>> cjmMatrix = {};
  Map<String, List<double>> crispWeights = {};
  Map<String, List<double>> normalWeights = {};
  Map<String, double> gci = {};
  Map<String, double> cr = {};
  Map<String, Map<String, List<double>>> allPriorities = {};
  Map<String, Map<String, List<double>>> allWeights = {};

  init(int numExperts) {
    expertWi = [];
    double sharedWi = 1 / numExperts;
    for (int i = 0; i < numExperts; i++) {
      expertWi!.add(sharedWi);
    }
    print(expertWi);
  }

  setWeight(int pos, double value) {
    expertWi![pos] = value;
    print(expertWi);
  }

  setExpValues(
      {required Map<String, Map<String, List<List<double>>>> newExpValues}) {
    expValues = newExpValues;
    notifyListeners();
    print(expValues);
  }

  setUpCJM() {
    //Getting l,m,u
    Map<String, Map<String, List<List<List<double>>>>> exQsMatrices = {};
    expValues.forEach((key, value) {
      Map<String, List<List<List<double>>>> qsMatrices = {};
      value.forEach((key, value) {
        List<List<List<double>>> matrices = [];
        for (var items in value) {
          List<List<double>> item = [];
          for (var scale in items) {
            item.add([
              (scale <= 1 || scale >= 9 ? scale : scale - 1),
              scale,
              (scale <= 1 || scale >= 9 ? scale : scale + 1)
            ]);
          }
          matrices.add(item);
        }
        qsMatrices[key] = matrices;
      });
      exQsMatrices[key] = qsMatrices;
    });

    //collecting l m u
    Map<String, Map<String, Map<String, List<List<double>>>>> cjmExQsMatrices =
        {};
    exQsMatrices.forEach((key, value) {
      Map<String, Map<String, List<List<double>>>> itemL = {};
      value.forEach((_key, _value) {
        itemL[_key] = {};
        itemL[_key]!["l"] = [];
        itemL[_key]!["m"] = [];
        itemL[_key]!["u"] = [];
        for (var element in _value) {
          List<double> l = [];
          List<double> m = [];
          List<double> u = [];
          for (var subElement in element) {
            for (int i = 0; i < subElement.length; i++) {
              if (i == 0) {
                l.add(subElement[i]);
              } else if (i == 1) {
                m.add(subElement[i]);
              } else {
                u.add(subElement[i]);
              }
            }
          }
          itemL[_key]!["l"]!.add(l.toList());
          itemL[_key]!["m"]!.add(m.toList());
          itemL[_key]!["u"]!.add(u.toList());
        }
        cjmExQsMatrices[key] = itemL;
      });
    });
    // print(cjmExQsMatrices);

    Map<String, Map<String, List<List<List<double>>>>> allQsM = {};
    for (int i = 0; i < expertWi!.length; i++) {
      for (int iq = 1; iq <= cjmExQsMatrices["ex${i + 1}"]!.length; iq++) {
        if (allQsM['q$iq'] == null) {
          allQsM['q$iq'] = {};
          allQsM['q$iq']!['l'] = [];
          allQsM['q$iq']!['m'] = [];
          allQsM['q$iq']!['u'] = [];
        }
      }
      for (int iq = 1; iq <= cjmExQsMatrices["ex${i + 1}"]!.length; iq++) {
        var matL = cjmExQsMatrices["ex${i + 1}"]!['q$iq']!["l"];
        allQsM['q$iq']!['l']!.add(matL!);
        allQsM['q$iq']!['m']!
            .add(cjmExQsMatrices["ex${i + 1}"]!['q$iq']!["m"]!);
        allQsM['q$iq']!['u']!
            .add(cjmExQsMatrices["ex${i + 1}"]!['q$iq']!["u"]!);
      }
    }
    // print(allQsM);
    int exIndex = 0;
    allQsM.forEach((keyQ, question) {
      if (cjmMatrix[keyQ] == null) {
        cjmMatrix[keyQ] = {};
        cjmMatrix[keyQ]!['l'] = [];
        cjmMatrix[keyQ]!['m'] = [];
        cjmMatrix[keyQ]!['u'] = [];
      }
      //for l
      List<List<double>> multipliedList = [];
      var dynamicLists = question['l']!;
      for (var i = 0; i < dynamicLists[0].length; i++) {
        multipliedList.add([]);
        for (var j = 0; j < dynamicLists[0][i].length; j++) {
          double result = 1;
          for (var k = 0; k < dynamicLists.length; k++) {
            result *= pow(dynamicLists[k][i][j], expertWi![exIndex]);
          }
          multipliedList[i].add(result);
        }
      }
      cjmMatrix[keyQ]!['l'] = multipliedList;

      //for m
      List<List<double>> multipliedListM = [];
      var dynamicListsM = question['m']!;
      for (var i = 0; i < dynamicListsM[0].length; i++) {
        multipliedListM.add([]);
        for (var j = 0; j < dynamicListsM[0][i].length; j++) {
          double result = 1;
          for (var k = 0; k < dynamicListsM.length; k++) {
            result *= pow(dynamicListsM[k][i][j], expertWi![exIndex]);
          }
          multipliedListM[i].add(result);
        }
      }
      cjmMatrix[keyQ]!['m'] = multipliedListM;

      //for u
      List<List<double>> multipliedListU = [];
      var dynamicListsU = question['u']!;
      for (var i = 0; i < dynamicListsU[0].length; i++) {
        multipliedListU.add([]);
        for (var j = 0; j < dynamicListsU[0][i].length; j++) {
          double result = 1;
          for (var k = 0; k < dynamicListsU.length; k++) {
            result *= pow(dynamicListsU[k][i][j], expertWi![exIndex]);
          }
          multipliedListU[i].add(result);
        }
      }
      cjmMatrix[keyQ]!['u'] = multipliedListU;
      exIndex++;
    });
    print(cjmMatrix);
    calculatePriorities();
    notifyListeners();
  }

  void calculatePriorities() {
    Map<String, List<double>> logs = {};
    logs.clear();
    gci.clear();
    cr.clear();
    cjmMatrix.forEach((key, value) {
      allPriorities[key] = {'l': [], 'm': [], 'u': []};
      allWeights[key] = {'l': [], 'm': [], 'u': []};
      logs[key] = [];
      crispWeights[key] = [];
    });
    cjmMatrix.forEach((key, value) {
      for (int rate = 0; rate < cjmMatrix[key]!['l']!.length; rate++) {
        double productL = cjmMatrix[key]!['l']![rate]
            .reduce((value, element) => value * element);
        allPriorities[key]!['l']!
            .add(pow(productL, 1 / value.length).toDouble());

        double productM = cjmMatrix[key]!['m']![rate]
            .reduce((value, element) => value * element);
        allPriorities[key]!['m']!
            .add(pow(productM, 1 / value.length).toDouble());

        double productU = cjmMatrix[key]!['u']![rate]
            .reduce((value, element) => value * element);
        allPriorities[key]!['u']!
            .add(pow(productU, 1 / value.length).toDouble());
      }
    });
    print('Priorities $allPriorities');
    allPriorities.forEach((key, value) {
      double sumL = 0.0;
      for (double itemL in allPriorities[key]!['l']!) {
        sumL += itemL;
      }
      double sumM = 0.0;
      for (double itemM in allPriorities[key]!['m']!) {
        sumM += itemM;
      }
      double sumU = 0.0;
      for (double itemU in allPriorities[key]!['u']!) {
        sumU += itemU;
      }
      for (int rgm = 0; rgm < allPriorities[key]!['l']!.length; rgm++) {
        allWeights[key]!['l']!.add(allPriorities[key]!['l']![rgm] / sumL);
        allWeights[key]!['m']!.add(allPriorities[key]!['m']![rgm] / sumM);
        allWeights[key]!['u']!.add(allPriorities[key]!['u']![rgm] / sumU);
      }
    });
    print('All weights $allWeights');
    allWeights.forEach((key, value) {
      for (int i = 0; i < allWeights[key]!['l']!.length; i++) {
        var l = allWeights[key]!['l']![i];
        var m = allWeights[key]!['m']![i];
        var u = allWeights[key]!['u']![i];
        crispWeights[key]!.add(((l + m + u) / 3));
      }
    });
    print('Crips Weight $crispWeights');
    crispWeights.forEach((key, value) {
      normalWeights[key] = [];
      var sumVal = 0.0;
      for (var doub in value) {
        sumVal += doub;
      }
      for (var doub in value) {
        normalWeights[key]!.add(doub / sumVal);
      }
    });
    print(normalWeights);
    cjmMatrix.forEach((key, value) {
      int pos = 1;
      for (int row = 0; row < cjmMatrix[key]!['m']!.length; row++) {
        int i = pos;
        for (int j = i; j <= cjmMatrix[key]!['m']![row].length; j++) {
          if (j < cjmMatrix[key]!['m']![row].length) {
            logs[key]!.add(pow(
                    log(cjmMatrix[key]!['m']![row][j]) -
                        log(normalWeights[key]![pos - 1] /
                            normalWeights[key]![j]),
                    2)
                .toDouble());
          }
        }
        pos++;
      }
    });
    logs.forEach((key, value) {
      double totalLogs = 0.0;
      for (double itemL in logs[key]!) {
        totalLogs += itemL;
      }
      double upper = 2 * totalLogs;
      double lower = (cjmMatrix[key]!['m']!.length - 1) *
          (cjmMatrix[key]!['m']!.length - 2);

      double fraction = upper / lower;

      double computeGCI = fraction * totalLogs;

      gci[key] = computeGCI;
      cr[key] = computeGCI / kN[cjmMatrix[key]!['m']!.length]!;
    });
    print('GCI: $gci CR: $cr');
  }
}
