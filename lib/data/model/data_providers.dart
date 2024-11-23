import 'package:browse_station/data/model/providers.dart';

class DataProviders extends Providers {
  @override
  String? id;
  @override
  String? name;
  @override
  String? image;
  Map<String, dynamic>? data_type;

  DataProviders({this.id, this.name, this.image, this.data_type});

  @override
  String toString() {
    return 'DataProviders{id: $id, name: $name, image: $image, data_type: $data_type}';
  }
}
