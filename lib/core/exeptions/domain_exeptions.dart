class DomainExeptions implements Exception {
  final String message;
  const DomainExeptions(this.message);

  @override
  String toString() {
    return 'DomainExeptions: $message';
  }
}