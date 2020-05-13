import '../IdentityKey.dart';

Function IdentityKeyComparator = (IdentityKey a, IdentityKey b) =>
    a.publicKey.serialize() == b.publicKey.serialize();
