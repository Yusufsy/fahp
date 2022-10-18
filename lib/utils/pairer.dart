import 'package:collection/collection.dart';

class Pairer {
  List<List<String>> paiarCriteria(List<String> criteria) {
    List<List<String>> col = [];
    List<List<String>> fin = [];
    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;

    // Make all possible pairs
    for (int i = 0; i < criteria.length; i++) {
      for (int j = 0; j < criteria.length; j++) {
        if (criteria[j] != criteria[i]) {
          col.add([criteria[i], criteria[j]]);
        }
      }
    }
    fin = col;

    for (int i = 0; i < col.length; i++) {
      for (int j = 0; j < col.length; j++) {
        // for (int k = 0; k < fin[i].length; k++) {
        //   if (fin[i][j] == fin[i][k]) {
        //     print('found ' + fin[i][j] + ' | ' + fin[i][k]);
        //   }
        // }
        // print(unOrdDeepEq(col[i], col[j]));
        if (col[i] != col[j]) {
          if (unOrdDeepEq(col[i], col[j])) {
            fin.removeAt(j);
          }
        }
      }
    }
    // Return the size of the set
    return fin;
  }
}
