import 'dart:convert';

import 'package:hostel_finder/core/cache/token_cache_service.dart';

class JWTDecoder {

  static Future<DecodedJWTToken> decodedJWTToken() async {

    String? jwtToken = await TokenCacheService.getToken();
    List<String> parts = jwtToken!.split('.');
    String securePayload = parts[1];

    String normalizedPayload = base64Url.normalize(securePayload);
    List<int> decodedBytes = base64Url.decode(normalizedPayload);
    String decodePayload = utf8.decode(decodedBytes);

    Map<String, dynamic> decryptedPayload = jsonDecode(decodePayload);

    return DecodedJWTToken.fromJson(decryptedPayload);
  }
}

class DecodedJWTToken {
  final String role;
  final String sub;
  final int iat;
  final int exp;

  const DecodedJWTToken({required this.role, required this.sub, required this.iat, required this.exp});

  factory DecodedJWTToken.fromJson(Map<String, dynamic> json) => DecodedJWTToken(role: json['role'], sub: json['sub'], iat: json['iat'], exp: json['exp']);

  @override
  String toString() {
    return 'DecodedJWTToken{role: $role, sub: $sub, iat: $iat, exp: $exp}';
  }
}
