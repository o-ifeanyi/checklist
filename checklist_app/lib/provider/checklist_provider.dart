import 'package:checklist_app/core/services/snackbar_service.dart';
import 'package:checklist_app/interface/checklist_repository.dart';
import 'package:checklist_app/model/checklist.dart';
import 'package:flutter/material.dart';

enum CheckState { idle, sync }

class ChecklistProvider extends ChangeNotifier {
  final ChecklistRepository checklistRepository;
  final SnackBarService snackBarService;
  ChecklistProvider(
      {required this.checklistRepository, required this.snackBarService});

  CheckState _checkState = CheckState.idle;
  CheckState get checkState => _checkState;
  void setState(CheckState state) {
    _checkState = state;
    notifyListeners();
  }

  List<ChecklistModel> allChecklist = [];

  Future<bool> getAll() async {
    final allEither = await checklistRepository.all();
    return allEither.fold(
      (exc) {
        snackBarService.displayMessage(exc.message);
        return false;
      },
      (checklists) {
        allChecklist = checklists;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> sync(List<ChecklistModel> checklists) async {
    setState(CheckState.sync);
    final syncEither = await checklistRepository.sync(checklists);
    setState(CheckState.idle);
    return syncEither.fold(
      (exc) {
        snackBarService.displayMessage(exc.message);
        return false;
      },
      (checklists) {
        allChecklist = checklists;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> create(ChecklistModel checklist) async {
    final createEither = await checklistRepository.create(checklist);
    return createEither.fold(
      (exc) {
        snackBarService.displayMessage(exc.message);
        return false;
      },
      (done) => done,
    );
  }

  Future<bool> update(ChecklistModel checklist) async {
    final updateEither = await checklistRepository.update(checklist);
    return updateEither.fold(
      (exc) {
        snackBarService.displayMessage(exc.message);
        return false;
      },
      (done) => done,
    );
  }

  Future<bool> delete(ChecklistModel checklist) async {
    final deleteEither = await checklistRepository.delete(checklist);
    return deleteEither.fold(
      (exc) {
        snackBarService.displayMessage(exc.message);
        return false;
      },
      (done) => done,
    );
  }
}
