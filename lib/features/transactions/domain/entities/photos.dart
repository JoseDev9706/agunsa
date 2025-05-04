class Foto {
  final int id;
  final int entityId;
  final String entityType;
  final String urlImagen;
  final DateTime fechaHora;

  Foto({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.urlImagen,
    required this.fechaHora,
  });

  factory Foto.fromJson(Map<String, dynamic> json) => Foto(
        id: json['id'],
        entityId: json['entidad_id'],
        entityType: json['entidad_tipo'],
        urlImagen: json['url_imagen'],
        fechaHora: DateTime.parse(json['fecha_hora']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'emidad_id': entityId,
        'emidad_tipo': entityType,
        'url_imagen': urlImagen,
        'fecha_hora': fechaHora.toIso8601String(),
      };
}