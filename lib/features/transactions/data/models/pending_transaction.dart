import 'package:agunsa/features/transactions/domain/entities/peding_transaction.dart';

class PendingTransactionModel extends PendingTransaction {
  PendingTransactionModel(
      {required super.transactionNumber,
      required super.transactionTypeId,
      required super.initialTransactionId,
      required super.epochCreatedDatetime,
      required super.createdByUserId,
      required super.currentStatus});

  factory PendingTransactionModel.fromJson(Map<String, dynamic> json) {
    return PendingTransactionModel(
      transactionNumber: json['transactionNumber'] as String,
      transactionTypeId: json['transactionTypeId'] as int,
      initialTransactionId: json['initialTransactionId'] as int,
      epochCreatedDatetime: json['epochCreatedDatetime'] as int,
      createdByUserId: json['createdByUserId'] as int,
      currentStatus: json['currentStatus'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionNumber': transactionNumber,
      'transactionTypeId': transactionTypeId,
      'initialTransactionId': initialTransactionId,
      'epochCreatedDatetime': epochCreatedDatetime,
      'createdByUserId': createdByUserId,
      'currentStatus': currentStatus,
    };
  }
}
