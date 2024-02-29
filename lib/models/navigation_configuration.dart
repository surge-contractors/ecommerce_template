enum NavigationConfiguration {
  bottom._('Bottom'),
  appbar._('Appbar'),
  rail._('Rail'),
  drawer._('Drawer');

  final String label;

  const NavigationConfiguration._(this.label);
}
