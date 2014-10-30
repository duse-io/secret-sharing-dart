import 'package:secret_sharing/secret_sharing.dart';
import 'package:unittest/unittest.dart';

main() {
  test("Get large enough prime", () {
    expect(getLargeEnoughPrime([0, 1, 2]), equals(3));
    expect(getLargeEnoughPrime([0, 1, 2, 3, 6]), equals(7));
    expect(getLargeEnoughPrime([0, 1, 23]), equals(31));
  });
}