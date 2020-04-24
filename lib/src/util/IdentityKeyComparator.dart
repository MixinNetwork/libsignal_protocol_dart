import 'package:libsignalprotocoldart/src/IdentityKey.dart';

Function IdentityKeyComparator = (IdentityKey a, IdentityKey b) =>
    a.getPublicKey().serialize() == b.getPublicKey().serialize();