class TransactionDetailsModel {
  Original? original;
  String? status;
  String? service;
  String? trxid;
  String? amount;
  String? message;
  String? datetime;
  TransactionDetailsModel({
    this.original,
    this.status,
    this.service,
    this.trxid,
    this.amount,
    this.message,
    this.datetime,
    // this.data,
  });

  TransactionDetailsModel.fromJson(Map<String, dynamic> json) {
    original =
        json['original'] != null ? Original.fromJson(json['original']) : null;
    status = json['status'];
    service = json['service'];
    trxid = json['trxid'];
    amount = json['amount'];
    message = json['message'];
    datetime = json['datetime'];
    // data = json['data'] ?? {};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (original != null) {
      data['original'] = original!.toJson();
    }
    data['status'] = status;
    data['service'] = service;
    data['trxid'] = trxid;
    data['amount'] = amount;
    data['message'] = message;
    data['datetime'] = datetime;

    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'original': original,
      'status': status,
      'service': service,
      'trxid': trxid,
      'amount': amount,
      'message': message,
      'datetime': datetime,
    };
  }

  factory TransactionDetailsModel.fromMap(Map<String, dynamic> map) {
    return TransactionDetailsModel(
      original:
          map['original'] != null ? Original.fromMap(map['original']) : null,
      status: map['status'] as String,
      service: map['service'] as String,
      trxid: map['trxid'] as String,
      amount: map['amount'] as String,
      message: map['message'] as String,
      datetime: map['datetime'] as String,
      // data: map['data'] ?? {} as Map<String, dynamic>,
    );
  }
}

class Original {
  int? id;
  int? userid;
  String? trxid;
  int? amount;
  double? prev;
  double? curr;
  String? network;
  String? plan;
  String? type;
  String? phone;
  String? mode;
  String? datetime;
  String? dateCreated;
  int? status;

  Original(
      {this.id,
      this.userid,
      this.trxid,
      this.amount,
      this.prev,
      this.curr,
      this.network,
      this.plan,
      this.type,
      this.phone,
      this.mode,
      this.datetime,
      this.dateCreated,
      this.status});

  Original.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userid = json['userid'];
    trxid = json['trxid'];
    amount = json['amount'];
    prev = json['prev'];
    curr = json['curr'];
    network = json['network'];
    plan = json['plan'];
    type = json['type'];
    phone = json['phone'];
    mode = json['mode'];
    datetime = json['datetime'];
    dateCreated = json['date_created'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['userid'] = userid;
    data['trxid'] = trxid;
    data['amount'] = amount;
    data['prev'] = prev;
    data['curr'] = curr;
    data['network'] = network;
    data['plan'] = plan;
    data['type'] = type;
    data['phone'] = phone;
    data['mode'] = mode;
    data['datetime'] = datetime;
    data['date_created'] = dateCreated;
    data['status'] = status;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userid': userid,
      'trxid': trxid,
      'amount': amount,
      'prev': prev,
      'curr': curr,
      'network': network,
      'plan': plan,
      'type': type,
      'phone': phone,
      'mode': mode,
      'datetime': datetime,
      'dateCreated': dateCreated,
      'status': status,
    };
  }

  factory Original.fromMap(Map<String, dynamic> map) {
    return Original(
      id: map['id'],
      userid: map['userid'],
      trxid: map['trxid'],
      amount: map['amount'],
      prev: map['prev'],
      curr: map['curr'],
      network: map['network'],
      plan: map['plan'],
      type: map['type'],
      phone: map['phone'],
      mode: map['mode'],
      datetime: map['datetime'],
      dateCreated: map['dateCreated'],
      status: map['status'],
    );
  }
}
