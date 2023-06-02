import 'package:fahp/results/qfd_result.dart';
import 'package:fahp/services/qfd_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class QfdMethod extends StatefulWidget {
  final DefaultQfd step;
  const QfdMethod({
    super.key,
    this.step = DefaultQfd.customer,
  });

  @override
  State<QfdMethod> createState() => _QfdMethodState();
}

class _QfdMethodState extends State<QfdMethod> {
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
          SelectableText(
            'QFD',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 40,
            ),
          ),
          SelectableText(
            'House of Equality',
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
                  child: SelectableText('Enter number of Customer Nodes'),
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
                            content:
                                const SelectableText('Please input a number'),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
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
                        child:
                            SelectableText('Insert the customer requirement'),
                      ),
                      Table(
                        border: TableBorder.all(),
                        defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          /*const TableRow(children: [
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
                  child: SelectableText('Enter number of Technical Measures'),
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
                              content:
                                  const SelectableText('Please input a number'),
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
                        child: SelectableText('Insert the technical measures'),
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
                                          labelText: 'Requirement $i',
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
                                _engReq = false;
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
                              context.read<QfdNotifier>().initHouse();
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
                        child: SelectableText(
                            'Insert the value for each requirement'),
                      ),
                      Table(
                        border: TableBorder.all(),
                        // defaultColumnWidth: const IntrinsicColumnWidth(),
                        children: [
                          TableRow(
                            children: [
                              const TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SelectableText('Customer Nodes'),
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
                            questionMatrixRow(req, cusReq.indexOf(req), engReq)
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
                                _engReq = true;
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
                              context.read<QfdNotifier>().calculateHoE();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const QfdResult())));
                            },
                            child: const Text('Calculate'),
                          ),
                        ],
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ],
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
}
