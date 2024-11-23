class Account {
  String? bankCode;
  String? bankName;
  String? accountNumber;
  String? accountName;
  String? accountType;
  String? expireDate;
  String? trackingReference;

  Account(
      {this.bankCode,
      this.bankName,
      this.accountNumber,
      this.accountName,
      this.accountType,
      this.expireDate,
      this.trackingReference});

  Account.fromJson(Map<String, dynamic> json) {
    bankCode = json['bankCode'];
    bankName = json['bankName'];
    accountNumber = json['accountNumber'];
    accountName = json['accountName'];
    accountType = json['account_type'];
    expireDate = json['expire_date'];
    trackingReference = json['trackingReference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bankCode'] = this.bankCode;
    data['bankName'] = this.bankName;
    data['accountNumber'] = this.accountNumber;
    data['accountName'] = this.accountName;
    data['account_type'] = this.accountType;
    data['expire_date'] = this.expireDate;
    data['trackingReference'] = this.trackingReference;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'bankCode': this.bankCode,
      'bankName': this.bankName,
      'accountNumber': this.accountNumber,
      'accountName': this.accountName,
      'accountType': this.accountType,
      'expireDate': this.expireDate,
      'trackingReference': this.trackingReference,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      bankCode: map['bankCode'] as String,
      bankName: map['bankName'] as String,
      accountNumber: map['accountNumber'] as String,
      accountName: map['accountName'] as String,
      accountType: map['accountType'] as String,
      expireDate: map['expireDate'] as String,
      trackingReference: map['trackingReference'] as String,
    );
  }
}
