class Transaction {
  final String? containerNumber;
  final String transactionTypeName;
  final String? containerTransportLine;
  final String? containerIso;
  final String? containerType;
  final double? containerTara;
  final double? containerPayload;
  final String? containerUrlImage;
  final String? createdDataContainer;
  final String? updatedDataContainer;
  final String? createDateContainerDateTimeRespone;
  final String? driverDni;
  final String? driverName;
  final String? driverLastName;
  final String? createdDataDriver;
  final String? updatedDataDriver;
  final String? createdDataDriverResponse;
  final String? driverUrlImage;
  final String? plate;
  final String? createdDataPlate;
  final String? updatedDataPlate;
  final String? createdDataPlateResponse;
  final String? plateUrlImage;
  final String? sealCode;
  final String? createdDataSeal;
  final String? updatedDataSeal;
  final String? transactionNumber;
  final List<String>? precintImagesUrl;
  final int? initialTransactionId;
  final int? transactionTypeId;
  final int epochCreatedDatetime;
  final int cratedDataTimeTransaction;
  final int createdByUserId;
  final bool? currentStatus;

  Transaction({
    this.containerNumber,
    required this.transactionTypeName,
    this.containerTransportLine,
    this.containerIso,
    this.containerType,
    this.containerTara,
    this.containerPayload,
    this.createdDataContainer,
    this.updatedDataContainer,
    this.createDateContainerDateTimeRespone,
    this.driverDni,
    this.driverName,
    this.driverLastName,
    this.createdDataDriver,
    this.updatedDataDriver,
    this.createdDataDriverResponse,
    this.plate,
    this.createdDataPlate,
    this.updatedDataPlate,
    this.createdDataPlateResponse,
    this.sealCode,
    this.createdDataSeal,
    this.updatedDataSeal,
    this.transactionNumber,
    this.initialTransactionId,
    this.transactionTypeId,
    required this.epochCreatedDatetime,
    required this.cratedDataTimeTransaction,
    required this.createdByUserId,
    this.currentStatus,
    this.containerUrlImage,
    this.driverUrlImage,
    this.plateUrlImage,
    this.precintImagesUrl,
  });
}
