import 'package:agunsa/features/transactions/domain/entities/transactions.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    super.containerNumber,
    super.containerTransportLine,
    super.containerIso,
    super.containerType,
    super.containerTara,
    super.containerPayload,
    super.createdDataContainer,
    super.updatedDataContainer,
    super.driverDni,
    super.driverName,
    super.driverLastName,
    super.createdDataDriver,
    super.updatedDataDriver,
    super.plate,
    super.createdDataPlate,
    super.updatedDataPlate,
    super.sealCode,
    super.createdDataSeal,
    super.updatedDataSeal,
    super.transactionNumber,
    super.initialTransactionId,
    super.transactionTypeId,
    required super.epochCreatedDatetime,
    required super.createdByUserId,
    super.currentStatus,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      containerNumber: json['containerNumber'],
      containerTransportLine: json['containerTransportLine'],
      containerIso: json['containerIso'],
      containerType: json['containerType'],
      containerTara: json['containerTara'],
      containerPayload: json['containerPayload'],
      createdDataContainer:
          DateTime.parse(json['createdDataContainer']).toIso8601String(),
      updatedDataContainer:
          DateTime.parse(json['updatedDataContainer']).toIso8601String(),
      driverDni: json['driverDni'],
      driverName: json['driverName'],
      driverLastName: json['driverLastName'],
      createdDataDriver:
          DateTime.parse(json['createdDataDriver']).toIso8601String(),
      updatedDataDriver:
          DateTime.parse(json['updatedDataDriver']).toIso8601String(),
      plate: json['plate'],
      createdDataPlate:
          DateTime.parse(json['createdDataPlate']).toIso8601String(),
      updatedDataPlate:
          DateTime.parse(json['updatedDataPlate']).toIso8601String(),
      sealCode: json['sealCode'],
      createdDataSeal:
          DateTime.parse(json['createdDataSeal']).toIso8601String(),
      updatedDataSeal:
          DateTime.parse(json['updatedDataSeal']).toIso8601String(),
      transactionNumber: json['transactionNumber'],
      initialTransactionId: json['initialTransactionId'],
      transactionTypeId: json['transactionTypeId'],
      epochCreatedDatetime: json['epochCreatedDatetime'],
      createdByUserId: json['createdByUserId'],
      currentStatus: json['currentStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'containerNumber': containerNumber,
      'containerTransportLine': containerTransportLine,
      'containerIso': containerIso,
      'containerType': containerType,
      'containerTara': containerTara,
      'containerPayload': containerPayload,
      'createdDataContainer': createdDataContainer,
      'updatedDataContainer': updatedDataContainer,
      'driverDni': driverDni,
      'driverName': driverName,
      'driverLastName': driverLastName,
      'createdDataDriver': createdDataDriver,
      'updatedDataDriver': updatedDataDriver,
      'plate': plate,
      'createdDataPlate': createdDataPlate,
      'updatedDataPlate': updatedDataPlate,
      'sealCode': sealCode,
      'createdDataSeal': createdDataSeal,
      'updatedDataSeal': updatedDataSeal,
      'transactionNumber': transactionNumber,
      'initialTransactionId': initialTransactionId,
      'transactionTypeId': transactionTypeId,
      'epochCreatedDatetime': epochCreatedDatetime,
      'createdByUserId': createdByUserId,
      'currentStatus': currentStatus
    };
  }
}
