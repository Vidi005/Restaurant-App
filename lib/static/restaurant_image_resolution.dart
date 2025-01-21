enum RestaurantImageResolution {
  small('https://restaurant-api.dicoding.dev/images/small/'),
  medium('https://restaurant-api.dicoding.dev/images/medium/'),
  large('https://restaurant-api.dicoding.dev/images/large/');

  final String url;
  const RestaurantImageResolution(this.url);
}
