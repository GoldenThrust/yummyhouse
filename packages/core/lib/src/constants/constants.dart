const backendHost = 'localhost';
const backendPort = 8000;

Uri get backendUri => Uri(
  scheme: 'http',
  host: backendHost,
  port: backendPort,
  path: '/api',
);
