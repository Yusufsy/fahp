import 'package:fahp/services/matrix_notifier.dart';
import 'package:fahp/services/question_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FahpResult extends StatefulWidget {
  const FahpResult({super.key});

  @override
  State<FahpResult> createState() => _FahpResultState();
}

class _FahpResultState extends State<FahpResult> {
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
            SelectableText("LOGO"),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: SelectableText("Consensus AHP Online Calculator"),
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
                  child: SelectableText(
                    'FAHP RESULTS',
                    style: topicStyle,
                  ),
                ),
                for (var qMatrix in qMatrices.values)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SelectableText(
                          'Question ${qMatrices.values.toList().indexOf(qMatrix) + 1}',
                          style: topicStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SelectableText(
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
                                    child: SelectableText(' '),
                                  ),
                                ),
                                for (String criteria in qMatrix)
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SelectableText(criteria),
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
                                      child: SelectableText(criteria),
                                    ),
                                  ),
                                  for (var rows in allMatrices[qMatrix]![
                                      qMatrix.indexOf(criteria)])
                                    TableCell(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 50,
                                            child: rows == 1 || rows == 9
                                                ? SelectableText(
                                                    "${rows.toStringAsFixed(2)} ")
                                                : SelectableText(
                                                    "${(rows - 1).toStringAsFixed(2)} "),
                                          ),
                                          SizedBox(
                                              width: 50,
                                              child: SelectableText(
                                                  "${rows.toStringAsFixed(2)} ")),
                                          rows == 1 || rows == 9
                                              ? SelectableText(
                                                  rows.toStringAsFixed(2))
                                              : SelectableText((rows + 1)
                                                  .toStringAsFixed(2)),
                                        ],
                                      ),
                                    )),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: SelectableText(
                          'Calculations',
                          style: subTopicStyle,
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Table(
                              border: TableBorder.all(),
                              defaultColumnWidth: const IntrinsicColumnWidth(),
                              children: [
                                const TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SelectableText(' '),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SelectableText('RGM'),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SelectableText('Weight'),
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
                                          child: SelectableText(criteria),
                                        ),
                                      ),
                                      // for (int i = 0; i < qMatrix.length; i++)
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SelectableText(
                                              allPriorities[qMatrix]![
                                                      qMatrix.indexOf(criteria)]
                                                  .toStringAsFixed(4)),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SelectableText(
                                              allWeights[qMatrix]![
                                                      qMatrix.indexOf(criteria)]
                                                  .toStringAsFixed(4)),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            Table(
                              defaultColumnWidth: const IntrinsicColumnWidth(),
                              children: [
                                const TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SelectableText('GCI'),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SelectableText('CR'),
                                      ),
                                    ),
                                  ],
                                ),
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: SelectableText(context
                                          .watch<QuestionNotifier>()
                                          .gci[qMatrices.values
                                              .toList()
                                              .indexOf(qMatrix)]
                                          .toStringAsFixed(4)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: SelectableText(context
                                          .watch<QuestionNotifier>()
                                          .cr[qMatrices.values
                                              .toList()
                                              .indexOf(qMatrix)]
                                          .toStringAsFixed(4)),
                                    ),
                                  ),
                                ])
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
