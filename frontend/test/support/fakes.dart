import 'dart:io';
import 'dart:typed_data';

import 'package:handtext_ai/models/history_entry.dart';
import 'package:handtext_ai/services/history_store.dart';
import 'package:handtext_ai/services/device_authenticator.dart';

const _pngSignature = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];

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

Uint8List fakePngBytes() =>
    Uint8List.fromList([..._pngSignature, ...List.filled(64, 0)]);

Uint8List fakeJpegBytes() =>
    Uint8List.fromList([0xFF, 0xD8, 0xFF, ...List.filled(64, 0)]);

class InMemoryHistoryStore implements HistoryStore {
  List<HistoryEntry> stored = const [];
  int saves = 0;
  int deletes = 0;
  bool failSaves = false;

  @override
  Future<List<HistoryEntry>> load() async => stored;

  @override
  Future<void> save(List<HistoryEntry> entries) async {
    if (failSaves) throw const FileSystemException('sin espacio');
    saves++;
    stored = entries;
  }

  @override
  Future<void> delete() async {
    deletes++;
    stored = const [];
  }
}
