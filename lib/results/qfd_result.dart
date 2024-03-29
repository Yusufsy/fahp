import 'package:fahp/homepage.dart';
import 'package:fahp/methods/default_qfd.dart';
import 'package:fahp/services/qfd_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QfdResult extends StatefulWidget {
  const QfdResult({super.key});

  @override
  State<QfdResult> createState() => _QfdResultState();
}

class _QfdResultState extends State<QfdResult> {
  final TextEditingController _numberQuestions = TextEditingController();
  bool _hoeResults = true;
  bool _engReq = false;
  bool _houseInput = false;

  @override
  Widget build(BuildContext context) {
    var engReq = context.watch<QfdNotifier>().engReq;
    var cusReq = context.watch<QfdNotifier>().cusReq;
    var weights = context.watch<QfdNotifier>().weights;
    var scales = context.watch<QfdNotifier>().scales;
    var sumWeights = weights.reduce((a, b) => a + b);
    var importance = context.watch<QfdNotifier>().importance;
    var percentages = context.watch<QfdNotifier>().percentages;
    var stepNotif = context.watch<QfdNotifier>().step;

    String house = 'House of Equality';
    String requirement = 'Technical Measures';
    String requirementCol = 'Parts Characteristics';
    switch (stepNotif) {
      case DefaultQfd.customer:
        setState(() {
          house = 'House of Equality';
          requirement = 'Customer Nodes';
          requirementCol = 'Technical Measures';
        });
        break;
      case DefaultQfd.technical:
        setState(() {
          house = 'Parts Deployment';
          requirement = 'Technical Measures';
          requirementCol = 'Parts Characteristics';
        });
        break;
      case DefaultQfd.parts:
        setState(() {
          house = 'Process Planning';
          requirement = 'Parts Characteristics';
          requirementCol = 'Process Operations';
        });
        break;
      case DefaultQfd.process:
        setState(() {
          house = 'Production Planning';
          requirement = 'Process Operations';
          requirementCol = 'Production requirements';
        });
        break;
      case DefaultQfd.production:
        break;
      default:
        break;
    }

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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SelectableText(
              'FQFD',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 40,
              ),
            ),
            SelectableText(
              house,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
              ),
            ),
            Visibility(
              visible: _hoeResults,
              child: _hoeResults
                  ? Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          child: SelectableText('Results'),
                        ),
                        Table(
                          border: TableBorder.all(),
                          // defaultColumnWidth: const IntrinsicColumnWidth(),
                          columnWidths: {
                            0: const FlexColumnWidth(1),
                            1: const FlexColumnWidth(1),
                            2: FlexColumnWidth(
                                double.parse(engReq.length.toString())),
                          },
                          children: [
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText(''),
                                  ),
                                ),
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText(''),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectableText(
                                      requirementCol,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Table(
                          border: TableBorder.all(),
                          // defaultColumnWidth: const IntrinsicColumnWidth(),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectableText(requirement),
                                  ),
                                ),
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('Weights'),
                                  ),
                                ),
                                for (String req in engReq)
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SelectableText(req),
                                    ),
                                  ),
                              ],
                            ),
                            for (String req in cusReq)
                              houseOfERow(req, weights[cusReq.indexOf(req)],
                                  scales[cusReq.indexOf(req)]),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('IMPORTANCE'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SelectableText(
                                        sumWeights.toStringAsFixed(2)),
                                  ),
                                ),
                                for (var im in importance)
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                          SelectableText(im.toStringAsFixed(3)),
                                    ),
                                  ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText(''),
                                  ),
                                ),
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText(''),
                                  ),
                                ),
                                for (var percent in percentages)
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SelectableText(
                                          '${(percent * 100).round().toString()}%'),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        stepNotif == DefaultQfd.production
                            ? const Offstage()
                            : Row(
                                children: [
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      if (stepNotif == DefaultQfd.process) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: ((context) =>
                                                  const MyHomePage()),
                                            ));
                                        context
                                            .read<QfdNotifier>()
                                            .updateStep(DefaultQfd.customer);
                                      } else {
                                        switch (stepNotif) {
                                          case DefaultQfd.customer:
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) =>
                                                      const DefaultQfdMethod(
                                                        step: DefaultQfd
                                                            .technical,
                                                      )),
                                                ));
                                            context
                                                .read<QfdNotifier>()
                                                .updateStep(
                                                    DefaultQfd.technical);
                                            break;
                                          case DefaultQfd.technical:
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) =>
                                                      const DefaultQfdMethod(
                                                        step: DefaultQfd.parts,
                                                      )),
                                                ));
                                            context
                                                .read<QfdNotifier>()
                                                .updateStep(DefaultQfd.parts);
                                            break;
                                          case DefaultQfd.parts:
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) =>
                                                      const DefaultQfdMethod(
                                                        step:
                                                            DefaultQfd.process,
                                                      )),
                                                ));
                                            context
                                                .read<QfdNotifier>()
                                                .updateStep(DefaultQfd.process);
                                            break;
                                          case DefaultQfd.process:
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: ((context) =>
                                                      const DefaultQfdMethod(
                                                        step: DefaultQfd
                                                            .production,
                                                      )),
                                                ));
                                            context
                                                .read<QfdNotifier>()
                                                .updateStep(
                                                    DefaultQfd.production);
                                            break;
                                          case DefaultQfd.production:
                                            break;
                                          default:
                                            break;
                                        }
                                      }
                                    },
                                    child: stepNotif == DefaultQfd.process
                                        ? const Text('Home')
                                        : const Text('Next stage'),
                                  ),
                                ],
                              ),
                      ],
                    )
                  : const SizedBox(),
            ),
            // Visibility(
            //   visible: _engReq,
            //   child: _engReq
            //       ? Column(
            //           children: [
            //             const Padding(
            //               padding: EdgeInsets.symmetric(vertical: 0.0),
            //               child: SelectableText('Insert the engineering requirements'),
            //             ),
            //             Table(
            //               border: TableBorder.all(),
            //               defaultColumnWidth: const IntrinsicColumnWidth(),
            //               children: [
            //                 for (int i = 1;
            //                     i <= int.parse(_numberQuestions.text);
            //                     i++)
            //                   TableRow(
            //                     children: [
            //                       TableCell(
            //                         child: Padding(
            //                           padding: const EdgeInsets.all(8.0),
            //                           child: SizedBox(
            //                             width:
            //                                 MediaQuery.of(context).size.width *
            //                                     0.5,
            //                             child: TextFormField(
            //                               autovalidateMode: AutovalidateMode
            //                                   .onUserInteraction,
            //                               decoration: InputDecoration(
            //                                 icon: const Icon(Icons.group),
            //                                 labelText: 'Requirement $i',
            //                               ),
            //                               validator: (value) {
            //                                 return value!.isEmpty
            //                                     ? 'Please fill this field'
            //                                     : null;
            //                               },
            //                               onChanged: (value) {
            //                                 if (value.isNotEmpty ||
            //                                     value != '') {
            //                                   context
            //                                       .read<QfdNotifier>()
            //                                       .setEngReq(i - 1, value);
            //                                 }
            //                               },
            //                             ),
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //               ],
            //             ),
            //             const SizedBox(
            //               height: 15.0,
            //             ),
            //             Row(
            //               children: [
            //                 const Spacer(),
            //                 TextButton(
            //                   onPressed: () {
            //                     setState(() {
            //                       _engReq = false;
            //                       _houseInput = true;
            //                     });
            //                   },
            //                   child: const SelectableText('Back'),
            //                 ),
            //                 const SizedBox(
            //                   width: 30.0,
            //                 ),
            //                 ElevatedButton(
            //                   onPressed: () {
            //                     context.read<QfdNotifier>().initHouse();
            //                     setState(() {
            //                       _engReq = false;
            //                       _houseInput = true;
            //                     });
            //                   },
            //                   child: const SelectableText('Next'),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         )
            //       : const SizedBox(),
            // ),
            // Visibility(
            //   visible: _houseInput,
            //   child: _houseInput
            //       ? Column(
            //           children: [
            //             const Padding(
            //               padding: EdgeInsets.symmetric(vertical: 0.0),
            //               child: SelectableText('Insert the value for each requirement'),
            //             ),
            //             Table(
            //               border: TableBorder.all(),
            //               // defaultColumnWidth: const IntrinsicColumnWidth(),
            //               children: [
            //                 TableRow(
            //                   children: [
            //                     const TableCell(
            //                       child: Padding(
            //                         padding: EdgeInsets.all(8.0),
            //                         child: SelectableText('Customer Requirements'),
            //                       ),
            //                     ),
            //                     const TableCell(
            //                       child: Padding(
            //                         padding: EdgeInsets.all(8.0),
            //                         child: SelectableText('Weights'),
            //                       ),
            //                     ),
            //                     for (String req in engReq)
            //                       TableCell(
            //                         child: Padding(
            //                           padding: const EdgeInsets.all(8.0),
            //                           child: SelectableText(req),
            //                         ),
            //                       ),
            //                   ],
            //                 ),
            //                 for (String req in cusReq)
            //                   questionMatrixRow(
            //                       req, cusReq.indexOf(req), engReq)
            //               ],
            //             ),
            //             const SizedBox(
            //               height: 15.0,
            //             ),
            //             Row(
            //               children: [
            //                 const Spacer(),
            //                 TextButton(
            //                   onPressed: () {
            //                     setState(() {
            //                       _engReq = true;
            //                       // _questionsMatrix = false;
            //                     });
            //                   },
            //                   child: const SelectableText('Back'),
            //                 ),
            //                 const SizedBox(
            //                   width: 30.0,
            //                 ),
            //                 ElevatedButton(
            //                   onPressed: () {
            //                     context.read<QfdNotifier>().calculateHoE();
            //                     // Navigator.push(
            //                     //     context,
            //                     //     MaterialPageRoute(
            //                     //         builder: ((context) =>
            //                     //             const FahpResult())));
            //                   },
            //                   child: const SelectableText('Calculate'),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         )
            //       : const SizedBox(),
            // ),
          ],
        ),
      ),
    );
  }

  TableRow questionMatrixRow(String cus, int cusIndex, List<String> numEng) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(cus),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'W',
              ),
              onChanged: (value) {
                if (value.isNotEmpty || value != '') {
                  context
                      .read<QfdNotifier>()
                      .setWeight(cusIndex, double.parse(value));
                }
              },
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                } else if (double.parse(value) >= 0 &&
                    double.parse(value) <= 1) {
                  return null;
                } else {
                  return 'Invalid value';
                }
              },
            ),
          ),
        ),
        for (String req in numEng)
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: 'Scale',
                ),
                onChanged: (value) {
                  if (value.isNotEmpty || value != '') {
                    context.read<QfdNotifier>().setScale(
                        cusIndex, numEng.indexOf(req), int.parse(value));
                  }
                },
                validator: (value) {
                  if (value == '0' ||
                      value == '1' ||
                      value == '3' ||
                      value == '9') {
                    return null;
                  } else {
                    return 'Invalid value';
                  }
                },
              ),
            ),
          ),
      ],
    );
  }

  TableRow houseOfERow(String cus, double weight, List<int> numEng) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(cus),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(weight.toStringAsFixed(3)),
          ),
        ),
        for (int req in numEng)
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(req.toString()),
            ),
          ),
      ],
    );
  }
}
