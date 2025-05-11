import 'dart:convert';
import 'dart:developer';

import 'package:agunsa/core/config/constants.dart';
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
  static const String _uploadImage = '${baseUrl}container-back';
  static const String _getTransactionTypes = '${baseUrl}transaction-type';
  @override
  Future<List<TransactionType>> getAllTransactions() async {
    try {
      final response = await http.get(Uri.parse(_getTransactionTypes));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        log('TransaccionesData: $data');
        log('Tipo de body: ${data['body'].runtimeType}');

        final List<dynamic> transactionsJson = jsonDecode(data['body']);
        log('Transacciones: $transactionsJson');

        final List<TransactionType> transactions = transactionsJson
            .map((json) => TransactionTypeModel.fromJson(json))
            .toList();

        return transactions;
} else {
        throw Exception(
            'Error al obtener las transacciones. Código: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in getAllTransactions: $e');
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
          'filename': image.fileName,
          'image_base64': image.base64,
        }),
      );

      log(response.body);

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
