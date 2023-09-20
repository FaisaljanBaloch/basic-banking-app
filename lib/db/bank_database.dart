import 'dart:convert';

import 'package:basic_banking_app/model/customer.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
