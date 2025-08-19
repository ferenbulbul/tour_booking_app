import 'package:flutter_dotenv/flutter_dotenv.dart';

class Keys {
  static String get places => dotenv.env['PLACES_API_KEY'] ?? '';
}
