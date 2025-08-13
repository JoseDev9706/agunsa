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
  String? updateDataContainer;

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
    this.updateDataContainer,
  });

  final Map<String, Map<String, dynamic>> codigoIsoInfo = {
  "22G1": {"dimension": 20, "tipo": "Estándar", "caracteres": "20DC"},
  "22U1": {"dimension": 20, "tipo": "Open Top", "caracteres": "20OT"},
  "22R1": {"dimension": 20, "tipo": "Reefers", "caracteres": "20RH"},
  "22K7": {"dimension": 20, "tipo": "Isotanque", "caracteres": "20TK"},
  "22FR": {"dimension": 20, "tipo": "Flat Rack", "caracteres": "20FR"},
  "42G1": {"dimension": 40, "tipo": "Estándar", "caracteres": "40DC"},
  "45G1": {"dimension": 40, "tipo": "High Cube", "caracteres": "40HC"},
  "45R1": {"dimension": 40, "tipo": "Reefers", "caracteres": "40RH"},
  "48K8": {"dimension": 40, "tipo": "Isotanque", "caracteres": "40TK"},
  "40FR": {"dimension": 40, "tipo": "Flat Rack", "caracteres": "40FR"},
  "42U1": {"dimension": 40, "tipo": "Open Top", "caracteres": "40OT"},
  "45U1": {"dimension": 40, "tipo": "Open Top", "caracteres": "40OT"},
  "L5G1": {"dimension": 45, "tipo": "High Cube", "caracteres": "45HC"},
  };
  String getTipoContenedor(String codPropietario) {
  final Map<String, dynamic> info = codigoIsoInfo[codPropietario]!;
  return '$codPropietario${info['caracteres']}';
}
  String get numeroContenedorAndtipoContenedor {
    return '$codPropietario$numSerie';
  }
}

