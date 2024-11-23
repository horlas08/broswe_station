class Bank {
  String? name;
  String? code;

  Bank({
    this.name,
    this.code,
  });

  Bank.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }

  static List<Bank> fromJsonList(List list) {
    return list.map((item) => Bank.fromJson(item)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'code': this.code,
    };
  }

  factory Bank.fromMap(Map<String, dynamic> map) {
    return Bank(
      name: map['name'] as String,
      code: map['code'] as String,
    );
  }
}
