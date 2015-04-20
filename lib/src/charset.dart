part of secret_sharing;

/// The null rune of the [UTF8] charset
final NULL_RUNE = UTF8.decode([0]);

/// A [Charset] which has a specified set of [characters].
class Charset {
  /// The different characters of the [Charset]
  final Set<String> characters;
  
  /// Creates a new instance of [Charset] with the specified characters
  const Charset._(this.characters);
  
  /// Returns the index of the given [char] in the [characters] set
  int indexOf(String char) => characters.toList().indexOf(char);
  
  /// Returns the char at [index] in [characters]
  operator[](int index) => characters.elementAt(index);
  
  /// Returns the length of [characters]
  int get length => characters.length;
  
  /// Returns the representation of [characters] by [join]ing them
  String get representation => characters.toList().join();
}


// A charset consisting of all [ASCII] chars.
class ASCIICharset implements Charset {
  
  /// The constant ASCII length (ASCII has 128 characters)
  static const int ASCII_LENGTH = 128;
  
  /// The underlying [charset]
  final Charset charset;
  
  /// Creates a new ASCIICharset with all ASCII characters
  ASCIICharset()
      : charset = new Charset._(ASCII.decode(new List.generate(ASCII_LENGTH,
          (i) => i)).split("").toSet());
  
  /// Returns the length of the underlying [characters] (128)
  int get length => characters.length;
  
  /// Returns the index of [char] in the [charset]
  int indexOf(String char) => charset.indexOf(char);
  
  /// Returns the char at [index] in [charset]
  operator[](int index) => charset[index];
  
  /// Returns a [Set] of all ASCII characters
  Set<String> get characters => charset.characters;
  
  /// The representation of this [Charset], `""` by default.
  String get representation => "";
}


/// A converter which converts an [int] representation of a [String] to a [String]
class IntToCharsetConverter extends Converter<int, String> {
  
  /// The charset which shall be used for decoding
  final Charset charset;
  
  /// Creates a new converter with the specified [charset]
  IntToCharsetConverter(this.charset);
  
  /// Converts an [int] representation of a [String] to the original [String]
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
  
  /// Prints the representation of the underlying [charset]
  String get charsetRepr => charset.representation;
}


/// A converter which converts a [String] to an [int] representation
class CharsetToIntConverter extends Converter<String, int> {
  
  /// The [charset] in which the given string shall be represented
  final Charset charset;
  
  /// Creates a new converter with the specified [charset]
  CharsetToIntConverter(this.charset);
  
  
  /// Converts the given [input] to the [int] representation of the [charset]
  int convert(String input) {
    var output = 0;
    input.split("").forEach((sign) {
      output = output * charset.length + charset.indexOf(sign);
    });
    return output;
  }
  
  /// Returns the representation of the underlying [charset]
  String get charsetRepr => charset.representation;
}

/// A codec which is capable of en- and decoding of [String]s to [int]s.
class CharsetCodec extends Codec<String, int> {
  
  /// The underlying [String] to [int] encoder
  final CharsetToIntConverter encoder;
  
  /// The underlying [int] to [String] encoder
  final IntToCharsetConverter decoder;
  
  /// The charset in which the [int] representation shall be
  final Charset charset;
  
  /// Creates a new [CharsetCodec] with the specified [charset].
  CharsetCodec(Charset charset)
      : encoder = new CharsetToIntConverter(charset),
        decoder = new IntToCharsetConverter(charset),
        charset = charset,
        super();
}