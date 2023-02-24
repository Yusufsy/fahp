import 'package:fahp/components/pairwaise_comp.dart';
import 'package:fahp/components/pairwise_row.dart';
import 'package:fahp/results/ahp_result.dart';
import 'package:fahp/services/expert_notifier.dart';
import 'package:fahp/services/matrix_notifier.dart';
import 'package:fahp/services/question_notifier.dart';
import 'package:fahp/utils/pairer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AhpMethod extends StatefulWidget {
  const AhpMethod({super.key});

  @override
  State<AhpMethod> createState() => _AhpMethodState();
}

class _AhpMethodState extends State<AhpMethod> {
  final TextEditingController _numberExperts = TextEditingController();
  final TextEditingController _numberQuestions = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  bool _numExperts = true;
  bool _numQuestions = false;
  bool _expertWeights = false;
  bool _questionsMatrix = false;
  bool _setInputCriteria = false;
  bool _numCriteriaInput = false;
  bool _criteriaTable = false;
  bool _crispNumbers = false;
  int _numCriteria = 0;
  final List<String> _criteria = [];
  List<List<String>> _pairs = [];
  final String _groupValue = 'Equal';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Text(
            'AHP',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 40,
            ),
          ),
          Visibility(
            visible: _numExperts,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: Text('Enter number of Experts'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.group),
                          labelText: 'No. of experts',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _numberExperts,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          return value!.isEmpty
                              ? 'Please fill this field'
                              : null;
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_numberExperts.text.isNotEmpty) {
                        context
                            .read<ExpertNotifier>()
                            .init(int.parse(_numberExperts.text));
                        setState(() {
                          _numExperts = false;
                          _expertWeights = true;
                          _numCriteriaInput = false;
                          _setInputCriteria = false;
                          _criteriaTable = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please input a number'),
                            backgroundColor: Theme.of(context).errorColor,
                          ),
                        );
                      }
                    },
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _expertWeights,
            child: _expertWeights
                ? Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: Text('The experts weight reflects the expert’s years of experience or his/her knowledge. “If experts have the same weight, please keep this field blank”'),
                      ),
                      Table(
                        border: TableBorder.all(),
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          const TableRow(children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Expert'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Weight'),
                              ),
                            ),
                          ]),
                          for (int i = 1;
                              i <= int.parse(_numberExperts.text);
                              i++)
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('ΔE$i'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          labelText: 'Weight of ΔE$i',
                                        ),
                                        // inputFormatters: [
                                        //   FilteringTextInputFormatter.digitsOnly
                                        // ],
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        onChanged: (value) {
                                          if (value.isNotEmpty || value != '') {
                                            context
                                                .read<ExpertNotifier>()
                                                .setWeight(
                                                    i - 1, double.parse(value));
                                          }
                                        },
                                        validator: (value) {
                                          if (value!.isNotEmpty) {
                                            if (double.parse(value) < 0.0 ||
                                                double.parse(value) > 1.0) {
                                              return 'Between 0-1';
                                            }
                                          }
                                          return value.isEmpty
                                              ? 'Please fill this field'
                                              : null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _numExperts = true;
                                _expertWeights = false;
                              });
                            },
                            child: const Text('Back'),
                          ),
                          const SizedBox(
                            width: 30.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _expertWeights = false;
                                _numQuestions = true;
                              });
                            },
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          Visibility(
            visible: _numQuestions,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('Enter number of Pairwise Comparison Matrices (PCMs)'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.question_mark),
                      labelText: 'No. of Pairwise Comparison Matrices (PCMs)',
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: _numberQuestions,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      return value!.isEmpty ? 'Please fill this field' : null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _expertWeights = true;
                          _numQuestions = false;
                        });
                      },
                      child: const Text('Back'),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_numberQuestions.text.isNotEmpty) {
                          context.read<QuestionNotifier>().init(
                              int.parse(_numberQuestions.text),
                              context.read<ExpertNotifier>().expertWi!.length);
                          setState(() {
                            _numQuestions = false;
                            _questionsMatrix = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please input a number'),
                              backgroundColor: Theme.of(context).errorColor,
                            ),
                          );
                        }
                      },
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: _questionsMatrix,
            child: _questionsMatrix
                ? Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: Text('Insert the matrix of each Pairwise Comparison Matrices (PCMs)'),
                      ),
                      Table(
                        border: TableBorder.all(),
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          const TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Q'),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Matrix'),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Criteria'),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('With respect to'),
                                ),
                              ),
                            ],
                          ),
                          for (int i = 0;
                              i < int.parse(_numberQuestions.text);
                              i++)
                            questionMatrixRow(i)
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _numQuestions = true;
                                _questionsMatrix = false;
                              });
                            },
                            child: const Text('Back'),
                          ),
                          const SizedBox(
                            width: 30.0,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<QuestionNotifier>().generatePairs();
                              setState(() {
                                _questionsMatrix = false;
                                _criteriaTable = true;
                              });
                            },
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          // Visibility(
          //   visible: _numCriteriaInput,
          //   child: Column(
          //     children: [
          //       const Padding(
          //         padding: EdgeInsets.symmetric(vertical: 0.0),
          //         child: Text('Select number of  Criteria'),
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           SizedBox(
          //             width: MediaQuery.of(context).size.width * 0.5,
          //             child: TextFormField(
          //               autovalidateMode: AutovalidateMode.onUserInteraction,
          //               decoration: const InputDecoration(
          //                 icon: Icon(Icons.location_city),
          //                 labelText: 'Input from (2-20)',
          //               ),
          //               inputFormatters: [
          //                 FilteringTextInputFormatter.digitsOnly
          //               ],
          //               controller: _numberController,
          //               keyboardType: TextInputType.number,
          //               validator: (value) {
          //                 if (value!.isNotEmpty) {
          //                   if (int.parse(value) < 2 || int.parse(value) > 20) {
          //                     return 'number must be between 2-20';
          //                   }
          //                 }
          //                 return value.isEmpty
          //                     ? 'Please fill this field'
          //                     : null;
          //               },
          //             ),
          //           ),
          //           Row(
          //             children: [
          //               // const Spacer(),
          //               TextButton(
          //                 onPressed: () {
          //                   setState(() {
          //                     _numCriteriaInput = false;
          //                     _questionsMatrix = true;
          //                   });
          //                 },
          //                 child: const Text('Back'),
          //               ),
          //               const SizedBox(
          //                 width: 30.0,
          //               ),
          //               ElevatedButton(
          //                 onPressed: () {
          //                   if (_numberController.text.isNotEmpty) {
          //                     setState(() {
          //                       _numCriteria =
          //                           int.parse(_numberController.text);
          //                       _numCriteriaInput = false;
          //                       _setInputCriteria = true;
          //                       _criteriaTable = false;
          //                     });
          //                   } else {
          //                     ScaffoldMessenger.of(context).showSnackBar(
          //                       SnackBar(
          //                         content: const Text('Please input a number'),
          //                         backgroundColor: Theme.of(context).errorColor,
          //                       ),
          //                     );
          //                   }
          //                 },
          //                 child: const Text('Next'),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.5,
          //   child: Visibility(
          //     visible: _setInputCriteria,
          //     child: Column(children: [
          //       const Padding(
          //         padding: EdgeInsets.symmetric(vertical: 0.0),
          //         child: Text('Input name of Criteria'),
          //       ),
          //       for (int i = 0; i < _numCriteria; i++)
          //         TextFormField(
          //           decoration: InputDecoration(labelText: 'Criteria ${i + 1}'),
          //           onChanged: (value) {
          //             if (_criteria.isEmpty) {
          //               setState(() {
          //                 _criteria.add(value);
          //               });
          //             } else if (_criteria.length <= i) {
          //               setState(() {
          //                 _criteria.add(value);
          //               });
          //             } else {
          //               setState(() {
          //                 _criteria[i] = value;
          //               });
          //             }
          //           },
          //         ),
          //       const SizedBox(
          //         height: 15.0,
          //       ),
          //       Row(
          //         children: [
          //           const Spacer(),
          //           TextButton(
          //             onPressed: () {
          //               setState(() {
          //                 _setInputCriteria = !_setInputCriteria;
          //                 _numCriteriaInput = !_numCriteriaInput;
          //                 _criteriaTable = false;
          //               });
          //             },
          //             child: const Text('Back'),
          //           ),
          //           const SizedBox(
          //             width: 30.0,
          //           ),
          //           ElevatedButton(
          //             onPressed: () {
          //               _pairs = Pairer().paiarCriteria(_criteria);
          //               print(_pairs);
          //               context
          //                   .read<MatrixNotifier>()
          //                   .updateCriteria(_criteria, _pairs);
          //               setState(() {
          //                 _setInputCriteria = !_setInputCriteria;
          //                 _numCriteriaInput = false;
          //                 _criteriaTable = !_criteriaTable;
          //               });
          //             },
          //             child: const Text('OK'),
          //           ),
          //         ],
          //       ),
          //     ]),
          //   ),
          // ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Visibility(
              visible: _criteriaTable,
              child: _criteriaTable
                  ? Column(
                      children: [
                        for (int i = 1;
                            i <=
                                context
                                    .watch<ExpertNotifier>()
                                    .expertWi!
                                    .length;
                            i++)
                          PairWiseComp(
                            exIndex: i,
                          ),
                        // for (List<List<String>> criterias in context
                        //     .watch<QuestionNotifier>()
                        //     .pairsGen
                        //     .values
                        //     .toList())
                        //   Column(
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: RichText(
                        //           text: TextSpan(
                        //               text: 'With respect to ',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .bodyMedium,
                        //               children: [
                        //                 TextSpan(
                        //                   text: context
                        //                           .watch<QuestionNotifier>()
                        //                           .wrt![
                        //                       context
                        //                           .watch<QuestionNotifier>()
                        //                           .pairsGen
                        //                           .values
                        //                           .toList()
                        //                           .indexOf(criterias)],
                        //                   style: Theme.of(context)
                        //                       .textTheme
                        //                       .titleLarge,
                        //                 ),
                        //                 TextSpan(
                        //                   text:
                        //                       ', which of the following criterion is more important? and by how much is more?',
                        //                   style: Theme.of(context)
                        //                       .textTheme
                        //                       .bodyMedium,
                        //                 ),
                        //               ]),
                        //         ),
                        //       ),
                        //       for (List<String> criteria in criterias)
                        //         PairWiseRow(
                        //             qIndex: context
                        //                 .watch<QuestionNotifier>()
                        //                 .wrt!
                        //                 .indexOf(context
                        //                         .watch<QuestionNotifier>()
                        //                         .wrt![
                        //                     context
                        //                         .watch<QuestionNotifier>()
                        //                         .pairsGen
                        //                         .values
                        //                         .toList()
                        //                         .indexOf(criterias)]),
                        //             criteria: criteria,
                        //             index: criterias.indexOf(criteria)),
                        //     ],
                        //   ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _criteriaTable = !_criteriaTable;
                                  _questionsMatrix = !_questionsMatrix;
                                });
                              },
                              child: const Text('Back'),
                            ),
                            const SizedBox(
                              width: 30.0,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<QuestionNotifier>()
                                    .calculatePriorities();
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              const AhpResult())));
                                });
                              },
                              child: const Text('Calculate'),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  TableRow questionMatrixRow(int q) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${q + 1}'),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (context.read<QuestionNotifier>().questionMatrix![q] >
                        2) {
                      setState(() {
                        context.read<QuestionNotifier>().setMatrix(
                            q,
                            context
                                    .read<QuestionNotifier>()
                                    .questionMatrix![q] -
                                1);
                      });
                    }
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text('${context.read<QuestionNotifier>().questionMatrix![q]}'),
                IconButton(
                  onPressed: () {
                    if (context.read<QuestionNotifier>().questionMatrix![q] <=
                        20) {
                      setState(() {
                        context.read<QuestionNotifier>().setMatrix(
                            q,
                            context
                                    .read<QuestionNotifier>()
                                    .questionMatrix![q] +
                                1);
                      });
                    }
                  },
                  icon: const Icon(Icons.add_outlined),
                ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                for (int i = 0;
                    i < context.read<QuestionNotifier>().questionMatrix![q];
                    i++)
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Criteria $i',
                      ),
                      onChanged: (value) {
                        context
                            .read<QuestionNotifier>()
                            .setCriteria(q, i, value);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 150,
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: 'Criteria',
                ),
                onChanged: (value) {
                  context.read<QuestionNotifier>().setWrt(q, value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
