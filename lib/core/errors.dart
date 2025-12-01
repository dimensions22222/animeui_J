// lib/core/errors.dart
class AppError {
  final String message;
  final dynamic original;
  AppError(this.message, [this.original]);
  @override
  String toString() => message;
}

