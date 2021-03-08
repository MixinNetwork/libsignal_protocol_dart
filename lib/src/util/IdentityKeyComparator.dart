import 'package:libsignal_protocol_dart/src/util/ByteUtil.dart';

import '../IdentityKey.dart';

int IdentityKeyComparator(IdentityKey a, IdentityKey b) =>
    ByteUtil.compare(a.publicKey.serialize(), b.publicKey.serialize());
