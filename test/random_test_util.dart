import 'package:unittest/unittest.dart';

var globalRandomCount = 1;


rTest(String name, f(), {randomCount}) {
  randomCount = randomCount == null ? globalRandomCount : randomCount;
  test(name, () {
    for (int i = 0; i < randomCount; i++) {
      f();
    }
  });
}