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
    print("exQsMatrices $exQsMatrices");

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
    print(cjmExQsMatrices);

    for (int i = 0; i < expertWi!.length; i++) {
      for (int iq = 1; iq <= cjmExQsMatrices["ex${i + 1}"]!.length; iq++) {
        var matL = cjmExQsMatrices["ex${i + 1}"]!['q$iq']!["l"];
        List<double> xL = [];
        for (int c = 0; c < matL!.length; c++) {
          xL.add(matL[c][c]);
        }
        print(xL);
      }
    }
  }
}
