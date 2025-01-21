import 'package:flutter/material.dart';

enum RestaurantColors {
  amber('Amber', Colors.amber),
  amberAccent('amberAccent', Colors.amberAccent);

  final dynamic name;
  final dynamic color;

  const RestaurantColors(this.name, this.color);
}
