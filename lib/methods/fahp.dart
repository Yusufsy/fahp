import 'package:fahp/components/pairwaise_comp.dart';
import 'package:fahp/results/fahp_result.dart';
import 'package:fahp/services/expert_notifier.dart';
import 'package:fahp/services/question_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FahpMethod extends StatefulWidget {
  const FahpMethod({super.key});

  @override
  State<FahpMethod> createState() => _FahpMethodState();
}

class _FahpMethodState extends State<FahpMethod> {
  // final TextEditingController _numberExperts = TextEditingController();
  final TextEditingController _numberQuestions = TextEditingController();
  // bool _numExperts = false;
  bool _numQuestions = true;
  // bool _expertWeights = false;
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
          Text(
            'FAHP',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 40,
            ),
          ),
          Visibility(
            visible: _numQuestions,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                      'Enter number of Pairwise Comparison Matrices (PCMs)'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.question_mark),
                      labelText:
                          'Number of Pairwise Comparison Matrices (PCMs)',
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
                    // TextButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       _expertWeights = true;
                    //       _numQuestions = false;
                    //     });
                    //   },
                    //   child: const Text('Back'),
                    // ),
                    // const SizedBox(
                    //   width: 30.0,
                    // ),
                    ElevatedButton(
                      onPressed: () {
                        if (_numberQuestions.text.isNotEmpty) {
                          context.read<ExpertNotifier>().init(1);
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
                        child: Text('Insert the matrix of each question'),
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
                                  child: Text('Crit'),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('WRT'),
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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Visibility(
              visible: _criteriaTable,
              child: _criteriaTable
                  ? Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Saaty\'s scale'),
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
                                    child: Text('AHP Saaty (1980)'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Explanation'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('1'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Equal Importance'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('3'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Moderate Importance'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('5'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Strong Importance'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('7'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Very Strong Importance'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('9'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Extremely Important'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('2'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Equally to Moderately'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('4'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Moderately to Strongly'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('6'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Strongly to very strong'),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('8'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Very strong to extremely'),
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
                                              const FahpResult())));
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
