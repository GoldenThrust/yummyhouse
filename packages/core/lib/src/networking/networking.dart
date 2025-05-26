import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:core/core.dart';

Future<List<T>> getRequest<T>(
  String path,
  T Function(Map<String, dynamic>) fromJson, {
  Map<String, String> headers = const {'Content-Type': 'application/json', 'Accept': 'application/json'},
}) async {
  Uri url = backendUri.replace(path: path);
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);

    if (body is List) {
      return body.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    } else if (body is Map<String, dynamic>) {
      return [fromJson(body)];
    } else {
      throw Exception('Unexpected response format');
    }
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}

Future<T> postRequest<T>(
  String path,
  Map<String, dynamic> body,
  T Function(Map<String, dynamic>) fromJson, {
  Map<String, String> headers = const {'Content-Type': 'application/json', 'Accept': 'application/json'},
}) async {
  Uri url = backendUri.replace(path: path);
  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    final decodedBody = jsonDecode(response.body);
    return fromJson(decodedBody as Map<String, dynamic>);
  } else {
    throw Exception('Failed to post data: ${response.statusCode}');
  }
}