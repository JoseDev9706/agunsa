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
      id: json['id'] as int,
      name: json['name'] as String,
      isInOut: json['isInOut'] as bool,
      imageUrl: json['urlImage'] as String,
    );
  }
  
}
