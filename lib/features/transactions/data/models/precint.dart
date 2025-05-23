import 'package:agunsa/features/transactions/domain/entities/precint.dart';

class PrecintModel extends Precinct {
  PrecintModel({required super.codPrecinto});

  factory PrecintModel.fromJson(Map<String, dynamic> json) => PrecintModel(
        codPrecinto: json['cod_precinto'],
      );

  Map<String, dynamic> toJson() => {
        'cod_precinto': codPrecinto,
      };
}
