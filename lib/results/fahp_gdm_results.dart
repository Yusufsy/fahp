import 'package:fahp/services/expert_notifier.dart';
import 'package:fahp/services/matrix_notifier.dart';
import 'package:fahp/services/question_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FahpGdmResult extends StatefulWidget {
  const FahpGdmResult({super.key});

  @override
  State<FahpGdmResult> createState() => _FahpGdmResultState();
}

class _FahpGdmResultState extends State<FahpGdmResult> {
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
    final exMatrix = context.watch<QuestionNotifier>().exQuestionMatrixMap;
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
                    'FAHP GDM RESULTS',
                    style: topicStyle,
                  ),
                ),
                // for (int i = 0; i < exMatrix.length; i++)
                Column(
                  children: [
                    Text(
                      "Collective Judgement Matrix",
                      style: topicStyle,
                    ),
                    for (var qMatrix in qMatrices.values)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'Question ${qMatrices.values.toList().indexOf(qMatrix) + 1}',
                              style: subTopicStyle,
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
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 50,
                                                child: rows == 1 || rows == 9
                                                    ? Text(
                                                        "${rows.toStringAsFixed(2)} ")
                                                    : Text(
                                                        "${(rows - 1).toStringAsFixed(2)} "),
                                              ),
                                              SizedBox(
                                                  width: 50,
                                                  child: Text(
                                                      "${rows.toStringAsFixed(2)} ")),
                                              rows == 1 || rows == 9
                                                  ? Text(
                                                      rows.toStringAsFixed(2))
                                                  : Text((rows + 1)
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
                            child: Text(
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
                                  defaultColumnWidth:
                                      const IntrinsicColumnWidth(),
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
                                            child: Text('Fuzzy RGM'),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Fuzzy Weight'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    for (String criteria in qMatrix)
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(criteria),
                                            ),
                                          ),
                                          // for (int i = 0; i < qMatrix.length; i++)
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  allPriorities[qMatrix]![
                                                          qMatrix.indexOf(
                                                              criteria)]
                                                      .toStringAsFixed(4)),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(allWeights[qMatrix]![
                                                      qMatrix.indexOf(criteria)]
                                                  .toStringAsFixed(4)),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                                Table(
                                  defaultColumnWidth:
                                      const IntrinsicColumnWidth(),
                                  children: [
                                    const TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('GCI'),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('CR'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(context
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
                                          child: Text(
                                            context
                                                .watch<QuestionNotifier>()
                                                .cr[qMatrices.values
                                                    .toList()
                                                    .indexOf(qMatrix)]
                                                .toStringAsFixed(4),
                                            style: TextStyle(
                                                color: context
                                                                    .watch<
                                                                        QuestionNotifier>()
                                                                    .cr[
                                                                qMatrices.values
                                                                    .toList()
                                                                    .indexOf(
                                                                        qMatrix)] *
                                                            100 >
                                                        10.00
                                                    ? Colors.red
                                                    : Colors.green),
                                          ),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
