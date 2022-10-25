import 'package:fahp/services/matrix_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PairWiseRow extends StatefulWidget {
  const PairWiseRow({super.key, required this.criteria, required this.index});
  final List<String> criteria;
  final int index;

  @override
  State<PairWiseRow> createState() => _PairWiseRowState();
}

class _PairWiseRowState extends State<PairWiseRow> {
  String _groupValue = 'Equal';
  String groupVal = '';

  @override
  void initState() {
    groupVal = widget.criteria[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      defaultColumnWidth: const IntrinsicColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${widget.index + 1}'),
              ),
            ),
            _criteriaCell(),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Radio(
                      value: 'Equal',
                      groupValue: _groupValue,
                      onChanged: (value) {
                        context
                            .read<MatrixNotifier>()
                            .setMatrixValue(widget.criteria, 1, 0);
                        setState(() {
                          _groupValue = value!;
                        });
                      },
                    ),
                    const Text('1'),
                  ],
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    for (double i = 2; i < 10; i++)
                      Row(
                        children: [
                          Radio(
                            value: '$i',
                            groupValue: _groupValue,
                            onChanged: (value) {
                              context.read<MatrixNotifier>().setMatrixValue(
                                  widget.criteria, i, widget.index);
                              setState(() {
                                _groupValue = value!;
                              });
                            },
                          ),
                          Text('$i'),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  TableCell _criteriaCell() {
    return TableCell(
        child: SizedBox(
      width: MediaQuery.of(context).size.width * 0.1,
      child: Column(
        children: [
          for (String criteria in widget.criteria)
            Row(
              children: [
                Radio(
                  value: criteria,
                  groupValue: groupVal,
                  onChanged: (value) {
                    setState(() {
                      groupVal = value!;
                    });
                  },
                ),
                Text(criteria),
              ],
            ),
        ],
      ),
    ));
  }
}
