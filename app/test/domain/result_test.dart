import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('success wraps a Right value', () {
      final Result<int> result = success(42);
      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => -1), 42);
    });

    test('failure wraps a Left failure', () {
      final Result<int> result = failure(const ServerFailure());
      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('expected a failure'),
      );
    });
  });
}
