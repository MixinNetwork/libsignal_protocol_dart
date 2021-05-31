import '../identity_key.dart';
import 'byte_util.dart';

int identityKeyComparator(IdentityKey a, IdentityKey b) =>
    ByteUtil.compare(a.publicKey.serialize(), b.publicKey.serialize());
