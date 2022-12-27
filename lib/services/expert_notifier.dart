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
    Map<String, Map<String, Map<String, List<List<double>>>>> cjmExQsMatrices =
        {};
    exQsMatrices.forEach((key, value) {
      Map<String, Map<String, List<List<double>>>> qsMatrices = {};
      value.forEach((key, value) {
        Map<String, List<List<double>>> matrices = {};
        for (var items in value) {
          // for (int i = 0; i < items.length; i++) {
          List<List<double>> itemL = [];
          List<List<double>> itemM = [];
          List<List<double>> itemU = [];
          List<double> l = [];
          List<double> m = [];
          List<double> u = [];
          for (var element in items) {
            for (int i = 0; i < element.length; i++) {
              if (i == 0) {
                l.add(element[i]);
              } else if (i == 1) {
                m.add(element[i]);
              } else {
                u.add(element[i]);
              }
            }
            // print(l);
            // List<double> subL = [];
            // l.forEach((element) {
            //   subL.add(element);
            // });
            itemL.add(l);
            itemM.add(m);
            itemU.add(u);
          }
          print(itemL);
          print(itemM);
          matrices["l"] = [];
          itemL.forEach((element) {
            List<double> el = [];
            for (var element in element) {
              el.add(element);
            }
            matrices["l"]!.add(el);
          });
          // matrices["l"] = itemL;
          matrices["m"] = itemM;
          matrices["u"] = itemU;
        }
        qsMatrices[key] = matrices;
      });
      cjmExQsMatrices[key] = qsMatrices;
    });
    print(cjmExQsMatrices);
  }
}
