import '../IdentityKey.dart';

Function IdentityKeyComparator = (IdentityKey a, IdentityKey b) =>
    a.getPublicKey().serialize() == b.getPublicKey().serialize();
