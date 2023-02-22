enum EnvironmentFlavor {
  dev,
  prod,
}

abstract class EnvironmentProvider {
  EnvironmentFlavor getCurrentFlavor();

  setFlavor({required EnvironmentFlavor flavor});
}

class EnvironmentProviderImpl implements EnvironmentProvider {
  late EnvironmentFlavor _flavor;

  @override
  setFlavor({required EnvironmentFlavor flavor}) {
    _flavor = flavor;
  }

  @override
  EnvironmentFlavor getCurrentFlavor() {
    return _flavor;
  }
}
