import 'package:supabase_flutter/supabase_flutter.dart';

class AppException implements Exception {
  final String message;
  AppException(this.message);
  @override
  String toString() => message;
}

String? getErrorMessage(Object? error) {
  try {
    if (error is AppException) {
      return error.message;
    }
    if (error is AuthException) {
      return error.message;
    }
    if (error is PostgrestException) {
      return error.message;
    }
    if (error is StorageException) {
      return error.message;
    }
    if (error is FunctionException) {
      return error.reasonPhrase ?? error.details?.toString();
    }
    if (error is RealtimeSubscribeException) {
      return error.details?.toString();
    }
    return error?.toString();
  } catch (e) {
    return null;
  }
}
