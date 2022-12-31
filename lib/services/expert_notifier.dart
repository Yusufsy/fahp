import 'dart:math';

import 'package:flutter/material.dart';

class ExpertNotifier extends ChangeNotifier {
  List<double>? expertWi;
  Map<String, Map<String, List<List<double>>>> expValues = {};
  Map<String, Map<String, List<List<double>>>> cjmMatrix = {};

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
            // result *= dynamicListsU[k][i][j];
          }
          multipliedListU[i].add(result);
        }
      }
      cjmMatrix[keyQ]!['u'] = multipliedListU;
      exIndex++;
    });
    print(cjmMatrix);
  }
}
