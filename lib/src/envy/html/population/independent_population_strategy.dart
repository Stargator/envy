part of envy;

/// A type of population strategy where (copies of) the generated children
/// are *all* added to each parent DOM node.
///
/// The total number of child DOM nodes will be product of the parent count
/// times the nominal child count.
///
/// Singleton:  does not have any state.
///
class IndependentPopulationStrategy extends PopulationStrategy {
  static IndependentPopulationStrategy _instance;

  factory IndependentPopulationStrategy() => instance;

  IndependentPopulationStrategy._internal();

  static IndependentPopulationStrategy get instance {
    if (_instance == null) _instance = new IndependentPopulationStrategy._internal();
    return _instance;
  }

  /// Generate the coupling list.
  ///
  List<DomNodeCoupling> determineCoupling(int parentCount, int childCount) {
    List<DomNodeCoupling> list = [];

    int c;
    for (int p = 0; p < parentCount; p++) {
      for (c = 0; c < childCount; c++) {
        list.add(new DomNodeCoupling(parentIndex: p, propIndex: c));
      }
    }

    return list;
  }
}
