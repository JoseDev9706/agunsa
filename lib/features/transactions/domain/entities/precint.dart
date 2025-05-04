class Precinct {
  final int id;
  final int transactionId;
  final int containerId;
  final String codigoPrecintoAduania;
  final String codigoPrecintoLinea1;
  final String codigoPrecintoLinea2;
  final DateTime fechaHora;

  Precinct({
    required this.id,
    required this.transactionId,
    required this.containerId,
    required this.codigoPrecintoAduania,
    required this.codigoPrecintoLinea1,
    required this.codigoPrecintoLinea2,
    required this.fechaHora,
  });

  factory Precinct.fromJson(Map<String, dynamic> json) => Precinct(
        id: json['id'],
        transactionId: json['transaction_id'],
        containerId: json['contenedor_id'],
        codigoPrecintoAduania: json['codigo_precinto_aduana'],
        codigoPrecintoLinea1: json['codigo_precinto_linea1'],
        codigoPrecintoLinea2: json['codigo_precinto_linea2'],
        fechaHora: DateTime.parse(json['fecha_hora']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'transaction_id': transactionId,
        'contenedor_id': containerId,
        'codigo_precinto_aduana': codigoPrecintoAduania,
        'codigo_precinto_linea1': codigoPrecintoLinea1,
        'codigo_precinto_linea2': codigoPrecintoLinea2,
        'fecha_hora': fechaHora.toIso8601String(),
      };
}