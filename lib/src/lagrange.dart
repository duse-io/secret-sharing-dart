part of secret_sharing;

typedef Func(int x);

int modularLagrange(List<Point<int>> points) {
  var xValues = [];
  var yValues = [];
  points.forEach((point) {
    xValues.add(point.x);
    yValues.add(point.y);
  });
  var prime = getLargeEnoughPrime(yValues);
  var f_x = 0;
  for (int i = 0; i < points.length; i++) {
      var numerator = 1;
      var denominator = 1;
      for (int j = 0; j < points.length; j++) {
          if (i == j) continue;
          numerator = (numerator * (0 - xValues[j])) % prime;
          denominator = (denominator * (xValues[i] - xValues[j])) % prime;
      var lagrange_polynomial = numerator * modInverse(denominator, prime);
      f_x = (prime + f_x + (yValues[i] * lagrange_polynomial)) % prime;
      }
  }
  return f_x;
}


int modInverse(int k, int prime) {
  int v = k % prime;
  int r = _egcd(prime, v.abs())[2];
  return (prime + r) % prime;
}


List<int> _egcd(int a, int b) {
  if (a == 0) return [b, 0, 1];
  var res = _egcd(b % a, a);
  var g = res[0];
  var y = res[1];
  var x = res[2];
  return [g, x - (b / a).floor() * y, y];
}