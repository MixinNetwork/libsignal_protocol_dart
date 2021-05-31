import 'dart:collection';

class Entry<T> extends LinkedListEntry<Entry<T>> {
  Entry(this.value);
  T value;
}
