class Precinct {
  final String codPrecinto;
  final String imageUrl;
  final DateTime? responseDateTime;
  String? updateDataSeal;
  Precinct({
    required this.codPrecinto,
    required this.imageUrl,
    this.responseDateTime,
    this.updateDataSeal,
  });
}
