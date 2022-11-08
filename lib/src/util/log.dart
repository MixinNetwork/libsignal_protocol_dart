bool enabled = false;

void log(Object? object) {
  if (enabled) {
    // ignore: avoid_print
    print(object);
  }
}
