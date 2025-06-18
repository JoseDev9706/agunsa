class Conductor {
  final String name1;
  final String? name2;
  final String lastName1;
  final String? lastName2;
  final String codLicence;
  final String imageUrl;
  final DateTime? responseDateTime;

  Conductor({
    required this.name1,
    required this.name2,
    required this.lastName1,
    required this.lastName2,
    required this.codLicence,
    required this.imageUrl,
    this.responseDateTime,
  });

  factory Conductor.fromJson(Map<String, dynamic> json) => Conductor(
        name1: json['Nombre_1'],
        name2: json['Nombre_2'] ?? '',
        lastName1: json['Apellido_1'],
        lastName2: json['Apellido_2'] ?? '',
        codLicence: json['cod_licencia'],
        imageUrl: json['image_url'] ?? '',
        responseDateTime: json['response_date_time'] != null
            ? DateTime.parse(json['response_date_time'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'Nombre_1': name1,
        'Nombre_2': name2,
        'Apellido_1': lastName1,
        'Apellido_2': lastName2,
        'cod_licencia': codLicence,
        'image_url': imageUrl,
        'response_date_time': responseDateTime?.toIso8601String(),
      };

  String get fullName {
    return '$name1 $name2';
  }
  String get fullLastName {
    return '$lastName1 $lastName2';
  }
}
