import 'result.dart';

/// Contract every use case implements: a single public `call` that takes
/// [Params] and returns a [Result].
///
/// One use case = one application action (Single Responsibility). New behavior
/// is added by writing new use cases, not editing existing ones (Open/Closed).
/// Controllers depend on these abstractions, never on concrete repositories.
abstract interface class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Marker for use cases that take no parameters.
class NoParams {
  const NoParams();
}
