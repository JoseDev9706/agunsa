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
    "22G1": {"dimension": 20, "tipo": "Estándar"},
    "22U1": {"dimension": 20, "tipo": "Open Top"},
    "22R1": {"dimension": 20, "tipo": "Reefer"},
    "22K7": {"dimension": 20, "tipo": "Isotanque"},
    "22FR": {"dimension": 20, "tipo": "Flat Rack"},
    "42G1": {"dimension": 40, "tipo": "Estandar"},
    "45G1": {"dimension": 40, "tipo": "High Cube"},
    "45R1": {"dimension": 40, "tipo": "Reefer"},
    "40FR": {"dimension": 40, "tipo": "Flat Rack"},
    "42U1": {"dimension": 40, "tipo": "Open Top"},
    "45U1": {"dimension": 40, "tipo": "Open Top"},
    "L5G1": {"dimension": 45, "tipo": "High Cube"},
  };
  String getTipoContenedor(String codPropietario) {
    final Map<String, dynamic> info = codigoIsoInfo[codPropietario]!;
    return '${info['dimension']}" - ${info['tipo'].toString()}';
  }
}