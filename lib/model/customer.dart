const String tableCustomer = "customer";

class CustomerFields {
  static String id = '_id';
  static String name = 'name';
  static String email = 'email';
  static String currentBalance = 'currentBalance';

  static final List<String> values = [id, name, email, currentBalance];
}

class Customer {
  final int? id;
  final String name;
  final String email;
  final double currentBalance;

  const Customer({
    this.id,
    required this.name,
    required this.email,
    required this.currentBalance,
  });

  Customer copy({
    int? id,
    String? name,
    String? email,
    double? currentBalance,
  }) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        currentBalance: currentBalance ?? this.currentBalance,
      );

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      CustomerFields.id: id,
      CustomerFields.name: name,
      CustomerFields.email: email,
      CustomerFields.currentBalance: currentBalance,
    };
    return map;
  }

  factory Customer.fromMap(Map<String, Object?> map) {
    return Customer(
      id: map[CustomerFields.id] as int?,
      name: map[CustomerFields.name] as String,
      email: map[CustomerFields.email] as String,
      currentBalance: map[CustomerFields.currentBalance] as double,
    );
  }
}
