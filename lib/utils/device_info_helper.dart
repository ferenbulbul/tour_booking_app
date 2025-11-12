import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 📦 Model sınıfı
class DeviceInfoModel {
  final String deviceId;
  final String deviceModel;

  DeviceInfoModel({required this.deviceId, required this.deviceModel});

  @override
  String toString() =>
      'DeviceInfo(deviceId: $deviceId, deviceModel: $deviceModel)';
}

/// 🧩 Yardımcı sınıf
class DeviceInfoHelper {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static final _uuid = const Uuid();

  /// 🔹 Platforma göre cihaz bilgilerini döndürür
  static Future<DeviceInfoModel> getDevice() async {
    try {
      String deviceId = "unknown";
      String deviceModel = "unknown";

      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        deviceId = info.id ?? info.fingerprint ?? _uuid.v4();
        deviceModel = "${info.manufacturer} ${info.model}";
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        deviceId = info.identifierForVendor ?? await _getPersistentUUID();
        deviceModel = "${info.name} (${info.systemName} ${info.systemVersion})";
      } else {
        // Web, Desktop veya diğer platformlar
        deviceId = await _getPersistentUUID();
        deviceModel = "Unknown Platform";
      }

      return DeviceInfoModel(deviceId: deviceId, deviceModel: deviceModel);
    } catch (e) {
      print("⚠️ Device info error: $e");
      return DeviceInfoModel(
        deviceId: await _getPersistentUUID(),
        deviceModel: "Error",
      );
    }
  }

  /// 🔹 Persistent UUID fallback (cihaz bazlı kimlik)
  static Future<String> _getPersistentUUID() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('device_id');
    if (id == null) {
      id = _uuid.v4();
      await prefs.setString('device_id', id);
    }
    return id;
  }
}
