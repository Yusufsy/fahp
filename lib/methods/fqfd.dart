import 'package:fahp/components/pairwaise_comp.dart';
import 'package:fahp/results/fahp_result.dart';
import 'package:fahp/services/expert_notifier.dart';
import 'package:fahp/services/qfd_notifier.dart';
import 'package:fahp/services/question_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FqfdMethod extends StatefulWidget {
  const FqfdMethod({super.key});

  @override
  State<FqfdMethod> createState() => _FqfdMethodState();
}

class _FqfdMethodState extends State<FqfdMethod> {
  final TextEditingController _numberExperts = TextEditingController();
  final TextEditingController _numberQuestions = TextEditingController();
  bool _numExperts = true;
  bool _numQuestions = false;
  bool _expertWeights = false;
  bool _questionsMatrix = false;
  bool _engReq = false;
  bool _numCriteriaInput = false;
  bool _criteriaTable = false;
  bool _crispNumbers = false;
  int _numCriteria = 0;
  final List<String> _criteria = [];
  List<List<String>> _pairs = [];
  final String _groupValue = 'Equal';
  @override
  Widget build(BuildContext context) {
    var engReq = context.watch<QfdNotifier>().engReq;
    var cusReq = context.watch<QfdNotifier>().cusReq;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Text(
            'FQFD',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 40,
            ),
          ),
          Text(
            'First House of Equality',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
            ),
          ),
          Visibility(
            visible: _numExperts,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: Text('Enter number of Customer Requirements'),
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
                          labelText: 'No. of requirements',
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
                            .read<QfdNotifier>()
                            .setNumCusReq(int.parse(_numberExperts.text));
                        setState(() {
                          _numExperts = false;
                          _expertWeights = true;
                          _numCriteriaInput = false;
                          _engReq = false;
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
                        child: Text('Insert the customer requirement'),
                      ),
                      Table(
                        border: TableBorder.all(),
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          /*const TableRow(children: [
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
                          ]),*/
                          for (int i = 1;
                              i <= int.parse(_numberExperts.text);
                              i++)
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          icon: const Icon(Icons.group),
                                          labelText: 'Requirements $i',
                                        ),

                                        //controller: _numberExperts,
                                        //keyboardType: TextInputType.number,
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? 'Please fill this field'
                                              : null;
                                        },
                                        onChanged: (value) {
                                          if (value.isNotEmpty || value != '') {
                                            context
                                                .read<QfdNotifier>()
                                                .setCusReq(i - 1, value);
                                          }
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
                  child: Text('Enter number of Engineering Requirements'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.question_mark),
                      labelText: 'No. of requirements',
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
                          context
                              .read<QfdNotifier>()
                              .setNumEngReq(int.parse(_numberQuestions.text));
                          setState(() {
                            _numQuestions = false;
                            _questionsMatrix = false;
                            _engReq = true;
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
            visible: _engReq,
            child: _engReq
                ? Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: Text('Insert the engineering requirements'),
                      ),
                      Table(
                        border: TableBorder.all(),
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          for (int i = 1;
                              i <= int.parse(_numberQuestions.text);
                              i++)
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          icon: const Icon(Icons.group),
                                          labelText: 'Requirements $i',
                                        ),
                                        validator: (value) {
                                          return value!.isEmpty
                                              ? 'Please fill this field'
                                              : null;
                                        },
                                        onChanged: (value) {
                                          if (value.isNotEmpty || value != '') {
                                            context
                                                .read<QfdNotifier>()
                                                .setEngReq(i - 1, value);
                                          }
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
                                _expertWeights = false;
                                _numQuestions = true;
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
                                _engReq = false;
                                _numQuestions = false;
                                _questionsMatrix = true;
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
            visible: _questionsMatrix,
            child: _questionsMatrix
                ? Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        child: Text('Insert the value for each requirment'),
                      ),
                      Table(
                        border: TableBorder.all(),
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          TableRow(
                            children: [
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Customer Requirements'),
                                ),
                              ),
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Weights'),
                                ),
                              ),
                              for (String req in engReq)
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(req),
                                  ),
                                ),
                            ],
                          ),
                          for (String req in cusReq)
                            questionMatrixRow(req, engReq)
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
                          // const SizedBox(
                          //   width: 30.0,
                          // ),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     context.read<QuestionNotifier>().generatePairs();
                          //     setState(() {
                          //       _questionsMatrix = false;
                          //       _criteriaTable = true;
                          //     });
                          //   },
                          //   child: const Text('Next'),
                          // ),
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

  TableRow questionMatrixRow(String cus, List<String> numEng) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(cus),
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
                // context.read<QuestionNotifier>().setWrt(q, value);
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
                  // context.read<QuestionNotifier>().setWrt(q, value);
                },
              ),
            ),
          ),
      ],
    );
  }
}
