import 'package:checklist_app/core/services/hive_service.dart';
import 'package:checklist_app/core/services/network_service.dart';
import 'package:checklist_app/interface/checklist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:checklist_app/model/exception.dart';
import 'package:checklist_app/model/checklist.dart';
import 'package:flutter/foundation.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final NetworkService networkService;
  final HiveService hiveService;

  ChecklistRepositoryImpl(
      {required this.networkService, required this.hiveService});

  @override
  Future<Either<CustomException, List<ChecklistModel>>> all() async {
    try {
      final all = await hiveService.allChecklist();

      return Right(all);
    } on CustomException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<CustomException, bool>> create(ChecklistModel checklist) async {
    try {
      await hiveService.insert(checklist);

      if (networkService.hasConnection) {
        await networkService.post(
          path: 'user/create',
          data: checklist.toMap(),
          statusCode: 201,
        );
      } else {
        checklist = checklist.copyWith(action: SyncAction.create);
        await hiveService.syncLater(checklist);
      }
      return const Right(true);
    } on CustomException catch (e) {
      checklist = checklist.copyWith(action: SyncAction.create);
      await hiveService.syncLater(checklist);
      return Left(e);
    }
  }

  @override
  Future<Either<CustomException, bool>> delete(
      List<ChecklistModel> checklists) async {
    try {
      await hiveService.deleteAll(checklists.map((e) => e.id));

      if (networkService.hasConnection) {
        await networkService.delete(
          path: 'user/delete',
          data: {'data': checklists.map((e) => e.toMap()).toList()},
        );
      } else {
        checklists = checklists
            .map((e) => e.copyWith(action: SyncAction.delete))
            .toList();
        checklists.forEach((element) async {
          await hiveService.syncLater(element);
        });
      }
      return const Right(true);
    } on CustomException catch (e) {
      checklists =
          checklists.map((e) => e.copyWith(action: SyncAction.delete)).toList();
      checklists.forEach((element) async {
        await hiveService.syncLater(element);
      });
      return Left(e);
    }
  }

  @override
  Future<Either<CustomException, List<ChecklistModel>>> sync() async {
    try {
      final data = await hiveService.allSyncLater();
      debugPrint('SYNC CALLED WITH ${data.length} ITEMS');

      final response = await networkService.post(
        path: 'user/sync',
        data: {'data': data.map((e) => e.toMap()).toList()},
      );

      final synched = (response.data['data'] as List)
          .map((e) => ChecklistModel.fromJson(e))
          .toList();

      await hiveService.insertAll(synched);
      return Right(synched);
    } on CustomException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<CustomException, bool>> update(ChecklistModel checklist) async {
    try {
      await hiveService.insert(checklist);

      if (networkService.hasConnection) {
        await networkService.post(
          path: 'user/update',
          data: checklist.toMap(),
        );
      } else {
        checklist = checklist.copyWith(action: SyncAction.update);
        await hiveService.syncLater(checklist);
      }
      return const Right(true);
    } on CustomException catch (e) {
      checklist = checklist.copyWith(action: SyncAction.update);
      await hiveService.syncLater(checklist);
      return Left(e);
    }
  }
}
