import 'package:fahp/services/expert_notifier.dart';
import 'package:fahp/services/question_notifier.dart';
import 'package:flutter/material.dart';
import 'package:fraction/fraction.dart';
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
    final allPriorities = context.watch<ExpertNotifier>().allPriorities;
    final allWeights = context.watch<ExpertNotifier>().allWeights;
    final cjmMatrix = context.watch<ExpertNotifier>().cjmMatrix;
    final crispWi = context.watch<ExpertNotifier>().crispWeights;
    final normalWi = context.watch<ExpertNotifier>().normalWeights;
    final gci = context.watch<ExpertNotifier>().gci;
    final cr = context.watch<ExpertNotifier>().cr;
    final expertNotifier = context.watch<ExpertNotifier>();
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
                    'FAHP GDM RESULTS',
                    style: topicStyle,
                  ),
                ),
                // for (int i = 0; i < exMatrix.length; i++)
                Column(
                  children: [
                    SelectableText(
                      "Collective Judgement Matrix",
                      style: topicStyle,
                    ),
                    for (var qMatrix in qMatrices.values)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: SelectableText(
                              'Question ${qMatrices.values.toList().indexOf(qMatrix) + 1}',
                              style: subTopicStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: SelectableText(
                              ' ',
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
                                          child: SelectableText(criteria,
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                  ],
                                ),
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
                                          child: Row(
                                            children: const [
                                              SizedBox(
                                                width: 70,
                                                child: SelectableText(
                                                  'l',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 70,
                                                child: SelectableText(
                                                  'm',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 70,
                                                child: SelectableText(
                                                  'u',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
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
                                      for (var row = 0;
                                          row <
                                              cjmMatrix['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                          'l']![
                                                      qMatrix.indexOf(criteria)]
                                                  .length;
                                          row++)
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 70,
                                                  child: SelectableText(
                                                    expertNotifier.expertWi!
                                                                .length <=
                                                            1
                                                        ? Fraction.fromDouble(
                                                                cjmMatrix['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']!['l']![
                                                                        qMatrix.indexOf(criteria)]
                                                                    [row])
                                                            .toString()
                                                        : cjmMatrix['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                                    'l']![
                                                                qMatrix.indexOf(
                                                                    criteria)][row]
                                                            .toStringAsFixed(4),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 70,
                                                  child: SelectableText(
                                                    expertNotifier.expertWi!
                                                                .length <=
                                                            1
                                                        ? Fraction.fromDouble(
                                                                cjmMatrix['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']!['m']![
                                                                        qMatrix.indexOf(criteria)]
                                                                    [row])
                                                            .toString()
                                                        : cjmMatrix['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                                    'm']![
                                                                qMatrix.indexOf(
                                                                    criteria)][row]
                                                            .toStringAsFixed(4),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 70,
                                                  child: SelectableText(
                                                    expertNotifier.expertWi!
                                                                .length <=
                                                            1
                                                        ? Fraction.fromDouble(
                                                                cjmMatrix['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']!['u']![
                                                                        qMatrix.indexOf(criteria)]
                                                                    [row])
                                                            .toString()
                                                        : cjmMatrix['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                                    'u']![
                                                                qMatrix.indexOf(
                                                                    criteria)][row]
                                                            .toStringAsFixed(4),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
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
                                  defaultColumnWidth:
                                      const IntrinsicColumnWidth(),
                                  children: [
                                    TableRow(
                                      children: [
                                        const TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SelectableText(' '),
                                          ),
                                        ),
                                        const TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SelectableText(
                                              'Fuzzy RGM',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        const TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SelectableText(
                                              'Fuzzy Weight',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: Colors.green,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: SelectableText(
                                                'Crisp Weight',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: Colors.green,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: SelectableText(
                                                'Normal Weight',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SelectableText(' '),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: const [
                                                SizedBox(
                                                  width: 70,
                                                  child: SelectableText(
                                                    'l',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 70,
                                                  child: SelectableText(
                                                    'm',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 70,
                                                  child: SelectableText(
                                                    'u',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              children: const [
                                                SizedBox(
                                                  width: 70,
                                                  child: SelectableText(
                                                    'l',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 70,
                                                  child: SelectableText(
                                                    'm',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 70,
                                                  child: SelectableText(
                                                    'u',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: Colors.green,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: SelectableText(' '),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            color: Colors.green,
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: SelectableText(' '),
                                            ),
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
                                              child: SelectableText(criteria),
                                            ),
                                          ),
                                          // for (int i = 0; i < qMatrix.length; i++)
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 70,
                                                    child: SelectableText(
                                                      allPriorities['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                                  'l']![
                                                              qMatrix.indexOf(
                                                                  criteria)]
                                                          .toStringAsFixed(4),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 70,
                                                    child: SelectableText(
                                                      allPriorities['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                                  'm']![
                                                              qMatrix.indexOf(
                                                                  criteria)]
                                                          .toStringAsFixed(4),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 70,
                                                    child: SelectableText(
                                                      allPriorities['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                                  'u']![
                                                              qMatrix.indexOf(
                                                                  criteria)]
                                                          .toStringAsFixed(4),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 70,
                                                    child: SelectableText(
                                                      allWeights['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                                  'l']![
                                                              qMatrix.indexOf(
                                                                  criteria)]
                                                          .toStringAsFixed(4),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 70,
                                                    child: SelectableText(
                                                      allWeights['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                                  'm']![
                                                              qMatrix.indexOf(
                                                                  criteria)]
                                                          .toStringAsFixed(4),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 70,
                                                    child: SelectableText(
                                                      allWeights['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                                  'u']![
                                                              qMatrix.indexOf(
                                                                  criteria)]
                                                          .toStringAsFixed(4),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              color: Colors.green,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SelectableText(
                                                  crispWi['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                          qMatrix.indexOf(
                                                              criteria)]
                                                      .toStringAsFixed(4),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              color: Colors.green,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SelectableText(
                                                  normalWi['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']![
                                                          qMatrix.indexOf(
                                                              criteria)]
                                                      .toStringAsFixed(4),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
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
                                          child: SelectableText(
                                              gci['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']!
                                                  .toStringAsFixed(4)),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: SelectableText(
                                            '${(cr['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']! * 100).toStringAsFixed(2)}%',
                                            style: TextStyle(
                                                color:
                                                    cr['q${qMatrices.values.toList().indexOf(qMatrix) + 1}']! *
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
