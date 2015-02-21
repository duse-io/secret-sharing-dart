library secret_sharing.test.polynomial;

import 'random_test_util.dart';
import 'package:mock/mock.dart';
import 'package:secret_sharing/secret_sharing.dart';
import 'package:unittest/unittest.dart';

definePolynomialTests() {
  group("Polynomial", () {
    test("random", () {
      var mock = new RandomMock([4, 3, 2, 1, 5]);
      var polynomial = new Polynomial.random(5, 10, random: mock);
      
      expect(polynomial.coefficients, equals([5, 1, 2, 3, 4]));
      mock.getLogs(callsTo("nextInt", anything))
          .verify(happenedExactly(5));
    });
    
    test("calculate", () {
      var polynomial = new Polynomial([1, 2, 3]); //1 + 2x + 3x^2

      expect(polynomial.calculate(0), equals(1));
      expect(polynomial.calculate(1), equals(6));
      expect(polynomial.calculate(2), equals(17));
    });
    
    test("call", () {
      var polynomial = new Polynomial([1, 2, 3]); //1 + 2x + 3x^2

      expect(polynomial(0), equals(1));
      expect(polynomial(1), equals(6));
      expect(polynomial(2), equals(17));
    });
    
    test("isPart", () {
      var polynomial = new Polynomial([1, 2, 3]); //1 + 2x + 3x^2
      
      expect(polynomial.isPart(new Point(0, 1)), isTrue);
      expect(polynomial.isPart(new Point(0, 3)), isFalse);
      expect(polynomial.isPart(new Point(2, 17)), isTrue);
    });
    
    test("degree", () {
      var polynomial = new Polynomial([1, 2, 3]);
      
      expect(polynomial.degree, equals(2));
    });

    test("getRandomCoefficients", () {
      var mock = new RandomMock([9, 9, 9, 9]);
      var coefficients = Polynomial.getRandomCoefficients(4, 10,
          random: mock);

      expect(coefficients.length, equals(4));
      expect(coefficients, everyElement(equals(9)));
      mock.getLogs(callsTo("nextInt")).verify(happenedExactly(4));
    });
  });
  
  group("SecretPolynomial", () {
    test("Constructor", () {
      var mock = new RandomMock([1, 2, 3, 4]);
      var polynomial = new SecretPolynomial(10, 5, mock);
      
      expect(polynomial.prime, equals(31));
      expect(polynomial.coefficients, equals([4, 3, 2, 1, 10]));
      expect(polynomial.degree, equals(4));
    });
    
    test("calculate", () {
      var mock = new RandomMock([1, 2]);
      var polynomial = new SecretPolynomial(10, 2, mock);
      
      expect(polynomial.calculate(0), equals(10));
      expect(polynomial.calculate(1), equals(11));
    });
    
    test("call", () {
      var mock = new RandomMock([1, 2]);
      var polynomial = new SecretPolynomial(10, 2, mock);
      
      expect(polynomial(0), equals(10));
      expect(polynomial(1), equals(11));
    });
    
    test("isPart", () {
      var mock = new RandomMock([1, 2]);
      var polynomial = new SecretPolynomial(10, 2, mock);
      
      expect(polynomial.isPart(new Point(0, 10)), isTrue);
      expect(polynomial.isPart(new Point(1, 11)), isTrue);
    });
  });
}