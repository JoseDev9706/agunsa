class Placa {
  final String codigo;
  final String? responseDateTime;
  final String? imageUrl;
  String? updatePlateDateTime; // Uncomment if needed

  Placa({
    required this.codigo,
    required this.responseDateTime,
    this.updatePlateDateTime,
    required this.imageUrl,
  
  });

  factory Placa.fromJson(Map<String, dynamic> json) => Placa(
        codigo: json['Placa'],
        responseDateTime: json['response_date_time'] != null
            ? DateTime.parse(json['response_date_time']).toIso8601String()
            : null,
        imageUrl: json['image_url'],
        updatePlateDateTime: json['update_plate_date_time'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'Placa': codigo,
        'response_date_time': responseDateTime,
        'image_url': imageUrl,
        'update_plate_date_time': updatePlateDateTime,
      };
}