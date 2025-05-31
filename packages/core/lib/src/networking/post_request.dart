import 'dart:convert';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;

Future<List<T>> postRequest<T>(
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
    final body = jsonDecode(response.body);

    if (body is List) {
      return body.map((b) => fromJson(b as Map<String, dynamic>)).toList();
    } else if (body is Map<String, dynamic>) {
      return [fromJson(body)];
    } else {
      throw {'message': 'Unexpected response format'};
    }
  } else {
    throw jsonDecode(response.body);
  }
}
