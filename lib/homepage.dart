import 'package:fahp/methods/ahp.dart';
import 'package:fahp/methods/fahp.dart';
import 'package:fahp/methods/fahp_fqfd.dart';
import 'package:fahp/methods/fahp_gdm.dart';
import 'package:fahp/methods/fqfd.dart';
import 'package:fahp/methods/qfd.dart';
import 'package:fahp/services/qfd_notifier.dart';
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
    'QFD',
    // 'FAHP with QFD',
    'FQFD',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            SelectableText("FAHP & QFD Calculator"),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: SelectableText("Consensus AHP Online Calculator"),
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
                title: SelectableText("About App"),
                children: [
                  SelectableText(
                      "This website is a calculator that performs the Analytical Hierarchy Process (AHP) method. "
                      "Additionally, it can also preform calculation of the Quality Function Deployment (QFD) model."
                      " Moreover, it can easily integrate the both methods (AHP-QFD) by transporting the result obtained from the AHP to the first stage of the QFD."),
                ],
              ),
              const ExpansionTile(
                title: SelectableText("How to use the app"),
                children: [
                  SelectableText("How-to app goes here"),
                ],
              ),
              const ExpansionTile(
                title: SelectableText("Why Fuzzy-AHP"),
                children: [
                  SelectableText("Why fuzzy-AHP goes here"),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  const Spacer(),
                  const SelectableText('Method: '),
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
                visible: dropdownvalue == 'QFD',
                child: const QfdMethod(),
              ),
              Visibility(
                visible: dropdownvalue == 'FAHP with QFD',
                child: const FahpFqfdMethod(),
              ),
              Visibility(
                visible: dropdownvalue == 'FQFD',
                child: const FqfdMethod(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
