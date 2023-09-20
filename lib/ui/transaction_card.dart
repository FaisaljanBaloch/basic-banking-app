import 'package:basic_banking_app/model/user_transaction.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.transaction});

  final UserTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.account_circle),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.sender,
              style: const TextStyle(fontSize: 17),
            ),
            Text(
              transaction.receiver,
              style: const TextStyle(color: Colors.grey, fontSize: 14.0),
            ),
          ],
        ),
        subtitle: Text('- ${transaction.createdAt}'),
        trailing: Text(
          "\$ ${transaction.amount}",
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
