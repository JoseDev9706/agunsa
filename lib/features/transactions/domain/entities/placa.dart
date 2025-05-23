class Placa {
  final String codigo;
  

  Placa({
    required this.codigo,
  
  });

  factory Placa.fromJson(Map<String, dynamic> json) => Placa(
        codigo: json['Placa'],
      );

  Map<String, dynamic> toJson() => {
        'Placa': codigo,
      };
}