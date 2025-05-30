import 'dart:convert';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;


Future<T> postRequest<T>(
  String path,
  Map<String, dynamic> body,
  T Function(Map<String, dynamic>) fromJson, {
  Map<String, String>? headers,
}) async {
  Uri url = backendUri.replace(path: 'api$path');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...headers ?? {},
    },
    body: jsonEncode(body),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final decodedBody = jsonDecode(response.body);

    return fromJson(decodedBody);
  } else {
    throw jsonDecode(response.body);
  }
}
