class Precinct {
  final String codPrecinto;
  final String imageUrl;
  final DateTime? responseDateTime;

  Precinct({
    required this.codPrecinto,
    required this.imageUrl,
    this.responseDateTime,
  });
}