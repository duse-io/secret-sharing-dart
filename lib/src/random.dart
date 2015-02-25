part of secret_sharing;

/// A random generator which is capable of producing infinitely large numbers
/// 
/// This random generator produces random numbers by using a regular random
/// generator which then produces numbers from 0 to 10 (exclusive) for each
/// digit of the maximum number. Please note: This random generator (as well
/// as the used Dart random generator) is NOT cryptographically secure! It
/// should only be used for testing this library.
class BRandom implements Random{
  /// Creates a new [BRandom] instance.
  BRandom([Random random])
      : _random = null == random ? new BlumBlumShub() : random;
  
  
  /// The random generator used for the digit generation
  final Random _random;
  
  /// Returns an int between 0 (inclusive) and max(exclusive)
  int nextInt(int max) {
    if (_random is BlumBlumShub) return _random.nextInt(max);
    if (max < 0) throw new ArgumentError("max value can't be < 0");
    int digits = (max - 1).toString().length; // One digit less because max is exclusive
    var out = 0;
    do {
      var str = "";
      for (int i = 0; i < digits; i++) {
        str += this._random.nextInt(10).toString();
      }
      out = int.parse(str);
    } while (out >= max);
    return out;
  }
  
  /// Returns an int between min (inclusive) and max (exclusive)
  int nextIntBetween(int min, int max) => min + nextInt(max - min);
  
  /// Returns a random boolean value (true or false)
  bool nextBool() => _random.nextBool();
  
  /// Returns a random double value
  double nextDouble() {
    if (_random is BlumBlumShub) return new Random().nextDouble();
    return _random.nextDouble();
  }
  
  /// Returns a [Set] of ints between 0 (inclusive) and max (exclusive)
  Set<int> nextIntSet(int count, int max) {
    var result = new Set<int>();
    while(result.length < count) {
      result.add(nextInt(max));
    }
    return result;
  }
  
  /// Returns a [Set] of ints between min (inclusive) and max (exclusive)
  Set<int> nextIntBetweenSet(int count, int min, int max) {
    var result = new Set<int>();
    while(result.length < count) {
      result.add(nextIntBetween(min, max));
    }
    return result;
  }
}