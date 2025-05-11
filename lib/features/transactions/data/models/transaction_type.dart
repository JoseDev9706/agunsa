import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';

class TransactionTypeModel extends TransactionType {
  TransactionTypeModel({
    required int id,
    required String name,
    required bool isInOut,
    required String imageUrl,
  }) : super(
          id: id,
          name: name,
          isInOut: isInOut,
          imageUrl: imageUrl,
        );

  factory TransactionTypeModel.fromJson(Map<String, dynamic> json) {
    return TransactionTypeModel(
      id: json['Id'] as int,
      name: json['Name'] as String,
      isInOut: json['isInOut'] as bool,
      imageUrl: json['UrlImage'] as String,
    );
  }
  
}
