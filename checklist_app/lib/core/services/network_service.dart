import 'dart:async';
import 'dart:convert';

import 'package:checklist_app/core/constants/constants.dart';
import 'package:checklist_app/core/services/hive_service.dart';
import 'package:checklist_app/model/exception.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkService {
  final Dio dio;
  final HiveService hiveService;
  final Connectivity connectivity;

  ConnectivityResult connection = ConnectivityResult.none;
  bool get hasConnection =>
      connection == ConnectivityResult.mobile ||
      connection == ConnectivityResult.wifi;

  NetworkService(
      {required this.dio,
      required this.hiveService,
      required this.connectivity}) {
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      connection = result;
    });
  }

  Future<Response> post({
    required String path,
    required JsonMap data,
    int statusCode = 200,
  }) async {
    try {
      final response = await dio.post(
        kBaseUrl + path,
        options: Options(
          method: 'POST',
          headers: {'Authorization': hiveService.getToken()},
        ),
        data: json.encode(data),
      );
      if (response.statusCode == statusCode) {
        return response;
      } else {
        throw CustomException(message: 'wrong code');
      }
    } on CustomException {
      rethrow;
    } on DioError catch (error) {
      debugPrint('DIO ${error.message}');
      throw CustomException(
          message: '${error.response?.data['message'] ?? 'sync failure'}');
    } catch (error) {
      debugPrint('CATCH $error');
      throw CustomException(message: '$error');
    }
  }

  Future<Response> get({
    required String path,
    JsonMap? query,
    int statusCode = 200,
  }) async {
    try {
      final response = await dio.get(
        kBaseUrl + path,
        options: Options(
          method: 'GET',
          headers: {'Authorization': hiveService.getToken()},
        ),
        queryParameters: query,
      );
      if (response.statusCode == statusCode) {
        return response;
      } else {
        throw CustomException(message: 'wrong code');
      }
    } on CustomException {
      rethrow;
    } on DioError catch (error) {
      debugPrint('${error.response}');
      throw CustomException(
          message: '${error.response?.data['message'] ?? 'sync failure'}');
    } catch (error) {
      debugPrint('$error');
      throw CustomException(message: '$error');
    }
  }

  Future<Response> delete({
    required String path,
    JsonMap? data,
    int statusCode = 200,
  }) async {
    try {
      final response = await dio.delete(
        kBaseUrl + path,
        options: Options(
          method: 'DELETE',
          headers: {'Authorization': hiveService.getToken()},
        ),
        data: json.encode(data),
      );
      if (response.statusCode == statusCode) {
        return response;
      } else {
        throw CustomException(message: 'wrong code');
      }
    } on CustomException {
      rethrow;
    } on DioError catch (error) {
      debugPrint('${error.response}');
      throw CustomException(
          message: '${error.response?.data['message'] ?? 'sync failure'}');
    } catch (error) {
      debugPrint('$error');
      throw CustomException(message: '$error');
    }
  }
}
