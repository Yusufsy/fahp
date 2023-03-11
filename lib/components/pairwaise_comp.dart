import 'package:fahp/components/pairwise_row.dart';
import 'package:fahp/services/question_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PairWiseComp extends StatefulWidget {
  const PairWiseComp({super.key, required this.exIndex});
  final int exIndex;

  @override
  State<PairWiseComp> createState() => _PairWiseCompState();
}

class _PairWiseCompState extends State<PairWiseComp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: SelectableText(
            'Expert ${widget.exIndex}',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        for (List<List<String>> criterias
            in context.watch<QuestionNotifier>().pairsGen.values.toList())
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText.rich(
                  TextSpan(
                    text: 'With respect to ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: context.watch<QuestionNotifier>().wrt![context
                            .watch<QuestionNotifier>()
                            .pairsGen
                            .values
                            .toList()
                            .indexOf(criterias)],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextSpan(
                        text:
                            ', which of the following criterion is more important? and by how much is more?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              for (List<String> criteria in criterias)
                PairWiseRow(
                  exIndex: widget.exIndex - 1,
                  qIndex: context.watch<QuestionNotifier>().wrt!.indexOf(
                      context.watch<QuestionNotifier>().wrt![context
                          .watch<QuestionNotifier>()
                          .pairsGen
                          .values
                          .toList()
                          .indexOf(criterias)]),
                  criteria: criteria,
                  index: criterias.indexOf(criteria),
                ),
            ],
          ),
      ],
    );
  }
}
