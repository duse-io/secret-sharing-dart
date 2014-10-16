part of secret_sharing;

class Share {
}

class RawShare implements Share {
  final Point<int> point;
  
  RawShare.fromPoint(this.point);
  
  factory RawShare(String rawShare) {
    var parts = rawShare.split("-");
    var x = int.parse(parts[0]);
    var y = int.parse(parts[1]);
    return new RawShare.fromPoint(new Point(x, y));
  }
  
  String toString() => point.x.toString() + "-" + point.y.toString();
}

class StringShare implements RawShare {
  final Set<String> charset;
  final RawShare rawShare;
  
  StringShare._(this.charset, this.rawShare);
  
  
  StringShare.fromRawShare(RawShare share, String charset)
      : rawShare = share,
        charset = new Set.from(charset.split(""));
  
  
  factory StringShare(String share) {
    int ct = 0;
    int i = share.length - 1;
    while (ct != 2) {
      if (share[i] == "-") ct++;
      i--;
    }
    var rawShare = new RawShare(share.substring(i + 2));
    var set = new Set.from(share.substring(0, i + 1).split(""));
    return new StringShare._(set, rawShare);
  }
  
  
  String toString() => charsetString + "-" + rawShare.toString();
  
  String get charsetString => charset.join();
  
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
  
  StringShareEncoder(int noOfShares, int neededShares)
      : _encoder = new RawShareEncoder(noOfShares, neededShares),
        super(noOfShares, neededShares);
  
  List<StringShare> convert(String secret) {
    var converter = new CharsetToIntConverter.fromString(secret);
    var representation = converter.convert(secret);
    var rawShares = _encoder.convert(representation);
    return rawShares.map((share) =>
        new StringShare.fromRawShare(share, secret)).toList();
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
    var prime = getLargeEnoughPrime(points.map((p) => p.y).toList());
    log.info("Taking prime $prime");
    var f = modularLagrange(shares.map((s) => s.point).toList(), prime);
    return f(0);
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
  
  StringShareCodec(int noOfShares, int neededShares)
      : encoder = new StringShareEncoder(noOfShares, neededShares),
        super(noOfShares, neededShares);
}