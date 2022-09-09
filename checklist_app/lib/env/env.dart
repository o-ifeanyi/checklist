import 'env_config.dart';

class Env {
  factory Env() {
    return _singleton;
  }

  Env._internal();

  static final Env _singleton = Env._internal();

  static const String staging = 'staging';
  static const String production = 'production';

  late BaseConfig _config;
  BaseConfig get config => _config;

  initConfig(String environment) {
    switch (environment) {
      case Env.production:
        _config = ProductionEnv();
        break;
      case Env.staging:
        _config = StagingEnv();
        break;
      default:
        _config = StagingEnv();
        break;
    }
  }
}
