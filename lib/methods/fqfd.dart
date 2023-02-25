import 'package:flutter/material.dart';

class FqfdMethod extends StatefulWidget {
  const FqfdMethod({super.key});

  @override
  State<FqfdMethod> createState() => _FqfdMethodState();
}

class _FqfdMethodState extends State<FqfdMethod> {
  @override
  Widget build(BuildContext context) {
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
            'This method is coming soon',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
