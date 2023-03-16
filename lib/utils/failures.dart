class Failure {
  final String message;
  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class UnknowFailure extends Failure {
  UnknowFailure(String message) : super(message);
}
