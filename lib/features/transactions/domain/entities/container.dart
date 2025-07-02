class Container {
  final int id;
  final int transactionId; 
  final String numeroContenedor;
  final String identificacionLineaTransporte;
  final String codigoIso;
  final String tipoContenedor;
  final String tara;
  final String payload; 
  final DateTime fechaHora;

  Container({
    required this.id,
    required this.transactionId,
    required this.numeroContenedor,
    required this.identificacionLineaTransporte,
    required this.codigoIso,
    required this.tipoContenedor,
    required this.tara,
    required this.payload,
    required this.fechaHora,
  });

  factory Container.fromJson(Map<String, dynamic> json) => Container(
        id: json['id'],
        transactionId: json['transaction_id'],
        numeroContenedor: json['numero_contenedor'],
        identificacionLineaTransporte: json['identifcacion_linea_transporte'],
        codigoIso: json['codigo_iso'],
        tipoContenedor: json['tipo_contenedor'],
        tara: json['tara'].toString(),     // ✅ convertimos directo a String
        payload: json['playload'].toString(),
        fechaHora: DateTime.parse(json['fecha_hora']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'transaction_id': transactionId,
        'numero_contenedor': numeroContenedor,
        'identifcacion_linea_transporte': identificacionLineaTransporte,
        'codigo_izo': codigoIso,
        'tipo_contenedor': tipoContenedor,
        'tara': tara,         // <-- Enviado como String
        'playload': payload,
        'fecha_hora': fechaHora.toIso8601String(),
      };
}