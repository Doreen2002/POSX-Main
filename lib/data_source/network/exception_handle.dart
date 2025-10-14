class BaseException implements Exception {
  String message;
  int code;

  BaseException({
    this.message = "",
    this.code = -1,
  });
}
