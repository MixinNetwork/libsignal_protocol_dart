import 'package:libsignal_protocol_dart/src/util/byte_util.dart';

import '../identity_key.dart';

int IdentityKeyComparator(IdentityKey a, IdentityKey b) =>
    ByteUtil.compare(a.publicKey.serialize(), b.publicKey.serialize());
