class Placa {
  final String codigo;
  final String? responseDateTime;
  final String? imageUrl;

  Placa({
    required this.codigo,
    required this.responseDateTime,
    required this.imageUrl,
  
  });

  factory Placa.fromJson(Map<String, dynamic> json) => Placa(
        codigo: json['Placa'],
        responseDateTime: json['response_date_time'] != null
            ? DateTime.parse(json['response_date_time']).toIso8601String()
            : null,
        imageUrl: json['image_url'],
      );

  Map<String, dynamic> toJson() => {
        'Placa': codigo,
      };
}