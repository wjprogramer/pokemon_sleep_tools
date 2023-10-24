String? getErrorMessage(dynamic error) {
  if (error == null) {
    return null;
  }
  return error.toString();
}