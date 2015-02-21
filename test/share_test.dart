library secret_sharing.test.share;

import 'dart:math' show Random;

import 'package:unittest/unittest.dart';
import 'package:secret_sharing/secret_sharing.dart';

defineShareTests() {
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
    
    test("Raw share toString", () {
      var share = new RawShare.fromPoint(new Point(1, 15));
      
      expect(share.toString(), equals("1-f"));
    });
    
    test("Share Encoder Illegal constructor", () {
      expect(() => new RawShareEncoder(2, 3, new Random()), throws);
    });
  });
}