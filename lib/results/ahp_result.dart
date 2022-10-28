import 'package:fahp/services/matrix_notifier.dart';
import 'package:fahp/services/question_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AhpResult extends StatefulWidget {
  const AhpResult({super.key});

  @override
  State<AhpResult> createState() => _AhpResultState();
}

class _AhpResultState extends State<AhpResult> {
  @override
  void initState() {
    // context.read<MatrixNotifier>().generatePriorities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topicStyle = Theme.of(context).textTheme.headline3;
    final subTopicStyle = Theme.of(context).textTheme.headline5;
    final qMatrices = context.watch<QuestionNotifier>().questionMatrixMap;
    final allMatrices = context.watch<QuestionNotifier>().allMatrices;
    final allPriorities = context.watch<QuestionNotifier>().allPriorities;
    final allWeights = context.watch<QuestionNotifier>().allWeights;
    // var matrixVals = context.watch<MatrixNotifier>().myMatrix;
    // var criteria = context.watch<MatrixNotifier>().criteria;
    // var priorities = context.watch<MatrixNotifier>().priorities;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text("LOGO"),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text("Consensus AHP Online Calculator"),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'AHP RESULTS',
                    style: topicStyle,
                  ),
                ),
                for (var qMatrix in qMatrices.values)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Question ${qMatrices.values.toList().indexOf(qMatrix) + 1}',
                          style: topicStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Crisp Numbers',
                          style: subTopicStyle,
                        ),
                      ),
                      Center(
                        child: Table(
                          border: TableBorder.all(),
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          children: [
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(' '),
                                  ),
                                ),
                                for (String criteria in qMatrix)
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(criteria),
                                    ),
                                  ),
                              ],
                            ),
                            for (String criteria in qMatrix)
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(criteria),
                                    ),
                                  ),
                                  for (var rows in allMatrices[qMatrix]![
                                      qMatrix.indexOf(criteria)])
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(rows.toStringAsFixed(2)),
                                    )),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Calculations',
                          style: subTopicStyle,
                        ),
                      ),
                      Center(
                        child: Table(
                          border: TableBorder.all(),
                          defaultColumnWidth: const IntrinsicColumnWidth(),
                          children: [
                            const TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(' '),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('RGM'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Weight'),
                                  ),
                                ),
                                // TableCell(
                                //   child: Padding(
                                //     padding: EdgeInsets.all(8.0),
                                //     child: Text('GCI'),
                                //   ),
                                // ),
                                // TableCell(
                                //   child: Padding(
                                //     padding: EdgeInsets.all(8.0),
                                //     child: Text('CR'),
                                //   ),
                                // ),
                              ],
                            ),
                            for (String criteria in qMatrix)
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(criteria),
                                    ),
                                  ),
                                  // for (int i = 0; i < qMatrix.length; i++)
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(allPriorities[qMatrix]![
                                              qMatrix.indexOf(criteria)]
                                          .toStringAsFixed(4)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(allWeights[qMatrix]![
                                              qMatrix.indexOf(criteria)]
                                          .toStringAsFixed(4)),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                //   child: RichText(
                //     text: TextSpan(
                //         text: 'Number of Comparisons:',
                //         style: Theme.of(context).textTheme.headline4,
                //         children: [
                //           TextSpan(
                //               text:
                //                   ' ${context.watch<MatrixNotifier>().numOfComp}',
                //               style: Theme.of(context).textTheme.headline2)
                //         ]),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                //   child: Text(
                //     'Priorities',
                //     style: topicStyle,
                //   ),
                // ),
                // Table(
                //   border: TableBorder.all(),
                //   defaultColumnWidth: const IntrinsicColumnWidth(),
                //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                //   children: [
                //     const TableRow(
                //       children: [
                //         TableCell(
                //           child: Padding(
                //             padding: EdgeInsets.all(8.0),
                //             child: Text('ID'),
                //           ),
                //         ),
                //         TableCell(
                //           child: Padding(
                //             padding: EdgeInsets.all(8.0),
                //             child: Text('Criteria'),
                //           ),
                //         ),
                //         TableCell(
                //           child: Padding(
                //             padding: EdgeInsets.all(8.0),
                //             child: Text('Priorities'),
                //           ),
                //         ),
                //       ],
                //     ),
                //     for (int i = 0; i < criteria.length; i++)
                //       TableRow(
                //         children: [
                //           TableCell(
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text('${i + 1}'),
                //             ),
                //           ),
                //           TableCell(
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text(criteria[i]),
                //             ),
                //           ),
                //           TableCell(
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Text(
                //                   '${(priorities![i] * 100).toStringAsFixed(2)}%'),
                //             ),
                //           ),
                //         ],
                //       ),
                //   ],
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                //   child: RichText(
                //     text: TextSpan(
                //       text: 'Principal Eigen Value:',
                //       style: Theme.of(context).textTheme.headline4,
                //       children: [
                //         TextSpan(
                //             text:
                //                 ' ${context.watch<MatrixNotifier>().consistAvg!.toStringAsFixed(4)}',
                //             style: Theme.of(context).textTheme.headline2)
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                //   child: RichText(
                //     text: TextSpan(
                //       text: 'Consistency Ratio:',
                //       style: Theme.of(context).textTheme.headline4,
                //       children: [
                //         TextSpan(
                //           text:
                //               ' ${context.watch<MatrixNotifier>().consistRatio!.toStringAsFixed(4)}',
                //           style: context.watch<MatrixNotifier>().consistRatio! <
                //                   0.10
                //               ? TextStyle(
                //                   color: Colors.green,
                //                   fontSize: Theme.of(context)
                //                       .textTheme
                //                       .headline2!
                //                       .fontSize)
                //               : TextStyle(
                //                   color: Colors.red,
                //                   fontSize: Theme.of(context)
                //                       .textTheme
                //                       .headline2!
                //                       .fontSize),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
