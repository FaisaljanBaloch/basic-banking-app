import 'package:flutter/material.dart';

import '../model/customer.dart';
import './transfer_money_page.dart';

class ViewCustomerPage extends StatefulWidget {
  const ViewCustomerPage({super.key, required this.customer});

  final Customer customer;

  @override
  State<ViewCustomerPage> createState() => _ViewCustomerPageState();
}

class _ViewCustomerPageState extends State<ViewCustomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Customer Profile"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.account_circle,
                size: 75,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Name",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text(
                    widget.customer.name,
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
            const Divider(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Email",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text(
                    widget.customer.email,
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
            const Divider(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Current Balance",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text(
                    "\$ ${widget.customer.currentBalance}",
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
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
                  Text("Transfer Money"),
                  Icon(Icons.send_rounded),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
