import 'package:secret_sharing/secret_sharing.dart';
import 'package:unittest/unittest.dart';

main() {
  group("CharsetToIntConverter", () {
    test("ASCII Charset", () {
      var converter = new CharsetToIntConverter(new ASCIICharset());
      var encoded = converter.convert("a secret");
      
      expect(encoded, equals(54750861661614836));
    });
    
    test("Dynamic Charset", () {
      var converter = new CharsetToIntConverter(
          new DynamicCharset.fromString("a secrt"));
      var encoded = converter.convert("a secret");
      
      expect(encoded, equals(2739111));
    });
  });
  
  group("IntToCharsetConverter", () {
    test("ASCII Charset", () {
      var converter = new IntToCharsetConverter(new ASCIICharset());
      var decoded = converter.convert(54750861661614836);
      
      expect(decoded, equals("a secret"));
    });
    
    test("Dynamic Charset", () {
      var converter = new IntToCharsetConverter(
          new DynamicCharset.fromString("a secrt"));
      var decoded = converter.convert(2739111);
      
      expect(decoded, equals("a secret"));
    });
  });
}