import 'dart:convert';

import 'package:agunsa/features/transactions/data/models/foto.dart';
import 'package:agunsa/features/transactions/data/models/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:http/http.dart' as http;

abstract class TransactionRemoteDatasource {
  Future<List<TransactionType>> getAllTransactions();
  Future<Foto> uploadImageToServer(Foto image, String idToken);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
    static const String _baseUrl = 'https://hamilton-wt-ranks-specific.trycloudflare.com/api/TransactionsTypes';
  static const String _uploadImage =
      'https://99w26g1h8j.execute-api.us-east-2.amazonaws.com/v1/container-back';
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
  
  @override
  Future<FotoModel> uploadImageToServer(Foto image, String idToken) async {
    try {
      final response = await http.post(
        Uri.parse(_uploadImage),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode({
          'body': {
            'filename': image.fileName,
            'imagebase64': image.base64,
          }
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Respuesta de la API: $data');
        return FotoModel.fromJson(data);
      } else {
        print('Error de servidor: ${response.statusCode} ${response.body}');
        throw Exception(
            'Error al subir la imagen a la API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }
}