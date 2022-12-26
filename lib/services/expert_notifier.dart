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
    // expValues[key] = {...exMap};
    expValues = newExpValues;
    notifyListeners();
    print(expValues);
  }

  setUpCJM() {}
}
