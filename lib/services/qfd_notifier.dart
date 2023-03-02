import 'package:flutter/material.dart';

class QfdNotifier extends ChangeNotifier {
  List<String> cusReq = [];
  List<String> engReq = [];
  List<double> weights = [];
  List<List<int>> scales = [];
  List<double> importance = [];
  List<double> percentages = [];

  setNumCusReq(int num) {
    cusReq.clear();
    for (int i = 0; i < num; i++) {
      cusReq.add('');
    }
  }

  setCusReq(int pos, String value) {
    cusReq[pos] = value;
    print(cusReq);
  }

  setNumEngReq(int num) {
    engReq.clear();
    for (int i = 0; i < num; i++) {
      engReq.add('');
    }
  }

  setEngReq(int pos, String value) {
    engReq[pos] = value;
  }

  initHouse() {
    scales.clear();
    weights.clear();
    for (int i = 0; i < cusReq.length; i++) {
      scales.add([]);
      weights.add(1 / cusReq.length);
      for (int j = 0; j < engReq.length; j++) {
        scales[i].add(0);
      }
    }
  }

  setWeight(int pos, double value) {
    weights[pos] = value;
  }

  setScale(int cPos, int ePos, int value) {
    scales[cPos][ePos] = value;
  }

  calculateHoE() {
    importance.clear();
    percentages.clear();
    for (int j = 0; j < scales[0].length; j++) {
      double importanceValue = 0.0;
      for (int i = 0; i < weights.length; i++) {
        importanceValue += weights[i] * scales[i][j];
      }
      importance.add(importanceValue);
    }
    double sumIm = importance.reduce((a, b) => a + b);
    for (double im in importance) {
      percentages.add(im / sumIm);
    }
  }
}
