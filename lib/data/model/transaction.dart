class Transaction {
  int amount;
  String type;
  String title;
  String date;

//<editor-fold desc="Data Methods">
  Transaction({
    required this.amount,
    required this.type,
    required this.title,
    required this.date,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          type == other.type &&
          title == other.title &&
          date == other.date);

  @override
  int get hashCode =>
      amount.hashCode ^ type.hashCode ^ title.hashCode ^ date.hashCode;

  @override
  String toString() {
    return 'Transaction{ amount: $amount, type: $type, title: $title, date: $date,}';
  }

  Transaction copyWith({
    int? amount,
    String? type,
    String? title,
    String? date,
  }) {
    return Transaction(
      amount: amount ?? this.amount,
      type: type ?? this.type,
      title: title ?? this.title,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'title': title,
      'date': date,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      amount: map['amount'] as int,
      type: map['type'] as String,
      title: map['title'] as String,
      date: map['date'] as String,
    );
  }

//</editor-fold>
}
