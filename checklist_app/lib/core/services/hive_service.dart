import 'package:checklist_app/core/util/themes.dart';
import 'package:hive/hive.dart';

class HiveService {
  final Box appDataBox;

  HiveService({required this.appDataBox});

  Future<void> setToken(String token) async {
    return appDataBox.put('token', token);
  }

  String getToken() {
    return appDataBox.get('token') ?? '';
  }

  Future<void> setTheme(ThemeOptions themeOption) async {
    return appDataBox.put('theme', themeOption.name);
  }
}
