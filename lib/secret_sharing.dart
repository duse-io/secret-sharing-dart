library secret_sharing;

import 'dart:math' show Random, Point, pow;
import 'dart:convert' show Codec, Converter, UTF8, ASCII;
import 'package:lagrange/lagrange.dart' show modularLagrange;
import 'package:logging/logging.dart';

export 'dart:math' show Point;

part 'src/polynomial.dart';
part 'src/random.dart';
part 'src/primes.dart';
part 'src/charset.dart';
part 'src/sharing.dart';

const _RANDOM_MAX = ((1 << 32) - 1);
final BRandom _random = new BRandom();
final Logger log = new Logger("secret_sharing");

Set<int> _distinctRandomNumbers(int count, int max) {
  var result = new Set<int>();
  while(result.length < count) {
    result.add(_random.nextInt(max));
  }
  return result;
}