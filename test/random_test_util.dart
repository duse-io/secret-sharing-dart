library secret_sharing.test.random_mock;

import 'dart:math';
import 'package:unittest/unittest.dart';
import 'package:mock/mock.dart';

var globalRandomCount = 1;

@proxy
class RandomMock extends Mock implements Random {
  RandomMock([List<int> pseudoRandoms = const[]]) : super.custom(throwIfNoBehavior: true){
    for (var pseudoRandom in pseudoRandoms) {
      this.when(callsTo("nextInt", anything)).thenReturn(pseudoRandom);
    }
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}


rTest(String name, f(), {randomCount}) {
  randomCount = randomCount == null ? globalRandomCount : randomCount;
  test(name, () {
    for (int i = 0; i < randomCount; i++) {
      f();
    }
  });
}