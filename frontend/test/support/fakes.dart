import 'package:handtext_ai/services/device_authenticator.dart';

class FakeDeviceAuthenticator implements DeviceAuthenticator {
  bool available = true;
  bool result = true;
  int calls = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate(String reason) async {
    calls++;
    return result;
  }
}
