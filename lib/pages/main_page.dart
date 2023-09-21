import 'package:basic_banking_app/pages/customers_page.dart';
import 'package:basic_banking_app/pages/home_page.dart';
import 'package:basic_banking_app/pages/transactions_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title, this.selectedIndex = 0});

  final String title;
  final int selectedIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.selectedIndex,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: const TabBar.secondary(
            isScrollable: true,
            labelPadding:
                EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            dividerColor: Colors.transparent,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                text: 'All Customers',
                icon: Icon(Icons.people),
              ),
              Tab(
                text: 'Transactions',
                icon: Icon(Icons.watch_later),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            HomePage(),
            CustomersPage(),
            TransactionsPage(),
          ],
        ),
      ),
    );
  }
}
