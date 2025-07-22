import 'package:app_security/app_security_api.dart';

class AppSecurity {
  static final _api = AppSecurityApi();

  static Future<bool?> isUseJailBrokenOrRoot() async {
    final result = await _api.isUseJailBrokenOrRoot();
    return result;
  }

  static Future<bool?> isDeviceUseVPN() async {
    final result = await _api.isDeviceUseVPN();
    return result;
  }

  static Future<bool?> isItRealDevice() async {
    final result = await _api.isItRealDevice();
    return result;
  }

  static Future<bool?> checkIsTheDeveloperModeOn() async {
    final result = await _api.checkIsTheDeveloperModeOn();
    return result;
  }

  static Future<bool?> isRunningInTestFlight() async {
    final result = await _api.isRunningInTestFlight();
    return result;
  }

  static Future<String?> getIMEI() async {
    final result = await _api.getIMEI();
    return result;
  }

  static Future<bool?> installedFromValidSource(List<String> sourceList) async {
    final result = await _api.installedFromValidSource(sourceList);
    return result;
  }

  static Future<String?> installedSource() async {
    final result = await _api.installSource();
    return result;
  }

  static Future<String?> getDeviceId() async {
    final result = await _api.getDeviceId();
    return result;
  }

  static Future<List<String>> isSafeEnvironment() async {
    final result = await _api.isSafeEnvironment();
    return result ?? [];
  }

  static Future<bool> isClonedApp() async {
    final result = await _api.isClonedApp();
    return result;
  }

  static Future<bool> openDeveloperSettings() async {
    final result = await _api.openDeveloperSettings();
    return result;
  }

  static Future<bool> addFlags(int flag) async {
    final result = await _api.addFlags(flag);
    return result;
  }

  static Future<bool> clearFlags(int flag) async {
    final result = await _api.clearFlags(flag);
    return result;
  }
}
