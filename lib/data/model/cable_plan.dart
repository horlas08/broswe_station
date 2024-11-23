class CablePlan {
  String? id;
  String? name;
  int? amount;

  CablePlan({
    this.id,
    this.name,
    this.amount,
  });

  CablePlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['amount'] = this.amount;
    return data;
  }

  static List<CablePlan> fromJsonList(List list) {
    return list.map((item) => CablePlan.fromJson(item)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'amount': this.amount,
    };
  }

  factory CablePlan.fromMap(Map<String, dynamic> map) {
    return CablePlan(
      id: map['id'] as String,
      name: map['name'] as String,
      amount: map['amount'] as int,
    );
  }

  bool isEqual(CablePlan model) {
    return id == model.id;
  }
}
