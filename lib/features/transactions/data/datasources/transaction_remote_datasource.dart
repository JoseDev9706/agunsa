import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agunsa/core/class/image_params.dart';
import 'package:agunsa/core/config/constants.dart';
import 'package:agunsa/features/transactions/data/models/foto.dart';
import 'package:agunsa/features/transactions/data/models/pending_transaction.dart';
import 'package:agunsa/features/transactions/data/models/precint.dart';
import 'package:agunsa/features/transactions/data/models/transaction.dart';
import 'package:agunsa/features/transactions/data/models/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/entities/deliver.dart';
import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:agunsa/features/transactions/domain/entities/placa.dart';
import 'package:agunsa/features/transactions/domain/entities/precint.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/entities/transactions.dart';
import 'package:http/http.dart' as http;

import '../../../../core/utils/code_utils.dart';

abstract class TransactionRemoteDatasource {
  Future<List<TransactionType>> getAllTransactions();
  Future<Foto?> uploadImageToServer(
    ImageParams image,
    String idToken,
  );
  Future<Precinct> uploadPrecint(ImageParams precintParam, String idToken);
  Future<Placa> upLoadPlaca(ImageParams placaParams, String idToken);
  Future<Conductor> getDni(ImageParams dniParams, String idToken);
  Future<String?> createTransaction(TransactionModel transaction);
  Future<List<TransactionModel>> getTransactionById(String id);
  Future<List<PendingTransactionModel>> getPendingTransactions(int userId);
  Future<String?> createPendingTransaction(PendingTransactionModel transaction);
  Future<Map<String, dynamic>> uploadLateralImages(String base64Image);
}

class TransactionRemoteDatasourceImpl implements TransactionRemoteDatasource {
  //static const String _uploadImage = '${baseUrl}container-back';

  //static const String _uploadImage = '${baseUrl}container-back';
  static const String _uploadImage = '${baseUrl}iaagent/model/container';

  static const String _getTransactionTypes =
      '${baseUrl}appmobile/backend/transaction-type';
  static const String _getprecinto = '${baseUrl}iaagent/model/seal';
  static const String _getplaca = '${baseUrl}iaagent/model/plate';
  static const String _getdni = '${baseUrl}iaagent/model/carrier';
  static const String _createTransaction =
      '${baseUrl}appmobile/backend/transaction';
  static const String _getTransactionById =
      '${baseUrl}appmobile/backend/transaction';
  static const String _getPendingTransactions =
      '${baseUrl}appmobile/backend/pending-transaction';
  static const String _createPendingTransaction =
      '${baseUrl}appmobile/backend/pending-transaction';

  Future<T> _genericRequest<T>({
    required String url,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) parseResponse,
    String? idToken,
  }) async {
    try {
      final uri = Uri.parse(url);
      final request = http.Request('POST', uri);
      //final idToken = await obtenerToken(); // ✅ aquí lo obtienes

      request.headers['Content-Type'] = 'application/json';
      log('Respuesta idToken: ${idToken}');
      if (idToken != null) request.headers['Authorization'] = 'Bearer $idToken';

      request.body = jsonEncode(body);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = jsonDecode(response.body);

      log('Respuesta cruda: ${response.body}');

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

  // Future<int> _sendImageToS3(String base64Image) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${baseUrl}presigned-url-images'),
  //       body: jsonEncode({
  //         "folder": "containerback",
  //         'image_base64': base64Image,
  //       }),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       final responseBody = jsonDecode(response.body);
  //       return responseBody['statusCode'];
  //     } else {
  //       log('Error al subir la imagen. Código: ${response.statusCode}');
  //       throw Exception(
  //           'Error al subir la imagen. Código: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     log('Error en uploadImage to S3: $e');
  //     throw Exception('Error al conectar con la API: $e');
  //   }
  // }

  Future<Map<String, dynamic>> _sendImageToS3(String base64Image) async {
    CodeUtils codeUtils = CodeUtils();
    try {
      final startTime = DateTime.now();
      final response = await http.post(
        Uri.parse('${baseUrl}presigned-url-images'),
        body: jsonEncode({
          "folder": "containerback",
          'image_base64': base64Image,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final endTime = DateTime.now();
      final elapsedMs = endTime.difference(startTime).inMilliseconds;
      log('📤 Tiempo de subida a S3: $elapsedMs ms (${(elapsedMs / 1000).toStringAsFixed(2)} s)');

      if (response.statusCode == 200) {
        final initialTimeToResponse = DateTime.now();
        final responseBody = jsonDecode(response.body);
        log('Respuesta de S3: $responseBody');
        final bodyData = jsonDecode(responseBody['body']);
        final imageUrl = bodyData['image_url'];
        final endTimeToResponse = DateTime.now();
        final elapsedMsToResponse =
            endTimeToResponse.difference(initialTimeToResponse).inMilliseconds;

        //log('📤 Tiempo de respuesta: $elapsedMsToResponse ms (${(elapsedMsToResponse / 1000).toStringAsFixed(2)} s)');

        return {
          'statusCode': responseBody['statusCode'],
          'imageUrl': imageUrl,
          'timeToResponse': "$elapsedMs ms",
          'DataTimeResponse': endTimeToResponse.toIso8601String(),
        };
      } else {
        final endTimeToResponse2 = DateTime.now();
        final elapsedMsToResponse2 =
            endTimeToResponse2.difference(startTime).inMilliseconds;
        log('📤 Tiempo de respuesta con error: $elapsedMsToResponse2 ms (${(elapsedMsToResponse2 / 1000).toStringAsFixed(2)} s)');
        log('Error al subir la imagen. Código: ${response.statusCode}');
        throw Exception(
            'Error al subir la imagen. Código: ${response.statusCode}');
      }
    } catch (e) {
      log('Error en uploadImage to S3: $e');
      throw Exception('Error al conectar con la API: $e');
    }
  }

  @override
  Future<List<TransactionType>> getAllTransactions() async {
    try {
      final response = await http.get(
        Uri.parse(_getTransactionTypes),
        headers: {
          'Content-Type': 'application/json',
        },
      );

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
    ImageParams image,
    String idToken,
  ) async {
    final response = await _sendImageToS3(image.base64);
    final statusCode = response['statusCode'];
    final imageUrl = response['imageUrl'];

    log('Status code de la imagen: $statusCode');
    if (statusCode != 200 || imageUrl == null) {
      throw Exception(
          'Error al subir la imagen a S3. Código: $statusCode, imageUrl: $imageUrl');
    }

    final stopwatch = Stopwatch()..start();

    final result = await _genericRequest<FotoModel>(
      url: _uploadImage,
      body: {
        'image_base64': image.base64,
        'image_url': imageUrl,
      },
      idToken: idToken,
      parseResponse: (json) {
        final bodyData =
            json['body'] is String ? jsonDecode(json['body']) : json['body'];
        log('bodyData: $bodyData');

        if (bodyData == null || bodyData.isEmpty) {
          throw Exception('Respuesta vacía o inválida al parsear bodyData');
        }

        final result = FotoModel.fromJson({
          ...bodyData,
          'image_url': imageUrl,
        });
        log('FotoModel result: $result');

        return result;
      },
    );

    stopwatch.stop();
    log('Tiempo de respuesta de la API: ${stopwatch.elapsedMilliseconds} ms');

    if (result == null) {
      throw Exception('El resultado de _genericRequest es null');
    }

    return result;
  }

// Implementación para PrecintModel
  @override
  Future<PrecintModel> uploadPrecint(
      ImageParams precintParam, String idToken) async {
    final response = await _sendImageToS3(precintParam.base64);
    final statusCode = response['statusCode'];
    final imageUrl = response['imageUrl'];
    final String dataTimeResponse = response['DataTimeResponse'];
    log('Status code de la imagen: $statusCode');
    if (statusCode != 200) {
      throw Exception('Error al subir la imagen a S3. Código: $statusCode');
    }
    return _genericRequest<PrecintModel>(
      url: _getprecinto,
      body: {
        // 'filename': precintParam.fileName,
        'image_base64': precintParam.base64,
        'image_url': imageUrl,
      },
      idToken: idToken,
      parseResponse: (json) {
        final bodyData =
            json['body'] is String ? jsonDecode(json['body']) : json['body'];
        final result = PrecintModel.fromJson({
          ...bodyData,
          'image_url': imageUrl,
          'response_date_time': dataTimeResponse
        });
        log('bodyData precint: $result');
        return result;
      },
    );
  }

  @override
  Future<Conductor> getDni(ImageParams dniParams, String idToken) async {
    final response = await _sendImageToS3(dniParams.base64);
    final statusCode = response['statusCode'];
    final imageUrl = response['imageUrl'];
    final String dataTimeResponse = response['DataTimeResponse'];
    log('Status code de la imagen: $statusCode');
    if (statusCode != 200) {
      throw Exception('Error al subir la imagen a S3. Código: $statusCode');
    }
    return _genericRequest<Conductor>(
      url: _getdni,
      body: {
        'image_base64': dniParams.base64,
        'image_url': imageUrl,
      },
      idToken: idToken,
      parseResponse: (json) {
        final bodyData =
            json['body'] is String ? jsonDecode(json['body']) : json['body'];
        final result = Conductor.fromJson({
          ...bodyData,
          'image_url': imageUrl,
          'response_date_time': dataTimeResponse
        });
        log('bodyData dni: $result');
        return result;
      },
    );
  }

  @override
  Future<Placa> upLoadPlaca(ImageParams placaParams, String idToken) async {
    final response = await _sendImageToS3(placaParams.base64);
    final statusCode = response['statusCode'];
    final imageUrl = response['imageUrl'];
    final String dataTimeResponse = response['DataTimeResponse'];
    log('Status code de la imagen: $statusCode');
    if (statusCode != 200) {
      throw Exception('Error al subir la imagen a S3. Código: $statusCode');
    }
    return _genericRequest<Placa>(
      url: _getplaca,
      body: {
        'filename': placaParams.fileName,
        'image_base64': placaParams.base64,
        'image_url': imageUrl,
      },
      idToken: idToken,
      parseResponse: (json) {
        final bodyData =
            json['body'] is String ? jsonDecode(json['body']) : json['body'];
        final result = Placa.fromJson({
          ...bodyData,
          'image_url': imageUrl,
          'response_date_time': dataTimeResponse
        });
        log('bodyData placa: $result');
        return result;
      },
    );
  }

  @override
  Future<String?> createTransaction(TransactionModel transaction) async {
    // ✅ Mostrar los datos que se van a enviar y sus tipos
    final jsonBody = transaction.toJson();
    jsonBody.forEach((key, value) {
      //log('🧾 Campo: $key - Valor: $value - Tipo: ${value.runtimeType}');
    });

    // ✅ Enviar solicitud
    final response = await http.post(
      Uri.parse(_createTransaction),
      body: jsonEncode(jsonBody),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final bodyField = responseBody['body'];
      if (bodyField != null) {
        final bodyDecoded = jsonDecode(bodyField);
        log('✅ Transacción creada: $bodyDecoded');
        return bodyDecoded['message'];
      } else {
        log('⚠️ Respuesta sin campo "body": ${response.body}');
        return null;
      }
    } else {
      //log('❌ Error al crear transacción - Código: ${response.statusCode}');
      //log('❌ Cuerpo de respuesta: ${response.body}');
      //log('transaction222: ${transaction.toJson()}'); // ⛔ AQUÍ puede haber nulls que provocan el error

      return null;
    }
  }

  @override
  Future<List<PendingTransactionModel>> getPendingTransactions(
      int userId) async {
    final response = await http.get(Uri.parse(_getPendingTransactions));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      log('Tipo de body: ${responseBody['body'].runtimeType}');

      final bodyString = responseBody['body'] as String;
      final data = jsonDecode(bodyString) as List;
      log('Transacciones pendientes: $data');

      return data
          .map((json) => PendingTransactionModel.fromJson(json))
          .toList();
    } else {
      log('Error al obtener las transacciones pendientes. Código: ${response.statusCode}');
      return [];
    }
  }

  @override
  Future<List<TransactionModel>> getTransactionById(String id) async {
    final response = await http.get(Uri.parse(_getTransactionById));
    List<TransactionModel> transactions = [];
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData.containsKey('statusCode')) {
        if (responseData['statusCode'] == 200) {
          final List<dynamic> data = responseData['body'];
          transactions =
              data.map((json) => TransactionModel.fromJson(json)).toList();
          return transactions;
        } else {
          log('Error al obtener la transacción por ID');
          return [];
        }
      }
    } else {
      log('Error al obtener la transacción por ID. Código: ${response.statusCode}');
      return [];
    }
    return transactions;
  }

  @override
  Future<String?> createPendingTransaction(
      PendingTransactionModel transaction) async {
    final response = await http.post(
      Uri.parse(_createPendingTransaction),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      log('Respuesta de la API: $responseData');

      if (responseData.containsKey('statusCode')) {
        if (responseData['statusCode'] == 200) {
          final responseBodyRaw = responseData['body'];
          late Map<String, dynamic> responseBody;

          if (responseBodyRaw is String) {
            responseBody = jsonDecode(responseBodyRaw);
          } else if (responseBodyRaw is Map<String, dynamic>) {
            responseBody = responseBodyRaw;
          } else {
            throw Exception('Formato inesperado en body: $responseBodyRaw');
          }

          log('Transacción pendiente creada: ${responseBody['message']}');
          return responseBody['message'];
        } else {
          log('Error al crear la transacción pendiente');
          return null;
        }
      }
    } else {
      log('Error al crear la transacción pendiente. Código: ${response.statusCode}');
      return null;
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> uploadLateralImages(String base64Image) async {
    CodeUtils codeUtils = CodeUtils();
    try {
      log('Subiendo imagen lateral a S3...');

      final response = await _sendImageToS3(base64Image);
      final statusCode = response['statusCode'];
      final imageUrl = response['imageUrl'];
      //final String timeToResponse = response['timeToResponse'];
      final String dataTimeResponse = response['DataTimeResponse'];

      //final fechaSinMilisegundos = fecha.replaceAll('.000', '');
      final fecha = DateTime.now()
          .toUtc()
          .copyWith(millisecond: 0, microsecond: 0)
          .toIso8601String();

      final fechaSinMilisegundos = fecha.replaceAll('.000', '');
      final rs = {
        'createdDataContainerLat':
            codeUtils.formatDateToIso8601(DateTime.now().toIso8601String()),
        'createdDataContainerLatRespoonse': dataTimeResponse,
        'imageUrl': imageUrl,
        'response_date_time': dataTimeResponse,
      };
      if (statusCode == 200) {
        return rs;
      } else {
        return rs
          ..addAll({
            'error': 'Error al subir la imagen lateral. Código: $statusCode',
          });
      }
    } catch (error) {
      log('Error al subir la imagen lateral remote: $error');
      return {
        'statusCode': 500,
        'error': 'Error al subir la imagen lateral remote 2: $error',
      };
    }
  }
}
