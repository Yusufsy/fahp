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
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          SelectableText(
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
                  child: SelectableText('Enter the number of Experts'),
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
                            content:
                                const SelectableText('Please input a number'),
                            backgroundColor: Theme.of(context).errorColor,
                          ),
                        );
                      }
                    },
                    child: const SelectableText('Next'),
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
                        child: SelectableText(
                            'The experts weight reflects the expert’s years of experience or his/her knowledge. “If experts have the same weight, please keep this field blank”'),
                      ),
                      Table(
                        border: TableBorder.all(),
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          const TableRow(children: [
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SelectableText('Expert'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SelectableText('Weight'),
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
                                    child: SelectableText('ΔE$i'),
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
                            child: const SelectableText('Back'),
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
                            child: const SelectableText('Next'),
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
                  child: SelectableText(
                      'Enter number of Pairwise Comparison Matrices (PCMs)'),
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
                      child: const SelectableText('Back'),
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
                              content:
                                  const SelectableText('Please input a number'),
                              backgroundColor: Theme.of(context).errorColor,
                            ),
                          );
                        }
                      },
                      child: const SelectableText('Next'),
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
                        child: SelectableText(
                            'Insert the matrix of each Pairwise Comparison Matrices (PCMs)'),
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
                                  child: SelectableText('Q'),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SelectableText('Matrix'),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SelectableText('Criteria'),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SelectableText('With respect to'),
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
                            child: const SelectableText('Back'),
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
                            child: const SelectableText('Next'),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Visibility(
              visible: _criteriaTable,
              child: _criteriaTable
                  ? Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: SelectableText('Saaty\'s scale'),
                        ),
                        Table(
                          border: TableBorder.all(),
                          defaultColumnWidth:
                              FixedColumnWidth(size.width * 0.3),
                          children: const [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('AHP Saaty (1980)'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('Explanation'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('1'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('Equal Importance'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('3'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child:
                                        SelectableText('Moderate Importance'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('5'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('Strong Importance'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('7'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText(
                                        'Very Strong Importance'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('9'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child:
                                        SelectableText('Extremely Important'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('2'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child:
                                        SelectableText('Equally to Moderately'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('4'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText(
                                        'Moderately to Strongly'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('6'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText(
                                        'Strongly to very strong'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText('8'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: SelectableText(
                                        'Very strong to extremely'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                              child: const SelectableText('Back'),
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
                              child: const SelectableText('Calculate'),
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
            child: SelectableText('${q + 1}'),
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
                SelectableText(
                    '${context.read<QuestionNotifier>().questionMatrix![q]}'),
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
