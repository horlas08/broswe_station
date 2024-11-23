class PortraitcutsModel {
  String? id;
  String? name;
  String? amount;
  String? amount_agent;
  String? descs;
  String? status;

  PortraitcutsModel({
    this.id,
    this.name,
    this.amount,
    this.amount_agent,
    this.descs,
    this.status,
  });

  PortraitcutsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    amount_agent = json['amount_agent'];
    descs = json['descs'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['amount_agent'] = this.amount_agent;
    data['descs'] = this.descs;
    data['status'] = this.status;
    return data;
  }

  static List<PortraitcutsModel> fromJsonList(List list) {
    return list.map((item) => PortraitcutsModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'amount': this.amount,
      'amount_agent': this.amount_agent,
      'descs': this.descs,
      'status': this.status,
    };
  }

  factory PortraitcutsModel.fromMap(Map<String, dynamic> map) {
    return PortraitcutsModel(
      id: map['id'] as String,
      name: map['name'] as String,
      amount: map['amount'] as String,
      amount_agent: map['amount_agent'] as String,
      descs: map['descs'] as String,
      status: map['status'] as String,
    );
  }

  bool isEqual(PortraitcutsModel model) {
    return id == model.id;
  }
}
