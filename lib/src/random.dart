part of secret_sharing;

class BRandom implements Random{
  BRandom();
  
  int nextInt(int max) {
    var count = max ~/ _RANDOM_MAX;
    var rest = max % _RANDOM_MAX;
    var randoms = new List.generate(count, (_) =>
        new Random().nextInt(_RANDOM_MAX), growable: true);
    if (rest != 0) randoms.add(new Random().nextInt(rest));
    return randoms.fold(0, (n1, n2) => n1 + n2);
  }
  
  int nextIntBetween(int min, int max) => min + nextInt(max - min);
  
  bool nextBool() => new Random().nextBool();
  
  double nextDouble() => new Random().nextDouble();
  
  Set<int> nextIntSet(int count, int max) {
    var result = new Set<int>();
    while(result.length < count) {
      result.add(nextInt(max));
    }
    return result;
  }
  
  Set<int> nextIntBetweenSet(int count, int min, int max) {
    var result = new Set<int>();
    while(result.length < count) {
      result.add(nextIntBetween(min, max));
    }
    return result;
  }
}