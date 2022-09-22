import 'package:checklist_app/model/exception.dart';
import 'package:checklist_app/model/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<CustomException, bool>> login(UserModel user);
  Future<Either<CustomException, bool>> logout();
  Future<Either<CustomException, bool>> register(UserModel user);
  Future<Either<CustomException, bool>> delete();
}
