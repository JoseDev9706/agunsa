class Transaction {
  final String? containerNumber;
  final String? containerTransportLine;
  final String? containerIso;
  final String? containerType;
  final double? containerTara;
  final double? containerPayload;
  final String? createdDataContainer;
  final String? updatedDataContainer;
  final String? driverDni;
  final String? driverName;
  final String? driverLastName;
  final String? createdDataDriver;
  final String? updatedDataDriver;
  final String? plate;
  final String? createdDataPlate;
  final String? updatedDataPlate;
  final String? sealCode;
  final String? createdDataSeal;
  final String? updatedDataSeal;
  final String? transactionNumber;
  final int? initialTransactionId;
  final int? transactionTypeId;
  final int epochCreatedDatetime;
  final int createdByUserId;
  final bool? currentStatus;

  Transaction({
    this.containerNumber,
    this.containerTransportLine,
    this.containerIso,
    this.containerType,
    this.containerTara,
    this.containerPayload,
    this.createdDataContainer,
    this.updatedDataContainer,
    this.driverDni,
    this.driverName,
    this.driverLastName,
    this.createdDataDriver,
    this.updatedDataDriver,
    this.plate,
    this.createdDataPlate,
    this.updatedDataPlate,
    this.sealCode,
    this.createdDataSeal,
    this.updatedDataSeal,
    this.transactionNumber,
    this.initialTransactionId,
    this.transactionTypeId,
    required this.epochCreatedDatetime,
    required this.createdByUserId,
    this.currentStatus,
  });
}
