import 'package:unittest/unittest.dart';
import 'package:secret_sharing/secret_sharing.dart';


void main() {
  test("Share parsing", () {
    var share = new StringShare.parse("abc-0-1");
    expect(share.point, equals(new Point(0, 1)));
    expect(share.charsetString, equals("abc"));
    expect(share.charset, new isInstanceOf<DynamicCharset>());
    share = new StringShare.parse("ab----f-5");
    expect(share.point, equals(new Point(15, 5)));
    expect(share.charsetString, equals("ab-"));
    expect(share.charset, new isInstanceOf<DynamicCharset>());
    share = new StringShare.parse("bab---001-6");
    expect(share.point, equals(new Point(1, 6)));
    expect(share.charsetString, equals("ba-"));
    expect(share.charset, new isInstanceOf<DynamicCharset>());
    share = new StringShare.parse(r"$$ASCII-1-f");
    expect(share.charset, new isInstanceOf<ASCIICharset>());
    expect(share.charsetString, equals(""));
    share = new StringShare.parse("1-f");
    expect(share.charset, new isInstanceOf<ASCIICharset>());
    expect(share.charsetString, equals(""));
    expect(share.point, equals(new Point(1, 15)));
    share = new RawShare("f-5");
    expect(share.point, equals(new Point(15, 5)));
    share = new RawShare("01-5");
    expect(share.point, equals(new Point(1, 5)));
  });
}