import 'package:flutter/material.dart';

class ExpertNotifier extends ChangeNotifier {
  List<double>? expertWi;
  Map<String, Map<String, List<List<double>>>> expValues = {};

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
    print(exQsMatrices);

//product based on expert weights
    Map<String, Map<String, List<List<List<double>>>>> cjmExQsMatrices = {};
    exQsMatrices.forEach((key, value) {
      Map<String, List<List<List<double>>>> qsMatrices = {};
      value.forEach((key, value) {
        List<List<List<double>>> matrices = [];
        for (var items in value) {
          List<List<double>> item = [];
          int pos = 0;
          for (var scale in items) {
            for (int i = 0; i < scale.length; i++) {
              if (i == pos) {
                item.add([
                  (scale[i] <= 1 || scale[i] >= 9 ? scale[i] : scale[i] - 1),
                  scale[i],
                  (scale[i] <= 1 || scale[i] >= 9 ? scale[i] : scale[i] + 1)
                ]);
              }
            }
            pos++;
          }
          matrices.add(item);
        }
        qsMatrices[key] = matrices;
      });
      cjmExQsMatrices[key] = qsMatrices;
    });
    print(cjmExQsMatrices);
  }
}
