class Placa {
  final int id;
  final int transactionId;
  final String placaNumber;
  final DateTime fechaHora;

  Placa({
    required this.id,
    required this.transactionId,
    required this.placaNumber,
    required this.fechaHora,
  });

  factory Placa.fromJson(Map<String, dynamic> json) => Placa(
        id: json['id'],
        transactionId: json['transaction_id'],
        placaNumber: json['numero_placa'],
        fechaHora: DateTime.parse(json['fecha_hora']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'transaction_id': transactionId,
        'numero_placa': placaNumber,
        'fecha_hora': fechaHora.toIso8601String(),
      };
}