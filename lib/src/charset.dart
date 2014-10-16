part of secret_sharing;

final NULL_RUNE = UTF8.decode([0]);


class IntToCharsetConverter extends Converter<int, String> {
  final Set<String> charset;
  
  IntToCharsetConverter.fromString(String charset)
      : charset = new Set.from([NULL_RUNE]..addAll(charset.split("")));
  
  IntToCharsetConverter(Set<String> charset)
      : charset = new Set.from([NULL_RUNE]..addAll(charset));
  
  String convert(int input) {
    if (input < 0) throw new ArgumentError("x has to be non negative");
    var output = "";
    var codepoint;
    while (input > 0) {
      codepoint = input % charset.length;
      input = input ~/ charset.length;
      output = charset.elementAt(codepoint) + output;
    }
    return output;
  }
  
  String get charsetRepr => charset.toList().sublist(1).join();
}

class CharsetToIntConverter extends Converter<String, int> {
  final Set<String> charset;
  
  CharsetToIntConverter(Set<String> charset)
      : charset = new Set.from([NULL_RUNE]..addAll(charset));
  
  CharsetToIntConverter.fromString(String charset)
      : charset = new Set.from([NULL_RUNE]..addAll(charset.split("")));
  
  int convert(String input) {
    var output = 0;
    input.split("").forEach((sign) {
      output = output * charset.length + charset.toList().indexOf(sign);
    });
    return output;
  }
  
  String get charsetRepr => charset.toList().sublist(1).join();
}

class CharsetCodec extends Codec<String, int> {
  final CharsetToIntConverter encoder;
  final IntToCharsetConverter decoder;
  
  CharsetCodec._(this.encoder, this.decoder);
  
  factory CharsetCodec(String charset) {
    var set = new Set.from(charset.split(""));
    var encoder = new CharsetToIntConverter(set);
    var decoder = new IntToCharsetConverter(set);
    return new CharsetCodec._(encoder, decoder);
  }
}