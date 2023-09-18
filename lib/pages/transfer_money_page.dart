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
  final toController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    getCustomers();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("From",
                    style: TextStyle(color: Colors.grey, fontSize: 15)),
                TextFormField(
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
                DropdownMenu<Customer>(
                  leadingIcon: const Icon(Icons.person),
                  dropdownMenuEntries:
                      customers.map<DropdownMenuEntry<Customer>>(
                    (Customer customer) {
                      return DropdownMenuEntry<Customer>(
                          value: customer, label: customer.name);
                    },
                  ).toList(),
                ),
                TextFormField(
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
                  controller: fromController,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TransferMoneyPage(customer: widget.customer),
                        ),
                      );
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

  void getCustomers() async {
    await BankDatabase.instance.getAllCustomers().then((result) {
      setState(() {
        customers = result;
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }
}
