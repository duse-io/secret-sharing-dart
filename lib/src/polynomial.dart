part of secret_sharing;

/// A [Polynomial] producing [E] results
///
/// A polynomial consists of a0, a1 .. an coefficients.
/// The standard form is a0 * x^0 + a1 * x^1...
class Polynomial<E extends num> {
  /// The coefficients a0 to an
  final List<E> coefficients;

  /// Calculates the value at place [x]
  E call(E x) => calculate(x);

  /// Creates a new [Polynomial] with the given [coefficients].
  ///
  /// The first coefficient is a0, the last coefficient is an
  Polynomial(List<E> coefficients)
      : coefficients = coefficients.reversed.toList();

  /// Creates a new <[int]> [Polynomial] of degree [degree] with values from 0
  /// to [max] (excluding).
  factory Polynomial.randomInt(int degree, int max) {
    var coefficients = getRandomCoefficients(degree, _RANDOM_MAX);
    return new Polynomial(coefficients);
  }

  /// Calculates the value at place [x]
  E calculate(E x) {
    return coefficients.fold(0, (n1, n2) => n1 * x + n2);
  }

  /// Checks if the y coordinate of [p] is part of this polynomial
  ///
  /// Checks if `f(p.x) == p.y`
  bool isPart(Point<E> p) {
    return calculate(p.x) == p.y;
  }

  /// Returns the degree of this, which is
  int get degree => coefficients.length - 1;

  /// Returns a representation of this in form of the Horner-Schema
  String toString() => coefficients.fold("", (n1, n2) => n1 == "" ?
      "$n2" : "($n1 * x + $n2)");

  /// Returns a [List] of [ct] coefficients between 0 and [max] (exclusive).
  ///
  /// If [random] is `null`, [BRandom] is used instead;
  static List<int> getRandomCoefficients(int ct, int max, {Random random}) {
    if (random == null) random = _random;
    return new List<int>.generate(ct, (_) => random.nextInt(max),
        growable: true);
  }
}


/// A polynomial which can be used for cryptographical calculation.
///
/// This polynomial does every calculation with `%p`, where
/// p is a prime number > than every coefficient.
class SecretPolynomial implements Polynomial<int> {

  /// The underlying polynomial
  final Polynomial _p;

  /// The prime with which modulo calculations are being done
  final int prime;

  /// The secret which is also a0 of [_p]
  final int secret;

  /// Creates a new secret polynomial with underlying polynomial [_p]
  /// and secret [secret].
  SecretPolynomial._(this._p, int secret)
      : secret = secret,
        prime = PRIMES.firstWhere((p) => p > secret);


  /// Constrcuts a new polynomial with the given secret. The degree
  /// will be [neededShares] - 1.
  factory SecretPolynomial(int secret, int neededShares, Random random) {
    if (neededShares < 2) throw "Needed shares has to be at least 2";
    var coefficients = Polynomial.getRandomCoefficients(neededShares -1,
        secret, random: random);
    coefficients.insert(0, secret);
    var p = new Polynomial(coefficients);
    return new SecretPolynomial._(p, secret);
  }


  /// Calculates f(x) % p, where p is a large enough prime
  int call(int x) => calculate(x);

  /// Calculates f(x) % p, where p is a large enough prime
  int calculate(int x) => _p.calculate(x) % prime;

  /// Returns the coefficients of the underlying polynom
  List<int> get coefficients => _p.coefficients;

  bool isPart(Point<int> p) => calculate(p.x) == p.y;

  /// Returns the degree of the underlying polynom
  int get degree => _p.degree;


  /// Produces [noOfShares] points from 1 to noOfShares + 1.
  List<Point<int>> getShares(int noOfShares) {
    return new List<Point<int>>.generate(noOfShares, (i) =>
        new Point(i + 1, calculate(i + 1)));
  }

  String toString() => _p.toString();
}