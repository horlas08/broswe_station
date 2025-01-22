// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptoInfo _$CryptoInfoFromJson(Map<String, dynamic> json) => CryptoInfo(
      id: json['id'] as String?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      rate: json['rate'] as String?,
      walletAddress: json['wallet_address'] as String?,
      qrCode: json['qr_code'] as String?,
      image: json['image'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$CryptoInfoToJson(CryptoInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
      'rate': instance.rate,
      'wallet_address': instance.walletAddress,
      'qr_code': instance.qrCode,
      'image': instance.image,
      'status': instance.status,
    };
