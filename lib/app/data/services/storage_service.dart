import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  static const _isSubscribedKey = 'is_subscribed';
  static const _subscriptionTypeKey = 'subscription_type';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  bool get isSubscribed => _prefs.getBool(_isSubscribedKey) ?? false;

  String get subscriptionType => _prefs.getString(_subscriptionTypeKey) ?? '';

  Future<void> saveSubscription(String type) async {
    await _prefs.setBool(_isSubscribedKey, true);
    await _prefs.setString(_subscriptionTypeKey, type);
  }
}
