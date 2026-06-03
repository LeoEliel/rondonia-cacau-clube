import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/usecases/add_review.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_repositories.dart';
import '../../helpers/samples.dart';

void main() {
  late FakeReviewRepository repo;

  setUp(() => repo = FakeReviewRepository());

  AddReviewParams params({int rating = 5, String text = 'Excelente!'}) =>
      AddReviewParams(
        productId: 'prd_1',
        userId: 'user_ana',
        rating: rating,
        text: text,
        userName: 'Ana Souza',
      );

  test('rejects a rating outside 1–5 without touching the repository',
      () async {
    final result = await AddReview(repo)(params(rating: 6));

    result.fold(
      (f) => expect(f, isA<ValidationFailure>()),
      (_) => fail('expected a validation failure'),
    );
    expect(repo.lastAdded, isNull);
  });

  test('rejects empty/whitespace text', () async {
    final result = await AddReview(repo)(params(text: '   '));

    result.fold(
      (f) => expect(f, isA<ValidationFailure>()),
      (_) => fail('expected a validation failure'),
    );
    expect(repo.lastAdded, isNull);
  });

  test('trims text and persists a valid review', () async {
    repo.addResult = success(Samples.review());

    final result = await AddReview(repo)(params(text: '  Excelente!  '));

    expect(repo.lastAdded?.text, 'Excelente!');
    expect(repo.lastAdded?.productId, 'prd_1');
    expect(repo.lastAdded?.rating, 5);
    expect(result.isRight(), isTrue);
  });

  test('propagates a repository failure for valid input', () async {
    repo.addResult = failure(const ServerFailure());

    final result = await AddReview(repo)(params());

    expect(repo.lastAdded, isNotNull); // validation passed
    expect(result.isLeft(), isTrue);
  });
}
