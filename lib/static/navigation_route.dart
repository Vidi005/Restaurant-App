enum NavigationRoute {
  mainRoute('/'),
  detailRoute('/detail'),
  favoriteRoute('/favorite'),
  settingsRoute('/settings');

  final String name;
  const NavigationRoute(this.name);
}
