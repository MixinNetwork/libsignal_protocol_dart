import 'package:collection/collection.dart';

bool Function(List<dynamic> list1, List<dynamic> list2) eq =
    const ListEquality<dynamic>().equals;
