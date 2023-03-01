import 'package:fahp/services/qfd_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QfdResult extends StatefulWidget {
  const QfdResult({super.key});

  @override
  State<QfdResult> createState() => _QfdResultState();
}

class _QfdResultState extends State<QfdResult> {
  final TextEditingController _numberExperts = TextEditingController();
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
      body: Container(
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
              'House of Equality',
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
                          child: Text('Results'),
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
                              houseOfERow(req, weights[cusReq.indexOf(req)],
                                  scales[cusReq.indexOf(req)]),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('IMPORTANCE'),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(sumWeights.toStringAsFixed(2)),
                                  ),
                                ),
                                for (var im in importance)
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(im.toStringAsFixed(3)),
                                    ),
                                  ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(''),
                                  ),
                                ),
                                const TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(''),
                                  ),
                                ),
                                for (var percent in percentages)
                                  TableCell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
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
                        Row(
                          children: [
                            const Spacer(),
                            // TextButton(
                            //   onPressed: () {
                            //     setState(() {
                            //       _hoeResults = false;
                            //       _engReq = true;
                            //     });
                            //   },
                            //   child: const Text('Add stage'),
                            // ),
                            // const SizedBox(
                            //   width: 30.0,
                            // ),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     context.read<QfdNotifier>().calculateHoE();
                            //     // Navigator.push(
                            //     //     context,
                            //     //     MaterialPageRoute(
                            //     //         builder: ((context) =>
                            //     //             const FahpResult())));
                            //   },
                            //   child: const Text('Calculate'),
                            // ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
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
                                            if (value.isNotEmpty ||
                                                value != '') {
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
                                  _engReq = false;
                                  _houseInput = true;
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
                                  _houseInput = true;
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
              visible: _houseInput,
              child: _houseInput
                  ? Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          child: Text('Insert the value for each requirement'),
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
                              questionMatrixRow(
                                  req, cusReq.indexOf(req), engReq)
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
                                  // _questionsMatrix = false;
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
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: ((context) =>
                                //             const FahpResult())));
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
      ),
    );
  }

  TableRow questionMatrixRow(String cus, int cusIndex, List<String> numEng) {
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
            child: Text(cus),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(weight.toStringAsFixed(3)),
          ),
        ),
        for (int req in numEng)
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(req.toString()),
            ),
          ),
      ],
    );
  }
}
