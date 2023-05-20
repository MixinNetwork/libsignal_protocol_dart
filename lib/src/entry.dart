import 'dart:collection';

base class Entry<T> extends LinkedListEntry<Entry<T>> {
  Entry(this.value);
  T value;
}
