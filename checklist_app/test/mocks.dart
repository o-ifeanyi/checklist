import 'package:checklist_app/core/services/hive_service.dart';
import 'package:checklist_app/core/services/network_service.dart';
import 'package:checklist_app/interface/auth_repository.dart';
import 'package:checklist_app/interface/checklist_repository.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';

// Repositories
class MockAuthRepository extends Mock implements AuthRepository {}

class MockChecklistRepository extends Mock implements ChecklistRepository {}

// Service
class MockNetworkService extends Mock implements NetworkService {}

class MockHiveService extends Mock implements HiveService {}

// Externals
class MockDio extends Mock implements Dio {}
