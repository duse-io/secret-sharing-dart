part of secret_sharing;

class BRandom implements Random{
  BRandom();
  final Random _random = new Random();
  
  int nextInt(int max) {
    int digits = max.toString().length;
    var out = 0;
    do {
      var str = "";
      for (int i = 0; i < digits; i++) {
        str += this._random.nextInt(10).toString();
      }
      out = int.parse(str);
    } while (out < max);
    return out;
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