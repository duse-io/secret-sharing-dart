import 'package:secret_sharing/secret_sharing.dart';
import 'package:unittest/unittest.dart';

const int RANDOM_COUNT = 100;

rTest(String name, f(), {randomCount: RANDOM_COUNT}) {
  test(name, () {
    for (int i = 0; i < RANDOM_COUNT; i++) {
      f();
    }
  });
}

main() {
  test("Share parsing", () {
    var share = new StringShare.parse("abc-0-1");
    expect(share.point, equals(new Point(0, 1)));
    expect(share.charsetString, equals("abc"));
    share = new StringShare.parse("ab----f-5");
    expect(share.point, equals(new Point(15, 5)));
    expect(share.charsetString, equals("ab-"));
    share = new StringShare.parse("bab---001-6");
    expect(share.point, equals(new Point(1, 6)));
    expect(share.charsetString, equals("ba-"));
    share = new StringShare.parse(r"$$ASCII-1-f");
    expect(share.charset, new isInstanceOf<ASCIICharset>());
    expect(share.charsetString, equals(r"$$ASCII"));
    expect(share.point, equals(new Point(1, 15)));
    share = new RawShare("f-5");
    expect(share.point, equals(new Point(15, 5)));
    share = new RawShare("01-5");
    expect(share.point, equals(new Point(1, 5)));
  });
  
  rTest("Raw share codec", () {
    var codec = new RawShareCodec(3, 2);
    var shares = codec.encode(900000000000000);
    var decodable = (shares..shuffle).sublist(1);
    var decoded = codec.decode(decodable);
    expect(decoded, equals(900000000000000));
  });
  
  
  rTest("String share codec with dynamic charset", () {
    var secret = r"Some strange signs :-'$#äöü";
    var codec = new StringShareCodec.bySecret(3, 2, secret);
    var shares = codec.encode(secret);
    var decoded = codec.decode((shares..shuffle).sublist(1, 3));
    expect(decoded, equals(secret));
  });
}