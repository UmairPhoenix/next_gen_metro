class AppExceptions implements Exception {
  String message = 'unknown';
  String prefix = 'unknown';
  AppExceptions(this.message, this.prefix);

  @override
  String toString() {
    return '$prefix: $message';
  }
}

class CustomException extends AppExceptions {
  CustomException([String? message, String? prefix]) : super(message!, prefix!);
}