import 'package:agunsa/features/transactions/domain/entities/peding_transaction.dart';

class PendingTransactionModel extends PendingTransaction {
  PendingTransactionModel(
      {required super.transactionNumber,
      required super.transactionTypeId,
      required super.transactionTypeName,
      required super.initialTransactionId,
      required super.epochCreatedDatetime,
      required super.createdByUserId,
      required super.createdDataTimeTransaction,
      required super.currentStatus});

  factory PendingTransactionModel.fromJson(Map<String, dynamic> json) {
    return PendingTransactionModel(
      transactionNumber: json['transactionNumber'] as String,
      transactionTypeName: json['transactionTypeName'] as String,
      transactionTypeId: json['transactionTypeId'] as int,
      initialTransactionId: json['initialTransactionId'] as int,
      epochCreatedDatetime: json['epochCreatedDatetime'] as int,
      createdByUserId: json['createdByUserId'] as int,
      currentStatus: json['currentStatus'] as bool,
      createdDataTimeTransaction: json['createdDataTimeTransaction'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionNumber': transactionNumber,
      'transactionTypeName': transactionTypeName,
      'transactionTypeId': transactionTypeId,
      'initialTransactionId': initialTransactionId,
      'epochCreatedDatetime': epochCreatedDatetime,
      'createdByUserId': createdByUserId,
      'currentStatus': currentStatus,
      'createdDataTimeTransaction': createdDataTimeTransaction,
    };
  }
}
