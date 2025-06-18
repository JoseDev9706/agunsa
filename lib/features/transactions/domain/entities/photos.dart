class Foto {
  final String codPropietario;
  final String numSerie;
  final String numControl;
  final String tipoContenedor;
  final String maxGrossKg;
  final String maxGrossLbs;
  final String taraKg;
  final String taraLbs;
  final String payloadKg;
  final String payloadLbs;
  final DateTime? responseDateTime;
  final String? imageUrl;

  Foto({
    required this.codPropietario,
    required this.numSerie,
    required this.numControl,
    required this.tipoContenedor,
    required this.maxGrossKg,
    required this.maxGrossLbs,
    required this.taraKg,
    required this.taraLbs,
    required this.payloadKg,
    required this.payloadLbs,
    this.responseDateTime,
    this.imageUrl,
  });
}
