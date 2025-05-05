import 'package:agunsa/features/transactions/domain/entities/photos.dart';

class FotoModel extends Foto {
  FotoModel({
    required int id,
    required String base64,
    String? urlImagen,
    required DateTime fechaHora,
    String? fileName,
  }) : super(
          id: id,
          base64: base64,
          urlImagen: urlImagen,
          fechaHora: fechaHora,
          fileName: fileName,
        );

  factory FotoModel.fromJson(Map<String, dynamic> json) => FotoModel(
        id: json['id'],
        base64: json['base64'],
        urlImagen: json['url_imagen'],
        fechaHora: DateTime.parse(json['fecha_hora']),
        fileName: json['filename'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'base64': base64,
        'url_imagen': urlImagen,
        'fecha_hora': fechaHora.toIso8601String(),
        'filename': fileName,
      };
}
