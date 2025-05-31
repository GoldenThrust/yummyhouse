import 'dart:convert';
import 'package:core/core.dart';
import 'package:http/http.dart' as http;

Future<List<T>> getRequest<T>(
  String path,
  T Function(Map<String, dynamic>) fromJson, {
  Map<String, String>? headers,
  Map<String, String>? queryParameters,
}) async {
  Uri url = backendUri.replace(path: 'api$path',
    queryParameters: queryParameters ?? {},
  );
  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...headers ?? {},
    },
  );

  if (response.statusCode == 200) {
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
