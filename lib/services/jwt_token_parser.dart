import 'package:jwt_decoder/jwt_decoder.dart';

Map<String, dynamic> parseJwtAndSave(String token) {
  final decodedToken = JwtDecoder.decode(token);
  return decodedToken;
}
