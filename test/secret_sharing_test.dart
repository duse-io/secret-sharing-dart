library secret_sharing.test.codec;

import 'package:secret_sharing/secret_sharing.dart';
import 'package:mock/mock.dart';
import 'package:unittest/unittest.dart';
import 'random_test_util.dart';

defineCodecTests() {
  globalRandomCount = 10000;
  
  test("Raw share encoding", () {
    var random = new RandomMock([4]);
    var encoder = new RawShareEncoder(3, 2, random);
    var shares = encoder.convert(6);
    
    random.getLogs(callsTo("nextInt")).verify(happenedExactly(1));
    expect(shares[0].point, equals(new Point(1, 3)));
    expect(shares[1].point, equals(new Point(2, 0)));
    expect(shares[2].point, equals(new Point(3, 4)));
  });
  
  // Heuristic Test
  rTest("Raw share codec", () {
    var codec = new RawShareCodec(3, 2);
    var shares = codec.encode(900000000000000);
    var decodable = (shares..shuffle).sublist(1);
    var decoded = codec.decode(decodable);
    expect(decoded, equals(900000000000000));
  });
  
  // Heuristic Test
  rTest("String share codec with dynamic charset", () {
    var secret = r"Some strange signs :-'$#äöü";
    var codec = new StringShareCodec.bySecret(3, 2, secret);
    var shares = codec.encode(secret);
    var decoded = codec.decode((shares..shuffle).sublist(1, 3));
    expect(decoded, equals(secret));
  });
}