import 'package:basic_banking_app/db/bank_database.dart';
import 'package:basic_banking_app/model/customer.dart';
import 'package:basic_banking_app/ui/customer_card.dart';
import 'package:flutter/material.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List<Customer> customers = [];

  bool _isLoading = false;

  @override
  void initState() {
    getCustomers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : customers.isEmpty
            ? const Center(
                child: Text("No Customers"),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  final customer = customers[index];
                  return CustomerCard(customer: customer);
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
                padding: const EdgeInsets.all(14),
                itemCount: customers.length,
              );
  }

  void getCustomers() async {
    setState(() {
      _isLoading = true;
    });
    await BankDatabase.instance.getAllCustomers().then((result) {
      setState(() {
        customers = result;
        _isLoading = false;
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }
}
