import 'dart:developer';

import 'package:agunsa/core/class/image_params.dart';
import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:agunsa/features/transactions/domain/entities/deliver.dart';
import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:agunsa/features/transactions/domain/entities/placa.dart';
import 'package:agunsa/features/transactions/domain/entities/precint.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:agunsa/features/transactions/domain/use_cases/upload_precinto.dart';
import 'package:dartz/dartz.dart';

class TransactionRespositoriesImpl implements TransactionRepositories {
  final TransactionRemoteDatasource remoteDataSource;

  TransactionRespositoriesImpl(this.remoteDataSource);
  @override
  Future<List<TransactionType>> getAllTransactions() {
    try {
      return remoteDataSource.getAllTransactions();
    } catch (e) {
      log('Error in getAllTransactions: $e');
      rethrow;
    }
  }

  @override
  Future<List<TransactionType>> getTransactionsByType(String type) {
    // TODO: implement getTransactionsByType
    throw UnimplementedError();
  }

  @override
  Future<Either<DomainExeptions, Foto>> uploadImageToServer(
      ImageParams image, String idToken) async {
    try {
      final result = await remoteDataSource.uploadImageToServer(image, idToken);
      return right(result);
    } catch (e) {
      log('Error in uploadImageToServer: $e');
      return left(DomainExeptions(e.toString()));
    }
  }

  @override
  Future<Either<DomainExeptions, Precinct>> uploadPrecint(
      ImageParams precintParam, String idToken) async {
    try {
      final result =
          await remoteDataSource.uploadPrecint(precintParam, idToken);
      return right(result);
    } catch (e) {
      log('Error en uploadPrecint: $e');
      return left(DomainExeptions(e.toString()));
    }
  }

  @override
  Future<Either<DomainExeptions, Conductor>> getDni(
      ImageParams dniParams, String idToken) async {
    try {
      final result = await remoteDataSource.getDni(dniParams, idToken);
      return right(result);
    } catch (e) {
      log('Error en getDni: $e');
      return left(DomainExeptions(e.toString()));
    }
  }

  @override
  Future<Either<DomainExeptions, Placa>> uploadPlaca(
      ImageParams image, String idToken) async {
    try {
      final result = await remoteDataSource.upLoadPlaca(image, idToken);
      return right(result);
    } catch (e) {
      log('Error en uploadPlaca: $e');
      return left(DomainExeptions(e.toString()));
    }
  }
}
