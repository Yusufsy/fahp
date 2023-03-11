import 'package:fahp/services/matrix_notifier.dart';
import 'package:fahp/services/question_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PairWiseRow extends StatefulWidget {
  const PairWiseRow(
      {super.key,
      required this.criteria,
      required this.index,
      required this.qIndex,
      required this.exIndex});
  final List<String> criteria;
  final int index;
  final int qIndex;
  final int exIndex;

  @override
  State<PairWiseRow> createState() => _PairWiseRowState();
}

class _PairWiseRowState extends State<PairWiseRow> {
  String _groupValue = 'Equal';
  String groupVal = '';
  int respect = 0;

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
                child: SelectableText('${widget.index + 1}'),
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
                        context.read<QuestionNotifier>().setMatrixValue(
                            widget.exIndex,
                            widget.criteria,
                            1,
                            widget.qIndex,
                            widget.index,
                            respect);
                        setState(() {
                          _groupValue = value!;
                        });
                      },
                    ),
                    const SelectableText('1'),
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
                              context.read<QuestionNotifier>().setMatrixValue(
                                  widget.exIndex,
                                  widget.criteria,
                                  i,
                                  widget.qIndex,
                                  widget.index,
                                  respect);
                              setState(() {
                                _groupValue = value!;
                              });
                            },
                          ),
                          SelectableText('$i'),
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
                      respect = widget.criteria.indexOf(criteria);
                      _groupValue = '';
                    });
                  },
                ),
                SelectableText(criteria),
              ],
            ),
        ],
      ),
    ));
  }
}
