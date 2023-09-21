import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/customer.dart';
import '../model/user_transaction.dart';

class BankDatabase {
  static final BankDatabase instance = BankDatabase._init();

  static Database? _database;

  BankDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('bank_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // creates the user table with corresponding columns
    await db.execute(''' CREATE TABLE $tableCustomer(
    ${CustomerFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${CustomerFields.name} VARCHAR(25) NOT NULL,
    ${CustomerFields.email} VARCHAR(100) NOT NULL,
    ${CustomerFields.currentBalance} REAL)
    ''');

    await db.execute(''' CREATE TABLE $tableTransaction(
    ${TransactionFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${TransactionFields.sender} VARCHAR(25) NOT NULL,
    ${TransactionFields.receiver} VARCHAR(25) NOT NULL,
    ${TransactionFields.amount} REAL,
    ${TransactionFields.createdAt} TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
    ''');

    // add dummy customers
    Batch batch = db.batch();
    String customersJson = await rootBundle.loadString("assets/customers.json");
    List customers = json.decode(customersJson);
    for (var customer in customers) {
      batch.insert(tableCustomer, customer);
    }
    await batch.commit();
  }

  // create an user
  Future<Customer> create(Customer customer) async {
    final db = await instance.database;
    final id = await db.insert(tableCustomer, customer.toMap());

    return customer.copy(id: id);
  }

  // create a transaction
  Future<void> makeTransaction(int sender, int receiver, double amount) async {
    final db = await instance.database;
    final senderUser = await getCustomer(sender);
    final receiverUser = await getCustomer(receiver);

    await db.transaction((txn) async {
      await txn.rawUpdate(
          'UPDATE $tableCustomer SET ${CustomerFields.currentBalance} = ${CustomerFields.currentBalance} - ? WHERE ${CustomerFields.id} = ?',
          [amount, sender]);
      await txn.rawUpdate(
          'UPDATE $tableCustomer SET ${CustomerFields.currentBalance} = ${CustomerFields.currentBalance} + ? WHERE ${CustomerFields.id} = ?',
          [amount, receiver]);

       await txn.rawInsert(
          'INSERT INTO $tableTransaction(${TransactionFields.sender}, ${TransactionFields.receiver}, ${TransactionFields.amount}) VALUES (?, ?, ?)',
          [senderUser.name, receiverUser.name, amount]);
    });
  }

  // fetch one customer
  Future<Customer> getCustomer(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCustomer,
      columns: CustomerFields.values,
      where: '${CustomerFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Customer.fromMap(maps.first);
    } else {
      throw Exception('IS $id not found');
    }
  }

  // fetch all customers
  Future<List<Customer>> getAllCustomers() async {
    final db = await instance.database;

    final orderBy = '${CustomerFields.name} ASC';
    final result = await db.query(tableCustomer, orderBy: orderBy);

    return result.map((e) => Customer.fromMap(e)).toList();
  }

  // fetch all transactions
  Future<List<UserTransaction>> getAllTransactions() async {
    final db = await instance.database;

    final orderBy = '${TransactionFields.createdAt} DESC';
    final result = await db.query(tableTransaction, orderBy: orderBy);

    return result.map((e) => UserTransaction.fromMap(e)).toList();
  }

  // fetch all customers
  Future<List<Customer>> getAllCustomersExcept(int? id) async {
    final db = await instance.database;

    final orderBy = '${CustomerFields.name} ASC';
    final result = await db.query(
      tableCustomer,
      orderBy: orderBy,
      where: '${CustomerFields.id} != ?',
      whereArgs: [id],
    );

    return result.map((e) => Customer.fromMap(e)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
