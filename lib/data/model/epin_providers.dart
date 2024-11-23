import 'package:browse_station/data/model/providers.dart';

class EpinProviders extends Providers {
  @override
  String? id;
  @override
  String? name;
  @override
  String? logo;
  @override
  String? image;
  String? type;
  String? amount;
  String? amountAgent;
  String? amountApi;
  String? number;
  String? instruction;
  String? status;

  EpinProviders(
      {this.id,
      this.name,
      this.type,
      this.amount,
      this.amountAgent,
      this.amountApi,
      this.number,
      this.image,
      this.instruction,
      this.status});

  EpinProviders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    amount = json['amount'];
    amountAgent = json['amount_agent'];
    amountApi = json['amount_api'];
    number = json['number'];
    image = json['image'];
    instruction = json['instruction'];
    status = json['status'];
  }
  static List<EpinProviders> fromJsonList(List list) {
    return list.map((item) => EpinProviders.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['amount'] = this.amount;
    data['amount_agent'] = this.amountAgent;
    data['amount_api'] = this.amountApi;
    data['number'] = this.number;
    data['image'] = this.image;
    data['instruction'] = this.instruction;
    data['status'] = this.status;
    return data;
  }
}
