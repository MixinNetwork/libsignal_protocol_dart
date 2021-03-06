import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:libsignal_protocol_dart/src/cbc.dart';
import 'package:test/test.dart';

void main() {
  test('testDecrypt', () {
    const privateKey = 'GHtZBYTNqbCofFo0keD3jTGoHF6bUAeiW9iV5ad/HHA=';
    const content =
        'eyJwdWJsaWNfa2V5IjoiQmZFOWJFa3EzZ2FsUTFHTnVEMWlJaHBrSkE0RHRTVUxkYXhkS3JiZndMcDgiLCJib2R5IjoiQVd6YWZJSDEyZ2tTQmRjdVplSXRMM3lXVmhZdW1lemppZk9rbFdsV3lnQzVKSXpzMHVxYXFZNnhsdFJzVWJya2N0NGFLazVKSmxwYlBKSXNqTU5qYXZKR1hNSFpOSnQ2SXZ1S1pkUVwvN1RzbjRUUjhmWjNSUXo2aGM3RlpYZENLTUJMVzJHTjAzSDd3aUt1elArZVV4WktCQjFPb2pWaVlSU0Vyc3dUWGwxeWR5cnhcLzM1NVY5MzFCR0N1VlBLVXFuOUJFWCtidVFhYms3YWZYdEVCOUI2YTZGSnFCZXVGcHdcLzlDdWpwYVpXNzNIMmswTmxkNjdPMzB5QkZEM3RuNmtiaXZ3MzNjN0l2Uk9EYlwvQnFTS1NGSlJoMUE2eU1leTAyeHZkNkJpRkxja1FRQk9LXC9ROW5ZOExoM2VlS2FNNTQ3cVV3XC9qUEE0ZGE5TzI0RkJUXC9ON2NvR2dBOVkrN1pvZ0syQ3YzbDZCNG9CN0xyTCtrVlRWTHJ2MFA1aDF3YklrUm10YWRLQmxiTjVvK3RnVUZ5VnVNcWFXQVJ6QnBJNlVDajVaZ0JJVWJWM3N0enVwUXpYU0E5OVBWV3hXOTE2dz09In0=';
    final plaintext = decrypt(privateKey, content);
    final result = utf8.decode(plaintext, allowMalformed: true);
    const r =
        '{"session_id":"304745a1-45af-4045-bd16-ba4d42a03a4e","platform":"iOS","user_id":"f59b9309-70c2-4b69-8fd8-5773dbd10018","identity_key_public":"BTEcMFj5uvP+32z+avKFOjDOrMvmnoDmwMfPZcuxBT08","identity_key_private":"iG5ilNnI8dkqtslK84NWWmPUhzADyUm6odlwA96isEk=","provisioning_code":"7972"}';
    assert(result == r);
  });

  test('testEncrypt', () {
    final privateKey =
        base64.decode('v9FTNn2tg40ENCEaoCHstCo5J0wb9wKwgZQ6PYJjf0U=');
    final iv = base64.decode('tNp4sPQGKjwzqN0L8tDLDg==');
    const encode = 'l0JO9zrPWzrPg2r53Sjf6g==';
    final ciphertext = aesCbcEncrypt(
        privateKey, iv, Uint8List.fromList(utf8.encode('Hello Mixin')));
    assert(encode == base64.encode(ciphertext));
  });
}
