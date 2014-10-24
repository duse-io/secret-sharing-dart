part of secret_sharing;

class Share {
}

class RawShare implements Share {
  final Point<int> point;
  
  RawShare.fromPoint(this.point);
  
  factory RawShare(String rawShare) {
    var parts = rawShare.split("-");
    var x = int.parse(parts[0], radix: 16);
    var y = int.parse(parts[1], radix: 16);
    return new RawShare.fromPoint(new Point(x, y));
  }
  
  String toString() => point.x.toRadixString(16) + "-" +
      point.y.toRadixString(16);
}

class StringShare implements RawShare {
  final Charset charset;
  final RawShare rawShare;
  
  StringShare._(this.charset, this.rawShare);
  
  
  StringShare.fromRawShare(RawShare share, Charset charset)
      : rawShare = share,
        charset = charset;
  
  
  factory StringShare.parse(String share) {
    int ct = 0;
    int i = share.length - 1;
    var charsetString = "";
    var rawShareString = "";
    for (int i = share.length -1; i >= 0; i--) {
      if (share[i] == "-") {
        ct ++;
        if (ct == 2) continue;
      }
      if (ct <= 1) {
        rawShareString = share[i] + rawShareString;
        continue;
      }
      charsetString = share[i] + charsetString;
    }
    var rawShare = new RawShare(rawShareString);
    var charset = new Charset.fromString(charsetString);
    return new StringShare._(charset, rawShare);
  }
  
  
  String toString() => charsetString == "" ? rawShare.toString() :
    charsetString + "-" + rawShare.toString();
  
  String get charsetString => charset.representation;
  
  Point get point => rawShare.point;
}


abstract class ShareEncoder<E, S extends Share> extends Converter<E, List<S>> {
  final int noOfShares;
  final int neededShares;
  
  ShareEncoder([this.noOfShares = 2, this.neededShares = 2]) {
    if (noOfShares < neededShares)
      throw new ArgumentError("No of shares cannot be < than needed Shares");
  }
}


abstract class ShareDecoder<E, S extends Share> extends Converter<List<S>, E> {
}


class RawShareEncoder extends ShareEncoder<int, RawShare> {
  RawShareEncoder(int noOfShares, int neededShares)
      : super(noOfShares, neededShares);
  
  List<RawShare> convert(int secret) {
    var p = new SecretPolynomial(secret, neededShares);
    log.info("Converting with prime ${p.prime}");
    log.info("Polynomial is $p");
    return p.getShares(noOfShares).map((p) =>
        new RawShare.fromPoint(p)).toList();
  }
}


class StringShareEncoder extends ShareEncoder<String, StringShare> {
  final RawShareEncoder _encoder;
  final Charset charset;
  final CharsetToIntConverter converter;
  
  factory StringShareEncoder.bySecret(int noOfShares, int neededShares, String secret) {
    var charset = new Charset.create(secret);
    return new StringShareEncoder(noOfShares, neededShares, charset);
  }
  
  StringShareEncoder(int noOfShares, int neededShares, Charset charset)
      : charset = charset,
        _encoder = new RawShareEncoder(noOfShares, neededShares),
        converter = new CharsetToIntConverter(charset),
        super(noOfShares, neededShares);
  
  List<StringShare> convert(String secret) {
    var representation = converter.convert(secret);
    var rawShares = _encoder.convert(representation);
    return rawShares.map((share) =>
        new StringShare.fromRawShare(share, charset)).toList();
  }
}


class StringShareDecoder extends ShareDecoder<String, StringShare> {
  final _decoder = new RawShareDecoder();
  
  String convert(List<StringShare> shares) {
    var rawShares = shares.map((share) => share.rawShare).toList();
    var secretInt = _decoder.convert(rawShares);
    var converter = new IntToCharsetConverter(shares.first.charset);
    return converter.convert(secretInt);
  }
}


class RawShareDecoder extends ShareDecoder<int, RawShare> {
  int convert(List<RawShare> shares) {
    var points = shares.map((s) => s.point);
    return modularLagrange(shares.map((s) => s.point).toList());
  }
}


abstract class ShareCodec<E, S extends Share> extends Codec<E, List<S>> {
  final int noOfShares;
  final int neededShares;
  
  ShareCodec(this.noOfShares, this.neededShares);
}


class RawShareCodec extends ShareCodec<int, RawShare> {
  final RawShareDecoder decoder = new RawShareDecoder();
  final RawShareEncoder encoder;
  
  RawShareCodec(int noOfShares, int neededShares)
      : encoder = new RawShareEncoder(noOfShares, neededShares),
        super(noOfShares, neededShares);
}

class StringShareCodec extends ShareCodec<String, StringShare> {
  final StringShareDecoder decoder = new StringShareDecoder();
  final StringShareEncoder encoder;
  final Charset charset;
  
  factory StringShareCodec.bySecret(int noOfShares, int neededShares, String secret) {
    var charset = new Charset.create(secret);
    return new StringShareCodec(noOfShares, neededShares, charset);
  }
  
  StringShareCodec(int noOfShares, int neededShares, Charset charset)
      : charset = charset,
        encoder = new StringShareEncoder(noOfShares, neededShares, charset),
        super(noOfShares, neededShares);
}