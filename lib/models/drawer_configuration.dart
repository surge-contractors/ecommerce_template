enum DrawerConfiguration {
  slide._("Slide"),
  backdrop._("Backdrop"),
  tilted._("Tilted");

  const DrawerConfiguration._(this.label);

  /// The label to display in the UI.
  final String label;
}
