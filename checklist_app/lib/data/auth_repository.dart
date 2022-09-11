import 'package:checklist_app/core/services/hive_service.dart';
import 'package:checklist_app/core/services/network_service.dart';
import 'package:checklist_app/interface/auth_repository.dart';
import 'package:checklist_app/model/exception.dart';
import 'package:checklist_app/model/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkService networkService;
  final HiveService hiveService;

  AuthRepositoryImpl({required this.networkService, required this.hiveService});

  @override
  Future<Either<CustomException, bool>> login(UserModel user) async {
    try {
      final response = await networkService.post(
        path: 'auth/login',
        data: {
          'email': user.email.trim(),
          'password': user.password.trim(),
        },
      );
      final token = response.headers.value('Token') ?? '';
      debugPrint('token from header is => $token');
      await hiveService.setToken(token);
      return const Right(true);
    } on CustomException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<CustomException, bool>> logout() async {
    try {
      await networkService.get(path: 'user/logout');
      await hiveService.setToken('');
      return const Right(true);
    } on CustomException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<CustomException, bool>> register(UserModel user) async {
    try {
      final response = await networkService.post(
        path: 'auth/register',
        statusCode: 201,
        data: {
          'email': user.email.trim(),
          'password': user.password.trim(),
        },
      );
      final token = response.headers.value('Token') ?? '';
      debugPrint('token from header is => $token');
      await hiveService.setToken(token);
      return const Right(true);
    } on CustomException catch (e) {
      return Left(e);
    }
  }
}
