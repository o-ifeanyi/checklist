import 'package:checklist_app/core/constants/constants.dart';
import 'package:checklist_app/core/services/network_service.dart';
import 'package:checklist_app/model/user.dart';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

NetworkService _helper = MockNetworkService();
NetworkService get mockNetworkService => _helper;
final date = DateTime.now();

Future<Response<dynamic>> postFixture() {
  return _helper.post(
    path: any(named: 'path'),
    data: any(named: 'data'),
    statusCode: any(named: 'statusCode'),
  );
}

Future<Response<dynamic>> getFixture() {
  return _helper.get(
    path: any(named: 'path'),
    query: any(named: 'query'),
    statusCode: any(named: 'statusCode'),
  );
}

Future<Response<dynamic>> deleteFixture() {
  return _helper.delete(
    path: any(named: 'path'),
    data: any(named: 'data'),
    statusCode: any(named: 'statusCode'),
  );
}

UserModel get userModelFixture =>
    UserModel(email: 'ifeanyi@gmail.com', password: '123456');
