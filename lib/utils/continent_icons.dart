import 'package:flutter/material.dart';

IconData continentIcon(String continent) {
  switch (continent) {
    case 'África':
      return Icons.wb_sunny_outlined;
    case 'América':
      return Icons.landscape_outlined;
    case 'Ásia':
      return Icons.temple_buddhist_outlined;
    case 'Europa':
      return Icons.castle_outlined;
    default:
      return Icons.sailing_outlined;
  }
}
