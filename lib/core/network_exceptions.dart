// lib/core/network_exceptions.dart
import 'package:http/http.dart' as http;
import '../core/errors.dart';

AppError mapHttpError(http.Response r) {
  if (r.statusCode == 429) return AppError('Rate limit exceeded. Please wait a moment.');
  if (r.statusCode == 404) return AppError('Resource not found.');
  if (r.statusCode >= 500) return AppError('Server error. Try again later.');
  return AppError('Network error: ${r.statusCode}');
}
