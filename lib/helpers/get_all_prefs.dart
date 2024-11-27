import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> _getOwnerDetailsFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final givenName = prefs.getString('givenName') ?? 'Unknown';
  final surname = prefs.getString('surname') ?? '';
  final profilePic = prefs.getString('profilePic') ?? ''; // Add if available

  return {
    'givenName': givenName,
    'surname': surname,
    'profilePic': profilePic,
  };
}
