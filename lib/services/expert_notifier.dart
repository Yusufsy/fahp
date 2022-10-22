import 'package:flutter/material.dart';

class ExpertNotifier extends ChangeNotifier {
  List<double>? expertWi;

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
}
