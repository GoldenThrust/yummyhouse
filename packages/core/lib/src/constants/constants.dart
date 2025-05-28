// const backendHost = '10.0.2.2';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const backendHost = '192.168.25.163';
const backendPort = 8000;

Uri get backendUri => Uri(
  scheme: 'http',
  host: backendHost,
  port: backendPort,
  path: '/api',
);

final storage = FlutterSecureStorage();
final key = 'secure_token';