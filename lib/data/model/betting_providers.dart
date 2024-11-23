class BettingProviders {
  String? id;
  String? title;
  bool? active;

  BettingProviders({
    this.id = '',
    this.title = '',
    this.active = false,
  }) : super();

  BettingProviders.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    id = json['id'];
    title = json['title'];
    active = json['active'];
  }
  static List<BettingProviders> fromJsonList(List list) {
    return list.map((item) => BettingProviders.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['active'] = active;

    return data;
  }
}
