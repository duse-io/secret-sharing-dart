part of secret_sharing;


/// The exponents needed to construct some mersenne primes
/// 
/// These exponents lead to a prime if you
/// calculate `2^exponent - 1`. Mersenne Primes are
/// fast in calculation, that's why they are used here.
const _MERSENNE_PRIME_EXPONENTS = const [2, 3, 5, 7, 13, 17, 19, 31, 61, 89,
                                         107, 127, 521, 607, 1279];

/// The smallest prime in 257 bit area
final _SMALLEST_257BIT_PRIME = pow(2, 256) + 297;

/// The smalles prime in 321 bit area
final _SMALLEST_321BIT_PRIME = pow(2, 320) + 27;

/// The smallest prime in 385 bit area
final _SMALLEST_385BIT_PRIME = pow(2, 384) + 231;

/// The prime numbers for cryptographic calculations
/// 
/// Prime numbers are needed for cryptographic calculation
/// to calculate in definite mathematical bodies.
final PRIMES = _MERSENNE_PRIME_EXPONENTS.map((n) => pow(2, n) - 1)
  .toList(growable: true)..addAll([_SMALLEST_257BIT_PRIME, 
                                   _SMALLEST_321BIT_PRIME,
                                   _SMALLEST_385BIT_PRIME]);


/// Returns the first prime which is larger than [n]
int getPrimeLargerThan(int n) => PRIMES.firstWhere((p) => p < n);

/// Returns the first prime which is larger than all elements of [l]
int getLargeEnoughPrime(List<int> l) => PRIMES.firstWhere((p) =>
    l.every((n) => n < p));