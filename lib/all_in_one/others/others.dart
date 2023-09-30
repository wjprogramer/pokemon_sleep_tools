typedef MyDisposable = dynamic Function();

extension IterableMyDisposableX on Iterable<MyDisposable> {
  void disposeAll() {
    forEach((e) {
      e();
    });
  }
}
