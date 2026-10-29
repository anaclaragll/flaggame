import '../models/country.dart';
import 'country_data.dart';

class CountryRepository {
  const CountryRepository();

  List<Country> findByContinent(String? continent) {
    return countries
        .where(
          (country) => continent == null || country.continent == continent,
        )
        .toList();
  }
}
