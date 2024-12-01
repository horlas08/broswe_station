enum EsimType { limited, unlimited }

class EsimModel {
  String? id;
  String? name;
  String? amount_usd;
  String? amount_ngn;
  String? data_description;
  String? duration;
  String? type;

  EsimModel({
    this.id,
    this.name,
    this.amount_usd,
    this.amount_ngn,
    this.data_description,
    this.duration,
    this.type,
  });

  EsimModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount_usd = json['amount_usd'];
    amount_ngn = json['amount_ngn'];
    data_description = json['data_description'];
    duration = json['duration'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['amount_usd'] = this.amount_usd;
    data['amount_ngn'] = this.amount_ngn;
    data['data_description'] = this.data_description;
    data['duration'] = this.duration;
    data['type'] = this.type;
    return data;
  }

  static List<EsimModel> fromJsonList(List list) {
    return list.map((item) => EsimModel.fromJson(item)).toList();
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': this.id,
  //     'name': this.name,
  //     'amount': this.amount_usd,
  //     'amount_agent': this.amount_ngn,
  //     'descs': this.data_description,
  //     'status': this.duration,
  //   };
  // }

  factory EsimModel.fromMap(Map<String, dynamic> map) {
    return EsimModel(
      id: map['id'] as String,
      name: map['name'] as String,
      amount_usd: map['amount_usd'] as String,
      amount_ngn: map['amount_ngn'] as String,
      data_description: map['data_description'] as String,
      duration: map['duration'] as String,
      type: map['type'] as String,
    );
  }

  bool isEqual(EsimModel model) {
    return id == model.id;
  }
}
