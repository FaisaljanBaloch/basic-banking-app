import 'package:basic_banking_app/util/validator.dart';
import 'package:flutter/material.dart';

import '../db/bank_database.dart';
import '../model/customer.dart';

class TransferMoneyPage extends StatefulWidget {
  const TransferMoneyPage({super.key, required this.customer});

  final Customer customer;

  @override
  State<TransferMoneyPage> createState() => _TransferMoneyPageState();
}

class _TransferMoneyPageState extends State<TransferMoneyPage> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final amountController = TextEditingController();
  final validator = Validator();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    fromController.text = widget.customer.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Transfer Money"),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("From",
                    style: TextStyle(color: Colors.grey, fontSize: 15)),
                TextFormField(
                  enabled: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: const EdgeInsets.all(14.0),
                  ),
                  controller: fromController,
                ),
                const SizedBox(height: 10),
                const Text("To",
                    style: TextStyle(color: Colors.grey, fontSize: 15)),
                FutureBuilder(
                  future: BankDatabase.instance
                      .getAllCustomersExcept(widget.customer.id),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      final customers = snapshot.data;
                      return DropdownMenu<Customer>(
                        width: MediaQuery.of(context).size.width * 0.9,
                        initialSelection: customers[0],
                        controller: toController,
                        leadingIcon: const Icon(Icons.person),
                        dropdownMenuEntries:
                            customers.map<DropdownMenuEntry<Customer>>(
                          (Customer customer) {
                            return DropdownMenuEntry<Customer>(
                                value: customer, label: customer.name);
                          },
                        ).toList(),
                      );
                    } else {
                      return TextFormField(
                        enabled: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          contentPadding: const EdgeInsets.all(14.0),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                const Text("Amount",
                    style: TextStyle(color: Colors.grey, fontSize: 15)),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.monetization_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: const EdgeInsets.all(14.0),
                  ),
                  controller: amountController,
                  validator: validator.amountField,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      fixedSize: const Size(200, 50),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Transaction successful! ${amountController.text}'),
                          ),
                        );
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Send Money"),
                        Icon(Icons.send_rounded),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
