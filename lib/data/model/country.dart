class Country {
  String? isoName;
  String? name;
  String? currencyCode;
  String? currencyName;
  String? flagUrl;

  Country({
    this.isoName,
    this.name,
    this.currencyCode,
    this.currencyName,
    this.flagUrl,
  });

  Country.fromJson(Map<String, dynamic> json) {
    isoName = json['isoName'];
    name = json['name'];
    currencyCode = json['currencyCode'];
    currencyName = json['currencyName'];
    flagUrl = json['flagUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isoName'] = this.isoName;
    data['name'] = this.name;
    data['currencyCode'] = this.currencyCode;
    data['currencyName'] = this.currencyName;
    data['flagUrl'] = this.flagUrl;
    return data;
  }

  static List<Country> fromJsonList(List list) {
    return list.map((item) => Country.fromJson(item)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.isoName,
      'name': this.name,
      'currencyCode': this.currencyCode,
      'currencyName': this.currencyName,
      'flagUrl': this.flagUrl,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      isoName: map['isoName'] as String,
      name: map['name'] as String,
      currencyCode: map['currencyCode'] as String,
      currencyName: map['currencyName'] as String,
      flagUrl: map['flagUrl'] as String,
    );
  }

  bool isEqual(Country model) {
    return isoName == model.isoName;
  }
}
