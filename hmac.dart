import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';

String getHmacAuthHeader({
  @required final String inputUrl,
  @required final dynamic inputJsonContent,
  @required final String appId,
  @required final String appSecrets,
  final String method = "POST",
}) {
  final url = _encodeUrl(inputUrl);
  final seconds =
      (DateTime.now().millisecondsSinceEpoch / 1000).round().toString();
  final nonce = "N${DateTime.now().millisecondsSinceEpoch}";

  final contentHash = _getMd5HashInBase64FromJson(inputJsonContent);

  final signature = "$appId$method$url$seconds$nonce$contentHash";

  final signatureHmacHashBase64 = _getHmacHashInBase64FromString(appSecrets, signature);

  final token = "$appId:$signatureHmacHashBase64:$nonce:$seconds";

  return "hmacauth $token";
}

String _encodeUrl(String url) {
  if (!url.startsWith("/")) {
    url = "/$url";
  }
  return Uri.encodeComponent(url).toLowerCase();
}

String _getMd5HashInBase64FromJson(dynamic json) {
  final jsonString = jsonEncode(json);
  final jsonStringBytes = Utf8Encoder().convert(jsonString);

  final hashBytes = md5.convert(jsonStringBytes).bytes;
  final hashBase64 = base64Encode(hashBytes);
  return hashBase64;
}

String _getHmacHashInBase64FromString(String key, String data){
  final keyBytes = Utf8Encoder().convert(key);
  final dataBytes = Utf8Encoder().convert(data);

  final hmacBytes = Hmac(sha256, keyBytes)
      .convert(dataBytes)
      .bytes;

  final hmacBase64 = base64Encode(hmacBytes);
  return hmacBase64;
}
