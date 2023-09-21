import 'package:flutter/material.dart';

import '../model/user_transaction.dart';
import '../util/date_formatter.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.transaction});
  final UserTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${transaction.sender} to ${transaction.receiver}",
              style: const TextStyle(fontSize: 17),
            ),
            const Text(
              "Transfer",
              style: TextStyle(color: Colors.grey, fontSize: 14.0),
            ),
          ],
        ),
        trailing: Text(
          "\$ ${transaction.amount}",
          style: const TextStyle(fontSize: 15),
        ),
        subtitle: Text('Date:  ${DateFormatter.strToDateFormat(transaction.createdAt)}'),
      ),
    );
  }
}
