import 'dart:convert';
import 'dart:developer';

import 'package:agunsa/core/class/image_params.dart';
import 'package:agunsa/core/config/constants.dart';
import 'package:agunsa/features/transactions/data/models/foto.dart';
import 'package:agunsa/features/transactions/data/models/precint.dart';
import 'package:agunsa/features/transactions/data/models/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/entities/deliver.dart';
import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:agunsa/features/transactions/domain/entities/placa.dart';
import 'package:agunsa/features/transactions/domain/entities/precint.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:http/http.dart' as http;

abstract class TransactionRemoteDatasource {
  Future<List<TransactionType>> getAllTransactions();
  Future<Foto> uploadImageToServer(ImageParams image, String idToken);
  Future<Precinct> uploadPrecint(ImageParams precintParam, String idToken);
  Future<Placa> upLoadPlaca(ImageParams placaParams, String idToken);
  Future<Conductor> getDni(ImageParams dniParams, String idToken);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  static const String _uploadImage = '${baseUrl}container-back';
  static const String _getTransactionTypes = '${baseUrl}transaction-type';
  static const String _getprecinto = '${baseUrl}precinto';
  static const String _getplaca = '${baseUrl}placa-camion';
  static const String _getdni = '${baseUrl}dni_conductor';

  Future<T> _genericRequest<T>({
    required String url,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) parseResponse,
    String? idToken,
  }) async {
    try {
      final uri = Uri.parse(url);
      final request = http.Request('GET', uri);

      request.headers['Content-Type'] = 'application/json';
      if (idToken != null) request.headers['Authorization'] = 'Bearer $idToken';

      request.body = jsonEncode(body);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = jsonDecode(response.body);

      log('Respuesta cruda: ${response.body}');

      // Validación de estructura para endpoints tipo Precint
      if (responseData.containsKey('statusCode')) {
        if (responseData['statusCode'] == 200) {
          return parseResponse(responseData);
        } else {
          throw Exception(
              'Error en API: ${responseData['statusCode']} - ${responseData['body']}');
        }
      }
      // Para endpoints simples como Foto
      else if (response.statusCode == 200) {
        return parseResponse(responseData);
      } else {
        throw Exception('Error HTTP ${response.statusCode}');
      }
    } catch (e) {
      log('Error en petición: $e');
      throw Exception('Error de conexión: $e');
    }
  }

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
  Future<FotoModel> uploadImageToServer(
      ImageParams image, String idToken) async {
    return _genericRequest<FotoModel>(
      url: _uploadImage,
      body: {
        'filename': image.fileName,
        'image_base64': image.base64,
      },
      idToken: idToken,
      parseResponse: (json) {
        // Procesar la respuesta anidada
        final bodyData =
            json['body'] is String ? jsonDecode(json['body']) : json['body'];
        log('bodyData: $bodyData');
        return FotoModel.fromJson(bodyData);
      },
    );
  }

// Implementación para PrecintModel
  @override
  Future<PrecintModel> uploadPrecint(
      ImageParams precintParam, String idToken) async {
    return _genericRequest<PrecintModel>(
      url: _getprecinto,
      body: {
        'filename': precintParam.fileName,
        'image_base64': precintParam.base64,
      },
      idToken: idToken,
      parseResponse: (json) {
        final bodyData =
            json['body'] is String ? jsonDecode(json['body']) : json['body'];
        log('bodyData precint: $bodyData');
        return PrecintModel.fromJson(bodyData);
      },
    );
  }

  @override
  Future<Conductor> getDni(ImageParams dniParams, String idToken) {
    return _genericRequest<Conductor>(
      url: _getdni,
      body: {
        'filename': dniParams.fileName,
        'image_base64': dniParams.base64,
      },
      idToken: idToken,
      parseResponse: (json) {
        final bodyData =
            json['body'] is String ? jsonDecode(json['body']) : json['body'];
        log('bodyData dni: $bodyData');
        return Conductor.fromJson(bodyData);
      },
    );
  }

  @override
  Future<Placa> upLoadPlaca(ImageParams placaParams, String idToken) {
    return _genericRequest<Placa>(
      url: _getplaca,
      body: {
        'filename': placaParams.fileName,
        'image_base64': placaParams.base64,
      },
      idToken: idToken,
      parseResponse: (json) {
        final bodyData =
            json['body'] is String ? jsonDecode(json['body']) : json['body'];
        log('bodyData placa: $bodyData');
        return Placa.fromJson(bodyData);
      },
    );
  }
}
