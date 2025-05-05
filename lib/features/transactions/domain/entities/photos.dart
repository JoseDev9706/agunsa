class Foto {
  final int? id;
  final String base64;
  final String? urlImagen;
  final DateTime fechaHora;
  final String? fileName;

  Foto(
      {this.id,
      required this.base64,
      this.urlImagen,
      required this.fechaHora,
      required this.fileName});
}
