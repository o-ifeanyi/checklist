import 'package:checklist_app/data/checklist_repository.dart';
import 'package:checklist_app/model/exception.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixture/Checklist_fixtures.dart';
import '../fixture/auth_fixtures.dart';
import '../mocks.dart';

void main() {
  late MockHiveService hiveService;
  late ChecklistRepositoryImpl checklistRepositoryImpl;
  late CustomException customException;

  setUp(() {
    hiveService = MockHiveService();
    customException = CustomException(message: 'Failed');
    checklistRepositoryImpl = ChecklistRepositoryImpl(
      networkService: mockNetworkService,
      hiveService: hiveService,
    );
    registerFallbackValue(checkListModelFixture);
  });

  group('Checklist repository - All', () {
    test('Should return a list of ChecklistModel when successful', () async {
      when(() => hiveService.allChecklist()).thenAnswer(
        (_) => Future.value([]),
      );

      final result = await checklistRepositoryImpl.all();

      expect(result.isRight(), equals(true));
    });
    test('Should return CustomException when it fails', () async {
      when(() => hiveService.allChecklist()).thenThrow(customException);

      final result = await checklistRepositoryImpl.all();

      expect(result, Left(customException));
    });
  });

  group('Checklist repository - Sync', () {
    test('Should return a list of ChecklistModel when successful', () async {
      when(() => postFixture()).thenAnswer(
        (_) => Future.value(Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: 'path'),
          data: [],
        )),
      );
      when(() => hiveService.allSyncLater()).thenAnswer(
        (_) => Future.value([]),
      );
      when(() => hiveService.insertAll([])).thenAnswer(
        (_) => Future.value(),
      );

      final result = await checklistRepositoryImpl.sync();

      expect(result.isRight(), equals(true));
    });
    test('Should return CustomException when it fails', () async {
      when(() => hiveService.allChecklist()).thenThrow(customException);

      final result = await checklistRepositoryImpl.all();

      expect(result, Left(customException));
    });
  });

  group('Checklist repository - Create', () {
    test('Should return true when successful', () async {
      when(() => mockNetworkService.hasConnection).thenReturn(true);
      when(() => hiveService.insert(any())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => hiveService.syncLater(any())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => postFixture()).thenAnswer(
        (_) => Future.value(Response(
            statusCode: 201, requestOptions: RequestOptions(path: 'path'))),
      );

      final result =
          await checklistRepositoryImpl.create(checkListModelFixture);
      expect(result, const Right(true));
    });
    test('Should return CustomException when it fails', () async {
      when(() => hiveService.insert(any())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => hiveService.syncLater(any())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => mockNetworkService.hasConnection).thenReturn(true);
      when(() => postFixture()).thenThrow(customException);

      final result =
          await checklistRepositoryImpl.create(checkListModelFixture);

      expect(result, Left(customException));
    });
  });

  group('Checklist repository - Update', () {
    test('Should return true when successful 1', () async {
      when(() => mockNetworkService.hasConnection).thenReturn(true);
      when(() => hiveService.insert(any())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => postFixture()).thenAnswer(
        (_) => Future.value(Response(
            statusCode: 200, requestOptions: RequestOptions(path: 'path'))),
      );

      final result =
          await checklistRepositoryImpl.update(checkListModelFixture);
      expect(result, const Right(true));
    });
    test('Should return CustomException when it fails', () async {
      when(() => hiveService.insert(any())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => hiveService.syncLater(any())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => mockNetworkService.hasConnection).thenReturn(true);
      when(() => postFixture()).thenThrow(customException);

      final result =
          await checklistRepositoryImpl.update(checkListModelFixture);

      expect(result, Left(customException));
    });
  });

  group('Checklist repository - Delete', () {
    test('Should return true when successful', () async {
      when(() => mockNetworkService.hasConnection).thenReturn(true);
      when(() => hiveService.deleteAll(any())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => deleteFixture()).thenAnswer(
        (_) => Future.value(Response(
            statusCode: 200, requestOptions: RequestOptions(path: 'path'))),
      );

      final result =
          await checklistRepositoryImpl.delete([checkListModelFixture]);
      expect(result, const Right(true));
    });
    test('Should return CustomException when it fails', () async {
      when(() => hiveService.deleteAll(any())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => hiveService.syncLater(any())).thenAnswer(
        (_) => Future.value(),
      );
      when(() => mockNetworkService.hasConnection).thenReturn(true);
      when(() => deleteFixture()).thenThrow(customException);

      final result =
          await checklistRepositoryImpl.delete([checkListModelFixture]);

      expect(result, Left(customException));
    });
  });
}
