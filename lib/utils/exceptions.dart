class HttpException implements Exception {
  final String message;
  const HttpException(this.message);
}

class UnknownException implements Exception {
  final String message;
  const UnknownException(this.message);
}
