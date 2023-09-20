const String tableTransaction = "userTransaction";

class TransactionFields {
  static String id = '_id';
  static String sender = 'sender';
  static String receiver = 'receiver';
  static String amount = 'amount';
  static String createdAt = 'createdAt';

  static final List<String> values = [id, sender, receiver, amount, createdAt];
}

class UserTransaction {
  final int? id;
  final String sender;
  final String receiver;
  final double amount;
  final String? createdAt;

  const UserTransaction({
    this.id,
    required this.sender,
    required this.receiver,
    required this.amount,
    this.createdAt
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      TransactionFields.id: id,
      TransactionFields.sender: sender,
      TransactionFields.receiver: receiver,
      TransactionFields.amount: amount,
      TransactionFields.createdAt: createdAt,
    };
    return map;
  }

  factory UserTransaction.fromMap(Map<String, Object?> map) {
    return UserTransaction(
      id: map[TransactionFields.id] as int?,
      sender: map[TransactionFields.sender] as String,
      receiver: map[TransactionFields.receiver] as String,
      amount: map[TransactionFields.amount] as double,
      createdAt: map[TransactionFields.createdAt] as String,
    );
  }
}
