import 'package:flutter/material.dart';

class QfdNotifier extends ChangeNotifier {
  List<String> cusReq = [];
  List<String> engReq = [];
  List<double> weights = [];

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
}
