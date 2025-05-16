class PendingTransaction {
  final String transactionNumber;
  final int transactionTypeId;
  final int initialTransactionId;
  final int epochCreatedDatetime;
  final int createdByUserId;
  final bool currentStatus;

  PendingTransaction({
    required this.transactionNumber,
    required this.transactionTypeId,
    required this.initialTransactionId,
    required this.epochCreatedDatetime,
    required this.createdByUserId,
    required this.currentStatus,
  });
}