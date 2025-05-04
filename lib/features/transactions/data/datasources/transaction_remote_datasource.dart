import 'dart:convert';

import 'package:agunsa/features/transactions/data/models/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:http/http.dart' as http;

abstract class TransactionRemoteDatasource {
  Future<List<TransactionType>> getAllTransactions();
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
    static const String _baseUrl = 'https://hamilton-wt-ranks-specific.trycloudflare.com/api/TransactionsTypes';

  @override
  Future<List<TransactionType>> getAllTransactions() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> transactionsJson = data['data'];
        final List<TransactionType> transactions = transactionsJson
            .map((json) => TransactionTypeModel.fromJson(json))
            .toList();

        return transactions;
      } else {
        throw Exception('Error al obtener las transacciones. Código: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}