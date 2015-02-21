library secret_sharing.test.share;

import 'package:unittest/unittest.dart';
import 'package:secret_sharing/secret_sharing.dart';

main() => defineShareTests();

void defineShareTests() {
  group("Share Parsing", () {
    test("Parse dynamic share", () {
      var share = new StringShare.parse("abc-0-1");

      expect(share.point, equals(new Point(0, 1)));
      expect(share.charsetString, equals("abc"));
      expect(share.charset, new isInstanceOf<DynamicCharset>());
    });

    test("Parse dynamic share with duplicated characters", () {
      var share = new StringShare.parse("ab----f-5");

      expect(share.point, equals(new Point(15, 5)));
      expect(share.charsetString, equals("ab-"));
      expect(share.charset, new isInstanceOf<DynamicCharset>());
    });

    test("Parse share with definite ascii charset", () {
      var share = new StringShare.parse(r"$$ASCII-1-f");

      expect(share.charset, new isInstanceOf<ASCIICharset>());
      expect(share.charsetString, equals(""));
    });

    test("Parse share with default charset (ascii)", () {
      var share = new StringShare.parse("1-f");

      expect(share.charset, new isInstanceOf<ASCIICharset>());
      expect(share.charsetString, equals(""));
      expect(share.point, equals(new Point(1, 15)));
    });

    test("Raw share parsing", () {
      var share = new RawShare("f-5");

      expect(share.point, equals(new Point(15, 5)));
    });
  });
}