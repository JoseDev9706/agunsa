import 'dart:convert';
import 'dart:developer';

import 'package:agunsa/core/config/constants.dart';
import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/data/models/foto.dart';
import 'package:agunsa/features/transactions/data/models/precint.dart';
import 'package:agunsa/features/transactions/data/models/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:agunsa/features/transactions/domain/entities/precint.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/use_cases/upload_precinto.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

abstract class TransactionRemoteDatasource {
  Future<List<TransactionType>> getAllTransactions();
  Future<Foto> uploadImageToServer(Foto image, String idToken);
  Future<Precinct> uploadPrecint(PrecinctParam precintParam, String idToken);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  static const String _uploadImage = '${baseUrl}container-back';
  static const String _getTransactionTypes = '${baseUrl}transaction-type';
  static const String _getprecinto = '${baseUrl}precinto';
  static const String _getplaca = '${baseUrl}placa-camion';
  static const String _getdni = '${baseUrl}dni_conductor';
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
        log('Respuesta de la API: $data');
        return FotoModel.fromJson(data);
      } else {
        log('Error de servidor: ${response.statusCode} ${response.body}');
        throw Exception(
            'Error al subir la imagen a la API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con la API: $e');
    }
  }

  @override
  Future<PrecintModel> uploadPrecint(
      PrecinctParam precintParam, String idToken) async {
    final url = Uri.parse(_getprecinto);

    final request = http.Request('GET', url);

    // 1. Configurar headers correctamente
    request.headers['Content-Type'] = 'application/json';
    // request.headers['Authorization'] = 'Bearer $idToken';

    // 2. Estructurar el JSON correctamente (con llaves)
    request.body = jsonEncode({
      'filename': precintParam.fileName,
      'image_base64': precintParam.base64,
    });

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // 3. Decodificar el body de la respuesta (que también es JSON)
    final responseBody = jsonDecode(response.body);

    if (responseBody.containsKey('statusCode') &&
        responseBody['statusCode'] == 200) {
      if (responseBody['body'] is String) {
        try {
          final innerData = jsonDecode(responseBody['body']);
          final model = PrecintModel.fromJson(innerData);
          log('Precinto: ${model.toJson()}');
          return model;
        } catch (e) {
          throw Exception('Error decodificando body interno: $e');
        }
      } else {
        throw Exception('Formato inválido: el body no es un string');
      }
    } else {
      throw Exception(
          'Error ${responseBody['statusCode']}: ${responseBody['body']}');
    }
  }

}
