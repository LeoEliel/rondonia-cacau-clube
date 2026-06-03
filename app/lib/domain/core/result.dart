import 'package:dartz/dartz.dart';

import 'failure.dart';

// Re-export dartz's [Unit] / [unit] so callers can model "success with no value"
// (e.g. `Result<Unit>` for void-like operations) without importing dartz.
export 'package:dartz/dartz.dart' show Unit, unit;

/// Functional result type used across the domain/data boundary.
///
/// `Left` carries a [Failure]; `Right` carries the success value `T`. Use cases
/// return [Result] so callers must explicitly handle both outcomes (no hidden
/// exceptions), keeping error handling honest and testable.
typedef Result<T> = Either<Failure, T>;

/// Convenience constructors so call sites read clearly:
/// `return success(product);` / `return failure(ServerFailure());`.
Result<T> success<T>(T value) => Right(value);
Result<T> failure<T>(Failure error) => Left(error);
