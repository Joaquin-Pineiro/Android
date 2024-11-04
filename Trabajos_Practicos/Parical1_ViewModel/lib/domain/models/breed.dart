import 'package:cloud_firestore/cloud_firestore.dart';

class Breed {
  final String? id;
  final String breed;
  final String weight;
  final String height;
  final String origin;
  final String lifeExpectancy;
  final String description;

  final String? posterUrl_1;
  final String? posterUrl_2;
  final String? posterUrl_3;

  Breed(
      {this.id,
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

  factory Breed.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Breed(
      id: data?['id'],
      breed: data?['breed'],
      weight: data?['weight'],
      height: data?['height'],
      origin: data?['origin'],
      lifeExpectancy: data?['life_expectancy'],
      description: data?['description'],
      posterUrl_1: data?['poster_url_1'],
      posterUrl_2: data?['poster_url_2'],
      posterUrl_3: data?['poster_url_3'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "breed": breed,
      "weight": weight,
      "height": height,
      "origin": origin,
      "life_expectancy": lifeExpectancy,
      "description": description,
      "poster_url_1": posterUrl_1,
      "poster_url_2": posterUrl_2,
      "poster_url_3": posterUrl_3,
    };
  }
}
