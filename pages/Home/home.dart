import 'package:flutter/material.dart';
import './widgets/currency_form_field/currency_form_field.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _HomeState extends State<Home> {
  double _amount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Form Field Test Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              CurrencyFormField(onChangedAmount: (amount) {
                setState(() {
                  _amount = amount;
                });
              }),
              const SizedBox(height: 10),
              Text('$_amount',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
