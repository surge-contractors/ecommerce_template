enum BottomNavigationConfiguration {
  background._("Background"),
  borderTop._("BorderTop"),
  enlarge._("Enlarge"),
  underline._("Underline"),
  dot._("Dot"),
  floating._("Floating"),
  spotlight._("Spotlight"),
  worm._("Worm");

  const BottomNavigationConfiguration._(this.label);

  final String label;
}
