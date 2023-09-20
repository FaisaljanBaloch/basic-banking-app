import 'package:basic_banking_app/pages/customers_page.dart';
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
  List<Customer> customers = [];

  final fromController = TextEditingController();
  final amountController = TextEditingController();
  Customer? selectedCustomer;
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
                FutureBuilder<List<Customer>>(
                  future: BankDatabase.instance
                      .getAllCustomersExcept(widget.customer.id),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        final customers = snapshot.data;
                        return DropdownMenu<Customer>(
                          width: MediaQuery.of(context).size.width * 0.9,
                          initialSelection: customers[0],
                          leadingIcon: const Icon(Icons.person),
                          dropdownMenuEntries:
                              customers.map<DropdownMenuEntry<Customer>>(
                            (Customer customer) {
                              return DropdownMenuEntry<Customer>(
                                  value: customer, label: customer.name);
                            },
                          ).toList(),
                          onSelected: (c) {
                            selectedCustomer = c;
                          },
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
                  validator: _validateAmount,
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
                      if (_formKey.currentState!.validate() &&
                          selectedCustomer != null) {
                        _transfer(
                            widget.customer.id!,
                            selectedCustomer!.id!,
                            double.tryParse(amountController.text.trim())!,
                            context);
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

  void _transfer(
      int sender, int receiver, double amount, BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    await BankDatabase.instance.makeTransaction(sender, receiver, amount);
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Transaction successful!'),
      ),
    );
    _navigate();
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "* amount field is required";
    } else if (double.parse(value) <= 0) {
      return "* amount must be minimum \$1";
    } else if (double.parse(value) > widget.customer.currentBalance) {
      return "* customer has insufficient balance";
    } else {
      return null;
    }
  }

  void _navigate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CustomersPage(),
      ),
    );
  }
}
