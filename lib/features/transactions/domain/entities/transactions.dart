class Transaction {
  final int id;
  final String containerNumber;
  final String ContainerTransportLine;
  final String transactionType;
  final String transactionNumber;
  final DateTime fechaHora;

  Transaction({
    required this.id,
    required this.containerNumber,
    required this.ContainerTransportLine,
    required this.transactionType,
    required this.transactionNumber,
    required this.fechaHora,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        transactionType: json['tipo_transaction'],
        containerNumber: json['numero_contenedor'],
        ContainerTransportLine: json['linea_transporte_contenedor'],
        transactionNumber: json['numero_transaction'],
        fechaHora: DateTime.parse(json['fecha_hora']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo_transaction': transactionType,
        'numero_transaction': transactionNumber,
        'numero_contenedor': containerNumber,
        'linea_transporte_contenedor': ContainerTransportLine,
        'fecha_hora': fechaHora.toIso8601String(),
      };
}
