class PendingTransaction {
  final String transactionNumber;
  final String transactionTypeName;
  final int transactionTypeId;
  final int initialTransactionId;
  final int epochCreatedDatetime;
  final int createdByUserId;
  final bool currentStatus;
  final int createdDataTimeTransaction;

  PendingTransaction({
    required this.transactionNumber,
    required this.transactionTypeName,
    required this.transactionTypeId,
    required this.initialTransactionId,
    required this.epochCreatedDatetime,
    required this.createdByUserId,
    required this.currentStatus,
    required this.createdDataTimeTransaction,
  });
}