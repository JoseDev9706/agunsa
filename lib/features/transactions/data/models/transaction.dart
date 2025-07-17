import 'package:agunsa/features/transactions/domain/entities/transactions.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    super.containerNumber,
    required super.transactionTypeName,
    super.containerTransportLine,
    super.containerIso,
    super.containerType,
    super.containerTara,
    super.containerPayload,
    super.createdDataContainer,
    super.updatedDataContainer,
    super.createDateContainerDateTimeRespone,
    super.createdDataContainerLat,
    super.createdDataContainerLatResponse,
    super.containerUrlImageLat,
    super.driverDni,
    super.driverName,
    super.driverLastName,
    super.createdDataDriver,
    super.updatedDataDriver,
    super.createdDataDriverResponse,
    super.plate,
    super.createdDataPlate,
    super.updatedDataPlate,
    super.createdDataPlateResponse,
    super.sealCode,
    super.sealcodesList,
    super.createdDataSeal,
    super.updatedDataSeal,
    super.createdDataSealResponse,
    super.transactionNumber,
    super.initialTransactionId,
    super.transactionTypeId,
    required super.epochCreatedDatetime,
    required super.cratedDataTimeTransaction,
    required super.createdByUserId,
    super.currentStatus,
    super.containerUrlImage,
    super.driverUrlImage,
    super.plateUrlImage,
    super.precintImagesUrl,
      
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      containerNumber: json['containerNumber'],
      transactionTypeName: json['transactionTypeName'],
      containerTransportLine: json['containerTransportLine'],
      containerIso: json['containerIso'],
      containerType: json['containerType'],
      containerTara: json['containerTara'],
      containerPayload: json['containerPayload'],
      createdDataContainer:
          DateTime.parse(json['createdDataContainer']).toIso8601String(),
      updatedDataContainer:
          DateTime.parse(json['updatedDataContainer']).toIso8601String(),
      createDateContainerDateTimeRespone:
          json['createDateContainerDateTimeRespone'] != null
              ? DateTime.parse(json['createDateContainerDateTimeRespone']).toIso8601String()
              : null,
      createdDataContainerLat:
          DateTime.parse(json['createdDataContainerLat']).toIso8601String(),
      createdDataContainerLatResponse:
          json['createdDataContainerLatResponse'] != null
              ? DateTime.parse(json['createdDataContainerLatResponse']) .toIso8601String() : null,
      containerUrlImageLat: (json['containerUrlImageLat']),
      driverDni: json['driverDni'],
      driverName: json['driverName'],
      driverLastName: json['driverLastName'],
      createdDataDriver:
          DateTime.parse(json['createdDataDriver']).toIso8601String(),
      updatedDataDriver:
          DateTime.parse(json['updatedDataDriver']).toIso8601String(),
      createdDataDriverResponse: json['createdDataDriverResponse'],
      plate: json['plate'],
      createdDataPlate:
          DateTime.parse(json['createdDataPlate']).toIso8601String(),
      updatedDataPlate:
          DateTime.parse(json['updatedDataPlate']).toIso8601String(),
      createdDataPlateResponse: json['createdDataPlateResponse'],
      sealCode: json['sealCode'],
      sealcodesList: json['sealcodesList'],
      
      createdDataSeal:
          DateTime.parse(json['createdDataSeal']).toIso8601String(),
      updatedDataSeal:
          DateTime.parse(json['updatedDataSeal']).toIso8601String(),
      createdDataSealResponse:
          DateTime.parse(json['createdDataSealResponse']).toIso8601String(),
      transactionNumber: json['transactionNumber'],
      initialTransactionId: json['initialTransactionId'],
      transactionTypeId: json['transactionTypeId'],
      epochCreatedDatetime: json['epochCreatedDatetime'],
      cratedDataTimeTransaction: json['cratedDataTimeTransaction'],
      createdByUserId: json['createdByUserId'],
      currentStatus: json['currentStatus'],
      containerUrlImage: json['containerUrlImage'],
      driverUrlImage: json['driverUrlImage'],
      plateUrlImage: json['plateUrlImage'],
      precintImagesUrl: json['precintImagesUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'containerNumber': containerNumber,
      'transactionTypeName': transactionTypeName,
      'containerTransportLine': containerTransportLine,
      'containerIso': containerIso,
      'containerType': containerType,
      'containerTara': containerTara,
      'containerPayload': containerPayload,
      'createdDataContainer': createdDataContainer,
      'updatedDataContainer': updatedDataContainer,
      'createDateContainerDateTimeRespone': createDateContainerDateTimeRespone,
      'driverDni': driverDni,
      'driverName': driverName,
      'driverLastName': driverLastName,
      'createdDataDriver': createdDataDriver,
      'updatedDataDriver': updatedDataDriver,
      'createdDataDriverResponse': createdDataDriverResponse,
      'plate': plate,
      'createdDataPlate': createdDataPlate,
      'updatedDataPlate': updatedDataPlate,
      'createdDataPlateResponse': createdDataPlateResponse,
      'sealCode': sealCode,
      'createdDataSeal': createdDataSeal,
      'updatedDataSeal': updatedDataSeal,
      'transactionNumber': transactionNumber,
      'initialTransactionId': initialTransactionId,
      'transactionTypeId': transactionTypeId,
      'epochCreatedDatetime': epochCreatedDatetime,
      'cratedDataTimeTransaction': cratedDataTimeTransaction,
      'createdByUserId': createdByUserId,
      'currentStatus': currentStatus,
      'containerUrlImage': containerUrlImage,
      'driverUrlImage': driverUrlImage,
      'plateUrlImage': plateUrlImage,
      'precintImagesUrl': precintImagesUrl,
      'createdDataContainerLat': createdDataContainerLat,
      'createdDataContainerLatResponse': createdDataContainerLatResponse,
      'containerUrlImageLat': containerUrlImageLat,
      'sealcodesList': sealcodesList,
      'createdDataSealResponse': createdDataSealResponse,
      
    };
  }
}
