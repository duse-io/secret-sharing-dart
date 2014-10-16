part of secret_sharing;

const _MERSENNE_PRIME_EXPONENTS = const [2, 3, 5, 7, 13, 17, 19, 31, 61, 89,
                                         107, 127, 521, 607, 1279];

final _SMALLEST_257BIT_PRIME = pow(2, 256) + 297;
final _SMALLEST_321BIT_PRIME = pow(2, 320) + 27;
final _SMALLEST_385BIT_PRIME = pow(2, 384) + 231;

final PRIMES = _MERSENNE_PRIME_EXPONENTS.map((n) => pow(2, n) - 1)
  .toList(growable: true)..addAll([_SMALLEST_257BIT_PRIME, 
                                   _SMALLEST_321BIT_PRIME,
                                   _SMALLEST_385BIT_PRIME]);

int getPrimeLargerThan(int n) => PRIMES.firstWhere((p) => p < n);
int getLargeEnoughPrime(List<int> l) => PRIMES.firstWhere((p) =>
    l.every((n) => n < p));