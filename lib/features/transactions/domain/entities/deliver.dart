class Conductor {
  final int id;
  final int transactionId;
  final String names;
  final String lastNames;
  final String dni;
  final DateTime fechaHora;

  Conductor({
    required this.id,
    required this.transactionId,
    required this.names,
    required this.lastNames,
    required this.dni,
    required this.fechaHora,
  });

  factory Conductor.fromJson(Map<String, dynamic> json) => Conductor(
        id: json['id'],
        transactionId: json['transaction_id'],
        names: json['names'],
        lastNames: json['lastNames'],
        dni: json['dni'],
        fechaHora: DateTime.parse(json['fecha_hora']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'transaction_id': transactionId,
        'names': names,
        'lastNames': lastNames,
        'dni': dni,
        'fecha_hora': fechaHora.toIso8601String(),
      };
}