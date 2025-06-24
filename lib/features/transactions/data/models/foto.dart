import 'package:agunsa/features/transactions/domain/entities/photos.dart';

class FotoModel extends Foto {
  FotoModel({
    required super.codPropietario,
    required super.numSerie,
    required super.numControl,
    required super.tipoContenedor,
    required super.maxGrossKg,
    required super.maxGrossLbs,
    required super.taraKg,
    required super.taraLbs,
    required super.payloadKg,
    required super.payloadLbs,
    required super.responseDateTime,
    required super.imageUrl,
    super.updateDataContainer,
  });

  factory FotoModel.fromJson(Map<String, dynamic> json) => FotoModel(
        codPropietario: json['cod_propietario'],
        numSerie: json['num_serie'],
        numControl: json['num_control'],
        tipoContenedor: json['tipo_contenedor'],
        maxGrossKg: json['max_gross_kg'],
        maxGrossLbs: json['max_gross_lbs'],
        taraKg: json['tara_kg'],
        taraLbs: json['tara_lbs'],
        payloadKg: json['payload_kg'],
        payloadLbs: json['payload_lbs'],
        responseDateTime: json['response_date_time'] != null
            ? DateTime.parse(json['response_date_time'])
            : DateTime.now(),
        imageUrl: json['image_url'],
        updateDataContainer: json['update_data_container'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'cod_propietario': codPropietario,
        'num_serie': numSerie,
        'num_control': numControl,
        'tipo_contenedor': tipoContenedor,
        'max_gross_kg': maxGrossKg,
        'max_gross_lbs': maxGrossLbs,
        'tara_kg': taraKg,
        'tara_lbs': taraLbs,
        'payload_kg': payloadKg,
        'payload_lbs': payloadLbs,
        'response_date_time': responseDateTime?.toIso8601String(),
        'image_url': imageUrl,
        'update_data_container': updateDataContainer,
      };
}
