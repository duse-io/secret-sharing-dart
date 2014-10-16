part of secret_sharing;


class Polynomial<E extends num> {
  final List<E> coefficients;
  
  E call(E x) => calculate(x);
  
  Polynomial(List<E> coefficients)
      : coefficients = coefficients.reversed.toList();
  
  factory Polynomial.randomInt(int degree, int max) {
    var coefficients = getRandomCoefficients(degree, _RANDOM_MAX);
    return new Polynomial(coefficients);
  }
  
  factory Polynomial.secret(int secret, int degree, int max) {
    var coefficients = getRandomCoefficients(degree - 1, max);
    coefficients.insert(0, secret);
    return new Polynomial(coefficients);
  }
  
  E calculate(E x) {
    return coefficients.fold(0, (n1, n2) => n1 * x + n2);
  }
  
  bool isPart(Point<E> p) {
    return calculate(p.x) == p.y;
  }
  
  int get degree => coefficients.length;
  
  String toString() => coefficients.fold("", (n1, n2) => n1 == "" ?
      "$n2" : "($n1 * x + $n2)");
  
  static List<int> getRandomCoefficients(int ct, int max) {
    return new List<int>.generate(ct, (_) => _random.nextInt(max),
        growable: true);
  }
}


class SecretPolynomial implements Polynomial<int> {
  final Polynomial _p;
  final int prime;
  final int secret;
  
  SecretPolynomial._(this._p, int secret)
      : secret = secret,
        prime = PRIMES.firstWhere((p) => p > secret);
  
  factory SecretPolynomial(int secret, int neededShares) {
    if (neededShares < 2) throw "Needed shares has to be at least 2";
    var coefficients = Polynomial.getRandomCoefficients(neededShares -1,
        secret);
    coefficients.insert(0, secret);
    var p = new Polynomial(coefficients);
    return new SecretPolynomial._(p, secret);
  }
  
  int call(int x) => calculate(x);
  
  int calculate(int x) => _p.calculate(x) % prime;
  
  List<int> get coefficients => _p.coefficients;
  
  bool isPart(Point<int> p) => calculate(p.x) == p.y;
  
  int get degree => _p.degree;
  
  List<Point<int>> getShares(int noOfShares) {
    return new List<Point<int>>.generate(noOfShares, (i) =>
        new Point(i + 1, calculate(i + 1)));
  }
  
  String toString() => _p.toString();
}