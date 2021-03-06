part of envy;

abstract class Multiplicity {

  /// The default multiplicity takes the largest raw size of all
  /// of its properties and uses that as the size.
  ///
  static final Multiplicity defaultMultiplicity = new LargestSize();

  int sizeOf(Iterable<EnvyProperty> props);
}
