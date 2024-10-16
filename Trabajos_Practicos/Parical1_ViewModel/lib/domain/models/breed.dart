import 'package:floor/floor.dart';

@entity
class Breed {
  @primaryKey
  final int? id;
  String breed;
  String weight;
  String height;
  String origin;
  String lifeExpectancy;
  String description;

  final String? posterUrl_1;
  final String? posterUrl_2;
  final String? posterUrl_3;

  Breed(
      {required this.id,
      required this.breed,
      required this.weight,
      required this.height,
      required this.origin,
      required this.posterUrl_1,
      required this.posterUrl_2,
      required this.posterUrl_3,
      required this.lifeExpectancy,
      required this.description});

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'weight': weight,
    };
  }

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
        id: json['id'],
        breed: json['breed'],
        weight: json['weight'],
        height: json['height'],
        origin: json['origin'],
        posterUrl_1: json['poster_url_1'] != null ? json['poster_url_1'] : null,
        posterUrl_2: json['poster_url_2'] != null ? json['poster_url_2'] : null,
        posterUrl_3: json['poster_url_3'] != null ? json['poster_url_3'] : null,
        lifeExpectancy: json['life_expectancy'],
        description: json['description']);
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'height': height,
  //     'weight': weight,
  //   };
  // }
}
