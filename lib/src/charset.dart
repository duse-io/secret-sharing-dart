part of secret_sharing;

final NULL_RUNE = UTF8.decode([0]);

class Charset {
  final Set<String> characters;
  
  const Charset._(this.characters);
  
  factory Charset.create(String characters) {
    if (characters == r"$$ASCII") return new ASCIICharset();
    return new DynamicCharset.create(characters);
  }
  
  factory Charset.fromString(String from) {
    if (from == r"$$ASCII") return new ASCIICharset();
    return new DynamicCharset.fromString(from);
  }
  
  int indexOf(String char) => characters.toList().indexOf(char);
  operator[](int index) => characters.elementAt(index);
  
  int get length => characters.length;
  
  String get representation => characters.toList().join();
}


class DynamicCharset implements Charset {
  final Charset charset;
  
  DynamicCharset.create(String characters)
      : charset = new Charset._(([NULL_RUNE]..addAll(characters.split("")
                                                   ..shuffle())).toSet());
  
  DynamicCharset.fromString(String from)
      : charset = new Charset._(([NULL_RUNE]..addAll(from.split(""))).toSet());
  
  int get length => characters.length;
  int indexOf(String char) => charset.indexOf(char);
  operator[](int index) => charset[index];
  Set<String> get characters => charset.characters;
  String get representation => characters.toList().sublist(1).join();
}


class ASCIICharset implements Charset {
  static const int ASCII_LENGTH = 128;
  final Charset charset;
  
  ASCIICharset()
      : charset = new Charset._(ASCII.decode(new List.generate(ASCII_LENGTH,
          (i) => i)).split("").toSet());
  
  int get length => characters.length;
  int indexOf(String char) => charset.indexOf(char);
  operator[](int index) => charset[index];
  Set<String> get characters => charset.characters;
  String get representation => r"$$ASCII";
}


class IntToCharsetConverter extends Converter<int, String> {
  final Charset charset;
  
  IntToCharsetConverter(this.charset);
  
  String convert(int input) {
    if (input < 0) throw new ArgumentError("x has to be non negative");
    var output = "";
    var codepoint;
    while (input > 0) {
      codepoint = input % charset.length;
      input = input ~/ charset.length;
      output = charset[codepoint] + output;
    }
    return output;
  }
  
  String get charsetRepr => charset.characters.toList().sublist(1).join();
}

class CharsetToIntConverter extends Converter<String, int> {
  final Charset charset;
  
  CharsetToIntConverter(this.charset);
  
  int convert(String input) {
    var output = 0;
    input.split("").forEach((sign) {
      output = output * charset.length + charset.indexOf(sign);
    });
    return output;
  }
  
  String get charsetRepr => charset.characters.toList().sublist(1).join();
}

class CharsetCodec extends Codec<String, int> {
  final CharsetToIntConverter encoder;
  final IntToCharsetConverter decoder;
  final Charset charset;
  
  CharsetCodec(Charset charset)
      : encoder = new CharsetToIntConverter(charset),
        decoder = new IntToCharsetConverter(charset),
        charset = charset,
        super();
}