import 'package:checklist_app/data/auth_repository.dart';
import 'package:checklist_app/model/exception.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixture/auth_fixtures.dart';
import '../mocks.dart';

void main() {
  late MockHiveService hiveService;
  late AuthRepositoryImpl authRepositoryImpl;
  late CustomException customException;

  setUp(() {
    hiveService = MockHiveService();
    customException = CustomException(message: 'Failed');
    authRepositoryImpl = AuthRepositoryImpl(
        networkService: mockNetworkService, hiveService: hiveService);
  });

  group('Auth repository - Register', () {
    test('Should return true when successful', () async {
      when(() => hiveService.setToken(any())).thenAnswer((_) => Future.value());
      when(() => postFixture()).thenAnswer((_) => Future.value(
            Response(
                statusCode: 201, requestOptions: RequestOptions(path: 'path')),
          ));

      final result = await authRepositoryImpl.register(userModelFixture);

      expect(result, const Right(true));
    });
    test('Should return CustomException when it fails', () async {
      when(() => postFixture()).thenThrow(customException);

      final result = await authRepositoryImpl.register(userModelFixture);

      expect(result, Left(customException));
    });
  });

  group('Auth repository - Login', () {
    test('Should return true when successful', () async {
      when(() => hiveService.setToken(any())).thenAnswer((_) => Future.value());
      when(() => postFixture()).thenAnswer(
        (_) => Future.value(Response(
            statusCode: 200, requestOptions: RequestOptions(path: 'path'))),
      );

      final result = await authRepositoryImpl.login(userModelFixture);

      expect(result, const Right(true));
    });
    test('Should return CustomException when it fails', () async {
      when(() => postFixture()).thenThrow(customException);

      final result = await authRepositoryImpl.login(userModelFixture);

      expect(result, Left(customException));
    });
  });

  group('Auth repository - Logout', () {
    test('Should return true when successful', () async {
      when(() => hiveService.setToken(any())).thenAnswer((_) => Future.value());
      when(() => getFixture()).thenAnswer(
        (_) => Future.value(Response(
            statusCode: 200, requestOptions: RequestOptions(path: 'path'))),
      );

      final result = await authRepositoryImpl.logout();

      expect(result, const Right(true));
    });
    test('Should return CustomException when it fails', () async {
      when(() => getFixture()).thenThrow(customException);

      final result = await authRepositoryImpl.logout();

      expect(result, Left(customException));
    });
  });

  group('Auth repository - Delete', () {
    test('Should return true when successful', () async {
      when(() => hiveService.clearAll()).thenAnswer((_) => Future.value());
      when(() => hiveService.setToken(any())).thenAnswer((_) => Future.value());
      when(() => deleteFixture()).thenAnswer(
        (_) => Future.value(Response(
            statusCode: 200, requestOptions: RequestOptions(path: 'path'))),
      );

      final result = await authRepositoryImpl.delete();

      expect(result, const Right(true));
    });
    test('Should return CustomException when it fails', () async {
      when(() => deleteFixture()).thenThrow(customException);

      final result = await authRepositoryImpl.delete();

      expect(result, Left(customException));
    });
  });
}
