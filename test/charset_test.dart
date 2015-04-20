library secret_sharing.test.charset;

import 'package:secret_sharing/secret_sharing.dart';
import 'package:unittest/unittest.dart';

main() => defineCharsetTests();

defineCharsetTests() {
  group("CharsetToIntConverter", () {
    test("ASCII Charset", () {
      var converter = new CharsetToIntConverter(new ASCIICharset());
      var encoded = converter.convert("a secret");
      
      expect(encoded, equals(54750861661614836));
    });
  });
  
  group("IntToCharsetConverter", () {
    test("ASCII Charset", () {
      var converter = new IntToCharsetConverter(new ASCIICharset());
      var decoded = converter.convert(54750861661614836);
      
      expect(decoded, equals("a secret"));
    });
  });
}