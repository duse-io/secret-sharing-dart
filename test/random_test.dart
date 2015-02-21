library secret_sharing.test.random;

import 'random_test_util.dart';
import 'package:secret_sharing/secret_sharing.dart';

import 'package:mock/mock.dart';
import 'package:unittest/unittest.dart';

defineRandomTests() {
  group("BRandom", () {
    group("nextInt", () {
      test("Produce regular int", () {
        var mock = new RandomMock([1, 0, 0]);
        var bRandom = new BRandom(mock);
        
        expect(bRandom.nextInt(101), equals(100));
        mock.getLogs(callsTo("nextInt", anything))
            .verify(happenedExactly(3));
      });
      
      test("Produce int with exactly one digit less than max", () {
        var mock = new RandomMock([9]);
        var bRandom = new BRandom(mock);
        
        expect(bRandom.nextInt(10), equals(9));
        mock.getLogs(callsTo("nextInt", anything))
            .verify(happenedOnce);
      });
      
      test("First int too big, second correct", () {
        var mock = new RandomMock([1, 0, 2, 1, 0, 0]);
        var bRandom = new BRandom(mock);
        
        expect(bRandom.nextInt(101), equals(100));
        mock.getLogs(callsTo("nextInt", anything))
            .verify(happenedExactly(6));
      });
    });
    
    group("nextIntBetween", () {
      test("correct number", () {
        var mock = new RandomMock([1, 0 , 0]);
        var bRandom = new BRandom(mock);
        
        expect(bRandom.nextIntBetween(50, 200), equals(150));
        mock.getLogs(callsTo("nextInt", anything))
            .verify(happenedExactly(3));
      });
    });
    
    group("nextIntSet", () {
      test("only unique values", () {
        var mock = new RandomMock([9, 5, 6]);
        var bRandom = new BRandom(mock);
        
        expect(bRandom.nextIntSet(3, 10),
            equals(new Set.from([9, 5, 6])));
        mock.getLogs(callsTo("nextInt", anything))
            .verify(happenedExactly(3));
      });
      
      test("non unique values", () {
        var mock = new RandomMock([9, 9, 9, 5, 6]);
        var bRandom = new BRandom(mock);
        
        expect(bRandom.nextIntSet(3, 10),
            equals(new Set.from([9, 5, 6])));
        mock.getLogs(callsTo("nextInt", anything))
            .verify(happenedExactly(5));
      });
    });
    
    group("nextIntSetBetween", () {
      test("only unique values", () {
        var mock = new RandomMock([4, 0, 1]);
        var bRandom = new BRandom(mock);
        
        expect(bRandom.nextIntBetweenSet(3, 5, 10),
            equals(new Set.from([9, 5, 6])));
        mock.getLogs(callsTo("nextInt", anything))
            .verify(happenedExactly(3));
      });
      
      test("non unique values", () {
        var mock = new RandomMock([4, 4, 4, 0, 1]);
        var bRandom = new BRandom(mock);
        
        expect(bRandom.nextIntBetweenSet(3, 5, 10),
            equals(new Set.from([9, 5, 6])));
        mock.getLogs(callsTo("nextInt", anything))
            .verify(happenedExactly(5));
      });
    });
    
    group("nextBool", () {
      test("call next bool of given random instance", () {
        var mock = new RandomMock();
        mock.when(callsTo("nextBool"))
            .thenReturn(false)
            .thenReturn(true);
        var bRandom = new BRandom(mock);
        
        expect(bRandom.nextBool(), isFalse);
        expect(bRandom.nextBool(), isTrue);
        mock.getLogs(callsTo("nextBool"))
            .verify(happenedExactly(2));
      });
    });
    
    group("nextDouble", () {
      test("call next double of given random instance", () {
        var mock = new RandomMock();
        mock.when(callsTo("nextDouble"))
            .thenReturn(0.314);
        var bRandom = new BRandom(mock);
        
        expect(bRandom.nextDouble(), equals(0.314));
        mock.getLogs(callsTo("nextDouble"))
            .verify(happenedOnce);
      });
    });
  });
}