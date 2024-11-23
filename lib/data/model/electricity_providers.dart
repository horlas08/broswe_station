import 'package:browse_station/data/model/providers.dart';

class ElectricityProviders extends Providers {
  @override
  String? id;
  @override
  String? name;
  String? serviceId;
  @override
  String? logo;
  @override
  String? image;
  String? service;
  String? ncwallet;
  String? easyaccess;
  String? api;
  String? status;

  ElectricityProviders(
      {this.id = '',
      this.name = '',
      this.logo = '',
      this.image = '',
      this.serviceId,
      this.service,
      this.ncwallet,
      this.easyaccess,
      this.api,
      this.status})
      : super();

  ElectricityProviders.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    id = json['id'];
    name = json['name'];
    serviceId = json['service_id'];
    service = json['service'];
    logo = json['image'];
    ncwallet = json['ncwallet'];
    easyaccess = json['easyaccess'];
    api = json['api'];
    status = json['status'];
  }
  static List<ElectricityProviders> fromJsonList(List list) {
    return list.map((item) => ElectricityProviders.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['service_id'] = serviceId;
    data['service'] = service;
    data['logo'] = logo;
    data['ncwallet'] = ncwallet;
    data['easyaccess'] = easyaccess;
    data['api'] = api;
    data['status'] = status;
    return data;
  }
}
