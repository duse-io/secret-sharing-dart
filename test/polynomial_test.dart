import 'random_test_util.dart';
import 'package:mock/mock.dart';
import 'package:secret_sharing/secret_sharing.dart';
import 'package:unittest/unittest.dart';


main() {
  group("Standard polynomial", () {
    test("Calculation", () {
      var polynomial = new Polynomial([1, 2, 3]); //1 + 2x + 3x^2

      expect(polynomial.calculate(0), equals(1));
      expect(polynomial.calculate(1), equals(6));
      expect(polynomial.calculate(2), equals(17));
    });
    
    test("Is Part", () {
      var polynomial = new Polynomial([1, 2, 3]); //1 + 2x + 3x^2
      
      expect(polynomial.isPart(new Point(0, 1)), isTrue);
      expect(polynomial.isPart(new Point(0, 3)), isFalse);
      expect(polynomial.isPart(new Point(2, 17)), isTrue);
    });
    
    test("Degree", () {
      var polynomial = new Polynomial([1, 2, 3]);
      
      expect(polynomial.degree, equals(2));
    });

    test("Random coefficients generation", () {
      var mock = new RandomMock([9, 9, 9, 9]);
      var coefficients = Polynomial.getRandomCoefficients(4, 10,
          random: mock);

      expect(coefficients.length, equals(4));
      expect(coefficients, everyElement(equals(9)));
      mock.getLogs(callsTo("nextInt")).verify(happenedExactly(4));
    });
  });
}