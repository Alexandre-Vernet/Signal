import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserService {
  static const String _uuidKey = 'user_uuid';

  String? uuid;

  Future<String> getUuid() async {
    if (uuid != null) {
      return uuid!;
    }

    final prefs = await SharedPreferences.getInstance();

    uuid = prefs.getString(_uuidKey);

    if (uuid == null) {
      uuid = const Uuid().v4();
      await prefs.setString(_uuidKey, uuid!);
    }

    return uuid!;
  }
}