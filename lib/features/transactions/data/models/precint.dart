import 'package:agunsa/features/transactions/domain/entities/precint.dart';

class PrecintModel extends Precinct {
  PrecintModel(
      {required super.codPrecinto,
      required super.imageUrl,
      required super.responseDateTime});

  factory PrecintModel.fromJson(Map<String, dynamic> json) => PrecintModel(
        codPrecinto: json['cod_precinto'],
        imageUrl: json['image_url'] ?? '',
        responseDateTime: json['response_date_time'] != null
            ? DateTime.parse(json['response_date_time'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'cod_precinto': codPrecinto,
        'image_url': imageUrl,
        'response_date_time': responseDateTime?.toIso8601String(),
      };
}
