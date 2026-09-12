/// Minimal success/failure wrapper for engine + toolchain errors (PRD §51).
sealed class Result<T> {
  const Result();
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Fail<T> extends Result<T> {
  final String message;
  final Object? cause;
  const Fail(this.message, [this.cause]);
}
