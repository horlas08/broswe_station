import 'package:json_annotation/json_annotation.dart';

part 'crypto_info.g.dart';

@JsonSerializable(explicitToJson: true)
class CryptoInfo {
  final String? id;
  final String? name;
  final String? symbol;
  final String? rate;
  @JsonKey(name: 'wallet_address')
  final String? walletAddress;
  @JsonKey(name: 'qr_code')
  final String? qrCode;
  final String? image;
  final String? status;

  const CryptoInfo({
    this.id,
    this.name,
    this.symbol,
    this.rate,
    this.walletAddress,
    this.qrCode,
    this.image,
    this.status,
  });

  factory CryptoInfo.fromJson(Map<String, dynamic> json) =>
      _$CryptoInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CryptoInfoToJson(this);

  CryptoInfo copyWith({
    String? id,
    String? name,
    String? symbol,
    String? rate,
    String? walletAddress,
    String? qrCode,
    String? image,
    String? status,
  }) {
    return CryptoInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      rate: rate ?? this.rate,
      walletAddress: walletAddress ?? this.walletAddress,
      qrCode: qrCode ?? this.qrCode,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  static List<CryptoInfo> fromJsonList(List list) {
    return list.map((item) => CryptoInfo.fromJson(item)).toList();
  }
}
