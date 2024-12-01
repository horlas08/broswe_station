class Product {
  int? productId;
  String? productName;
  List<dynamic>? fixedRecipientDenominations;
  List<dynamic>? fixedSenderDenominations;
  String? senderFee;
  String? status;

  Product({
    this.productId,
    this.productName,
    this.fixedRecipientDenominations,
    this.fixedSenderDenominations,
    this.senderFee,
    this.status,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    fixedRecipientDenominations = json['fixedRecipientDenominations'];
    fixedSenderDenominations = json['fixedSenderDenominations'];
    senderFee = json['senderFee'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['amount'] = this.fixedRecipientDenominations;
    data['amount_agent'] = this.fixedSenderDenominations;
    data['descs'] = this.senderFee;
    data['status'] = this.status;
    return data;
  }

  static List<Product> fromJsonList(List list) {
    return list.map((item) => Product.fromJson(item)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': this.productId,
      'productName': this.productName,
      'amount': this.fixedRecipientDenominations,
      'amount_agent': this.fixedSenderDenominations,
      'descs': this.senderFee,
      'status': this.status,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map['productId'] as int,
      productName: map['productName'] as String,
      fixedRecipientDenominations: map['fixedRecipientDenominations'] as List,
      fixedSenderDenominations: map['fixedSenderDenominations'] as List,
      senderFee: map['senderFee'] as String,
      status: map['status'] as String,
    );
  }

  bool isEqual(Product model) {
    return productId == model.productId;
  }
}
