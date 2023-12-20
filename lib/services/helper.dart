import 'package:shared_preferences/shared_preferences.dart';

Future<String> concatenation(String one, String two) async {
  final prefs = await SharedPreferences.getInstance();
  var name = [];
  name[0] = prefs.getString('first_name');
  name[1] = prefs.getString('last_name');
  return name.join(" ");
}
