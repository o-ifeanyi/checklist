abstract class BaseConfig {
  String get baseUrl;
}

class StagingEnv implements BaseConfig {
  @override
  String get baseUrl => 'http://localhost:8080/';
}

class ProductionEnv implements BaseConfig {
  @override
  String get baseUrl => '';
}
