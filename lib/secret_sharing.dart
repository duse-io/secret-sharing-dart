library secret_sharing;

import 'dart:math' show Random, Point, pow;
import 'dart:convert' show Codec, Converter, UTF8, ASCII;
import 'package:logging/logging.dart';
import 'package:bbs/bbs.dart';

export 'dart:math' show Point;

part 'src/polynomial.dart';
part 'src/random.dart';
part 'src/primes.dart';
part 'src/charset.dart';
part 'src/sharing.dart';
part 'src/lagrange.dart';

/// The maximum number which can be reached by [Random] generators
const _RANDOM_MAX = ((1 << 32) - 1);

/// The [BRandom] generator used for big random numbers
final BRandom _random = new BRandom();

/// The logger of this library
final Logger log = new Logger("secret_sharing");