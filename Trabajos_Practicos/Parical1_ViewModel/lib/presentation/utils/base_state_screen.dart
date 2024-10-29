// Base screen state to be used in all screens to handle loading, idle and error states
enum BaseScreenState { loading, idle, error, empty }

// Extension on BaseViewState to make it easier to work with

extension BaseViewStateX on BaseScreenState {
  bool get isLoading => this == BaseScreenState.loading;

  bool get isIdle => this == BaseScreenState.idle;

  bool get isError => this == BaseScreenState.error;

  bool get isEmpty => this == BaseScreenState.empty;

  R when<R>({
    required R Function() loading,
    required R Function() idle,
    required R Function() error,
    required R Function() empty,
  }) {
    final state = this;
    switch (state) {
      case BaseScreenState.loading:
        return loading();
      case BaseScreenState.idle:
        return idle();
      case BaseScreenState.error:
        return error();
      case BaseScreenState.empty:
        return empty();
      default:
        throw AssertionError();
    }
  }
}
