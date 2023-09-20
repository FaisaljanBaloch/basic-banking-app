import 'package:basic_banking_app/model/user_transaction.dart';
import 'package:basic_banking_app/ui/transaction_card.dart';
import 'package:flutter/material.dart';

import '../db/bank_database.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<UserTransaction> transactions = [];
  bool _isLoading = false;

  @override
  void initState() {
    _getTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : transactions.isEmpty
            ? const Center(
                child: Text("No Transactions"),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return TransactionCard(transaction: transaction);
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
                padding: const EdgeInsets.all(14),
                itemCount: transactions.length,
              );
  }

  void _getTransactions() async {
    setState(() {
      _isLoading = true;
    });

    final db = BankDatabase.instance;
    await db.getAllTransactions().then((result) {
      setState(() {
        transactions = result;
        _isLoading = false;
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }
}
