import 'charset_test.dart';
import 'polynomial_test.dart';
import 'primes_test.dart';
import 'secret_sharing_test.dart';
import 'share_test.dart';
import 'random_test.dart';

main() {
  defineCharsetTests();
  defineCodecTests();
  defineShareTests();
  definePolynomialTests();
  definePrimeTests();
  defineRandomTests();
}