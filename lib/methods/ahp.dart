import 'package:fahp/components/pairwise_row.dart';
import 'package:fahp/results/ahp_result.dart';
import 'package:fahp/services/matrix_notifier.dart';
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
  final TextEditingController _numberController = TextEditingController();
  bool _setInputCriteria = false;
  bool _numCriteriaInput = true;
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
            visible: _numCriteriaInput,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: Text('Select number of  Criteria'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.location_city),
                          labelText: 'Input from (2-20)',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _numberController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            if (int.parse(value) < 2 || int.parse(value) > 20) {
                              return 'number must be between 2-20';
                            }
                          }
                          return value.isEmpty
                              ? 'Please fill this field'
                              : null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_numberController.text.isNotEmpty) {
                          setState(() {
                            _numCriteria = int.parse(_numberController.text);
                            _numCriteriaInput = false;
                            _setInputCriteria = true;
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
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Visibility(
              visible: _setInputCriteria,
              child: Column(children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: Text('Input name of Criteria'),
                ),
                for (int i = 0; i < _numCriteria; i++)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Criteria ${i + 1}'),
                    onChanged: (value) {
                      if (_criteria.isEmpty) {
                        setState(() {
                          _criteria.add(value);
                        });
                      } else if (_criteria.length <= i) {
                        setState(() {
                          _criteria.add(value);
                        });
                      } else {
                        setState(() {
                          _criteria[i] = value;
                        });
                      }
                    },
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
                          _setInputCriteria = !_setInputCriteria;
                          _numCriteriaInput = !_numCriteriaInput;
                          _criteriaTable = false;
                        });
                      },
                      child: const Text('Back'),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _pairs = Pairer().paiarCriteria(_criteria);
                        print(_pairs);
                        context
                            .read<MatrixNotifier>()
                            .updateCriteria(_criteria, _pairs);
                        setState(() {
                          _setInputCriteria = !_setInputCriteria;
                          _numCriteriaInput = false;
                          _criteriaTable = !_criteriaTable;
                        });
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ]),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Visibility(
              visible: _criteriaTable,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text('Pairwise Comparison'),
                  ),
                  for (List<String> criteria in _pairs)
                    PairWiseRow(
                        criteria: criteria, index: _pairs.indexOf(criteria)),
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
                            _setInputCriteria = !_setInputCriteria;
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => const AhpResult())));
                          });
                        },
                        child: const Text('Calculate'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
