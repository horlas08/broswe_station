import 'package:browse_station/data/model/providers.dart';

class CableProviders extends Providers {
  @override
  String? id;
  @override
  String? name;
  String? product_id;
  @override
  String? image;
  @override
  String? logo;
  String? service;
  String? ncwallet;
  String? easyaccess;
  String? api;
  String? status;

  CableProviders(
      {this.id,
      this.name = '',
      this.logo = '',
      this.image = '',
      this.product_id,
      this.service,
      this.ncwallet,
      this.easyaccess,
      this.api,
      this.status})
      : super();

  CableProviders.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    id = json['id'];
    name = json['name'];
    product_id = json['product_id'];
    service = json['service'];
    image = json['image'];
    logo = json['image'];
    ncwallet = json['ncwallet'];
    easyaccess = json['easyaccess'];
    api = json['api'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['product_id'] = product_id;
    data['service'] = service;
    data['logo'] = logo;
    data['image'] = image;
    data['ncwallet'] = ncwallet;
    data['easyaccess'] = easyaccess;
    data['api'] = api;
    data['status'] = status;
    return data;
  }
}
