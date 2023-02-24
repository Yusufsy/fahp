import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FahpFqfdMethod extends StatefulWidget {
  const FahpFqfdMethod({super.key});

  @override
  State<FahpFqfdMethod> createState() => _FahpFqfdMethodState();
}

class _FahpFqfdMethodState extends State<FahpFqfdMethod> {
  final TextEditingController _expertController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const Text('FAHP with QFD'),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                labelText: 'Number of Experts',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _expertController,
              keyboardType: TextInputType.number,
              validator: (value) {
                return value!.isEmpty ? 'Please fill this field' : null;
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                icon: Icon(Icons.question_mark),
                labelText: 'Number of Pairwise Comparison Matrices (PCMs)',
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _numberController,
              keyboardType: TextInputType.number,
              validator: (value) {
                return value!.isEmpty ? 'Please fill this field' : null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
