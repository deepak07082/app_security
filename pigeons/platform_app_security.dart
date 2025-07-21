import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class AppSecurityApi {
  bool isUseJailBrokenOrRoot();
  bool isDeviceUseVPN();
  bool isItRealDevice();
  bool checkIsTheDeveloperModeOn();
  bool isRunningInTestFlight();
  String? getIMEI();
  String? getDeviceId();
  String? installSource();
  List<String>? isSafeEnvironment();
  bool installedFromValidSource(List<String> sourceList);
  bool isClonedApp();
  bool openDeveloperSettings();
}
