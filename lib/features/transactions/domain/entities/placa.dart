class Placa {
  final String codigo;
  

  Placa({
    required this.codigo,
  
  });

  factory Placa.fromJson(Map<String, dynamic> json) => Placa(
        codigo: json['cod_plate'],
      );

  Map<String, dynamic> toJson() => {
        'cod_plate': codigo,
      };
}