import 'package:fahp/methods/ahp.dart';
import 'package:fahp/methods/fahp.dart';
import 'package:fahp/methods/fahp_fqfd.dart';
import 'package:fahp/methods/fahp_gdm.dart';
import 'package:fahp/methods/fqfd.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropdownvalue = 'FAHP';
  var items = [
    'AHP',
    'FAHP',
    'FAHP - GDM',
    'FQFD',
    'FAHP with FQFD',
  ];

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const ExpansionTile(
                title: Text("About App"),
                children: [
                  Text("About app goes here"),
                ],
              ),
              const ExpansionTile(
                title: Text("How to use the app"),
                children: [
                  Text("How-to app goes here"),
                ],
              ),
              const ExpansionTile(
                title: Text("Why Fuzzy-AHP"),
                children: [
                  Text("Why fuxxy-AHP goes here"),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  const Spacer(),
                  const Text('Method: '),
                  DropdownButton(
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ],
              ),
              Visibility(
                visible: dropdownvalue == 'AHP',
                child: const AhpMethod(),
              ),
              Visibility(
                visible: dropdownvalue == 'FAHP',
                child: const FahpMethod(),
              ),
              Visibility(
                visible: dropdownvalue == 'FAHP - GDM',
                child: const FahpGdmMethod(),
              ),
              Visibility(
                visible: dropdownvalue == 'FQFD',
                child: const FqfdMethod(),
              ),
              Visibility(
                visible: dropdownvalue == 'FAHP with FQFD',
                child: const FahpFqfdMethod(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
