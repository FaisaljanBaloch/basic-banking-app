import 'package:basic_banking_app/pages/view_customer_page.dart';
import 'package:flutter/material.dart';

import '../model/customer.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.account_circle, size: 40),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.name,
              style: const TextStyle(fontSize: 17),
            ),
            Text(
              customer.email,
              style: const TextStyle(color: Colors.grey, fontSize: 14.0),
            ),
          ],
        ),
        trailing: Text(
          "\$ ${customer.currentBalance}",
          style: const TextStyle(fontSize: 15),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewCustomerPage(customer: customer)));
        },
      ),
    );
  }
}
