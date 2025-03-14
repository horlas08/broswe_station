class DataPlan {
  String? id;
  String? plan;
  String? validity;
  String? amount;
  String? amount_agent;
  String? cashback_agent;
  String? cashback_user;
  String? type;

  DataPlan({
    this.id,
    this.plan,
    this.validity,
    this.amount,
    this.type,
    this.amount_agent,
    this.cashback_user,
    this.cashback_agent,
  });

  DataPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plan = json['plan'];
    validity = json['validity'];
    amount = json['amount'];
    amount_agent = json['amount_agent'];
    cashback_agent = json['cashback_agent'];
    cashback_user = json['cashback_user'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plan'] = this.plan;
    data['validity'] = this.validity;
    data['amount'] = this.amount;
    data['amount_agent'] = this.amount_agent;
    data['type'] = this.type;
    data['cashback_user'] = this.cashback_user;
    data['cashback_agent'] = this.cashback_agent;
    return data;
  }

  @override
  String toString() {
    return '$plan -> $validity';
  }

  static List<DataPlan> fromJsonList(List list) {
    return list.map((item) => DataPlan.fromJson(item)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'plan': this.plan,
      'validity': this.validity,
      'amount': this.amount,
      'amount_agent': this.amount_agent,
      'cashback_agent': this.cashback_agent,
      'cashback_user': this.cashback_user,
      'type': this.type,
    };
  }

  factory DataPlan.fromMap(Map<String, dynamic> map) {
    return DataPlan(
      id: map['id'] as String,
      plan: map['plan'] as String,
      validity: map['validity'] as String,
      amount: map['amount'] as String,
      amount_agent: map['amount_agent'],
      cashback_user: map['cashback_user'],
      cashback_agent: map['cashback_agent'],
      type: map['type'] as String,
    );
  }

  bool isEqual(DataPlan model) {
    return id == model.id;
  }
}
