import 'package:collection/collection.dart';

bool eq<E>(List<E>? list1, List<E>? list2) =>
    ListEquality<E>().equals(list1, list2);
