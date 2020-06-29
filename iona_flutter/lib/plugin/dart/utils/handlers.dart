/// A token used to signal cancellation of an operation. This allows computation
/// to be skipped when a caller is no longer interested in the result, for example
/// when a $/cancel request is recieved for an in-progress request.
abstract class CancellationToken {
  bool get isCancellationRequested;
}

class CancelableToken extends CancellationToken {
  bool _isCancelled = false;

  @override
  bool get isCancellationRequested => _isCancelled;

  void cancel() => _isCancelled = true;
}
