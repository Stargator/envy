part of envy;

/// Interpolates between a two lists containing points.
///
/// By default, time fractions outside the normal range (0-1) may return values outside the
/// range of values provided to the interpolate method.  To limit the returned values to the
/// provided range, set [clamped] to true.
///
/// Singleton.
///
class NumberListInterpolator extends EnvyInterpolator<NumberList> {
  static final NumberListInterpolator instance = new NumberListInterpolator._internal();

  // Internal interpolator for individual points
  static final NumberInterpolator _numInterp = new NumberInterpolator();

  /// To restrict the minimum and maximum values for overflow fractions, set [clamped] to true
  bool clamped = false;

  factory NumberListInterpolator() => instance;

  NumberListInterpolator._internal();

  /// Interpolates each individual point based on the time [fraction].
  ///
  /// For lists that grow in length, additional points are added one at a time, equally
  /// spaced over the animation duration.
  ///
  /// if [clamped] is true and the [fraction] is outside the normal range (0-1, inclusive)
  /// then
  ///
  NumberList interpolate(NumberList a, NumberList b, num fraction) {
    int numEntries = a.length == b.length ? b.length : (a.length + ((b.length - a.length) * fraction).ceil());
    NumberList newEntries = new NumberList();
    for (int i = 0; i < numEntries; i++) {
      newEntries
          .add(_numInterp.interpolate(i < a.length ? a[i] : 0, i < b.length ? b[i] : 0, fraction));
    }

    return newEntries;
  }
}
