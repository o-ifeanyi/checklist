import 'package:checklist_app/core/services/snackbar_service.dart';
import 'package:checklist_app/model/exception.dart';
import 'package:checklist_app/provider/auth_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixture/auth_fixtures.dart';
import '../mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthProvider authProvider;
  late SnackBarService snackBarService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    snackBarService = SnackBarService();
    authProvider = AuthProvider(
      authRepository: mockAuthRepository,
      snackBarService: snackBarService,
    );
    registerFallbackValue(userModelFixture);
  });

  group('Auth Provider - Register', () {
    test('Should return a true when successful', () async {
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) => Future.value(const Right(true)));

      final result = await authProvider.register(userModelFixture);

      expect(result, equals(true));
    });
    test('Should return a false when un-successful', () async {
      when(
        () => mockAuthRepository.register(any()),
      ).thenAnswer((_) =>
          Future.value(Left(CustomException(message: 'Failed to register'))));

      final result = await authProvider.register(userModelFixture);

      expect(result, equals(false));
    });
  });

  group('Auth Provider - Login', () {
    test('Should return true when successful', () async {
      when(
        () => mockAuthRepository.login(any()),
      ).thenAnswer((_) => Future.value(const Right(true)));

      final result = await authProvider.login(userModelFixture);

      expect(result, equals(true));
    });
    test('Should return a false when un-successful', () async {
      when(
        () => mockAuthRepository.login(any()),
      ).thenAnswer((_) =>
          Future.value(Left(CustomException(message: 'Failed to login'))));

      final result = await authProvider.login(userModelFixture);

      expect(result, equals(false));
    });
  });

  group('Auth Provider - Logout', () {
    test('Should return true when successful', () async {
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) => Future.value(const Right(true)));

      final result = await authProvider.logout();

      expect(result, equals(true));
    });
    test('Should return false when un-successful', () async {
      when(
        () => mockAuthRepository.logout(),
      ).thenAnswer((_) =>
          Future.value(Left(CustomException(message: 'Failed to logout'))));

      final result = await authProvider.logout();

      expect(result, equals(false));
    });
  });

  group('Auth Provider - Delete', () {
    test('Should return true when successful', () async {
      when(
        () => mockAuthRepository.delete(),
      ).thenAnswer((_) => Future.value(const Right(true)));

      final result = await authProvider.delete();

      expect(result, equals(true));
    });
    test('Should return false when un-successful', () async {
      when(
        () => mockAuthRepository.delete(),
      ).thenAnswer((_) =>
          Future.value(Left(CustomException(message: 'Failed to logout'))));

      final result = await authProvider.delete();

      expect(result, equals(false));
    });
  });
}
