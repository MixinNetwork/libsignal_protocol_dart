import 'dart:collection';

class Entry<T> extends LinkedListEntry<Entry<T>> {
  T value;
  Entry(this.value);
}