// const backendHost = '10.0.2.2';
import 'package:core/src/constants/env.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Uri get backendUri => Uri(
  scheme: 'http',
  host: backendHost,
  port: backendPort,
  path: '/api',
);

final storage = FlutterSecureStorage();