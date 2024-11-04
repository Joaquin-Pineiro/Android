import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/domain/repositories/breeds_repository.dart';
import 'package:parcial_1_pineiro/main.dart';

class LocalBreedFirestoreRepository implements BreedsRepository {
  @override
  Future<List<Breed>> getBreeds() async {
    final breedsCollection =
        dataBaseFirestore.collection('breeds').withConverter<Breed>(
              fromFirestore: Breed.fromFirestore,
              toFirestore: (Breed breed, _) => breed.toFirestore(),
            );
    try {
      final documentsSnap = await breedsCollection.get();
      log("Number of Breeds fetched: ${documentsSnap.size}");
      final breeds = documentsSnap.docs.map((doc) => doc.data()).toList();

      for (var breed in breeds) {
        log('Retrieved breed: id:${breed.id}', name: 'BreedDataRetrieval');
        log('Retrieved breed: breed:${breed.breed}',
            name: 'BreedDataRetrieval');
        log('Retrieved breed: weight:${breed.weight}',
            name: 'BreedDataRetrieval');
        log('Retrieved breed: height:${breed.height}',
            name: 'BreedDataRetrieval');
        log('Retrieved breed: origin:${breed.origin}',
            name: 'BreedDataRetrieval');
        log('Retrieved breed: lifeExpectancy:${breed.lifeExpectancy}',
            name: 'UserDataRetrieval');
        log('Retrieved breed: description:${breed.description}',
            name: 'BreedDataRetrieval');
        log('Retrieved breed: posterUrl_1:${breed.posterUrl_1}',
            name: 'BreedDataRetrieval');
        log('Retrieved breed: posterUrl_2:${breed.posterUrl_2}',
            name: 'BreedDataRetrieval');
        log('Retrieved breed: posterUrl_3:${breed.posterUrl_3}',
            name: 'BreedDataRetrieval');
      }
      return breeds;
    } catch (e, stackTrace) {
      log("Error fetching breeds: $e", name: 'BreedDataRetrieval');
      log("StackTrace: $stackTrace", name: 'BreedDataRetrieval');
      return [];
    }
  }

  @override
  Future<Breed?> getBreed(String documentId) async {
    final breedsCollection =
        dataBaseFirestore.collection('breeds').withConverter<Breed>(
              fromFirestore: Breed.fromFirestore,
              toFirestore: (Breed breed, _) => breed.toFirestore(),
            );
    final documentSnap = await breedsCollection.doc(documentId).get();

    return documentSnap.data();
  }

  @override
  Future<void> insertBreed(Breed breed) async {
    final breedsCollection =
        dataBaseFirestore.collection('breeds').withConverter<Breed>(
              fromFirestore: Breed.fromFirestore,
              toFirestore: (Breed breed, _) => breed.toFirestore(),
            );

    try {
      final docRef = await breedsCollection.add(breed);
      await docRef.update({'id': docRef.id});
      log("Breed inserted successfully with document ID: ${docRef.id}");
    } catch (e) {
      log("Failed to insert breed: $e");
    }
  }

  @override
  Future<void> updateBreed(Breed breed) async {
    final breedsCollection =
        dataBaseFirestore.collection("breeds").withConverter<Breed>(
              fromFirestore: Breed.fromFirestore,
              toFirestore: (Breed breed, _) => breed.toFirestore(),
            );

    try {
      await breedsCollection.doc(breed.id).set(breed, SetOptions(merge: true));
      log("Breed updated successfully!");
    } catch (e) {
      log("Failed to update breed: $e");
    }
  }

  @override
  Future<void> deleteBreed(Breed breed) async {
    final breedsCollection = dataBaseFirestore.collection("breeds");

    try {
      await breedsCollection.doc(breed.id).delete();
      log("Breed deleted successfully!");
    } catch (e) {
      log("Failed to delete breed: $e");
    }
  }

  @override
  Future<List<Breed>> filterBreeds(String filter) async {
    //filter = filter.toLowerCase();
    log('Filter: $filter');
    final breedsCollection =
        dataBaseFirestore.collection('breeds').withConverter<Breed>(
              fromFirestore: Breed.fromFirestore,
              toFirestore: (Breed breed, _) => breed.toFirestore(),
            );

    try {
      // final documentSnap = await breedsCollection
      //     .where('breed', isGreaterThanOrEqualTo: filter)
      //     .where('breed', isLessThan: '$filter\uf8ff')
      //     .get();
      final documentSnap = await breedsCollection.get();
      log('Total documents retrieved: ${documentSnap.docs.length}',
          name: 'BreedsRepository');
      final matchingBreeds = documentSnap.docs
          .map((doc) => doc.data())
          .where((breed) =>
              breed.breed.toLowerCase().contains(filter.toLowerCase()))
          .toList();
      // final matchingBreeds = documentSnap.docs
      //     .map((doc) => doc.data())
      //     .where((breed) =>
      //         breed.breed.contains(filter.))
      // .toList();

      log('Number of breeds fetched: ${matchingBreeds.length}',
          name: 'BreedsRepository');
      return matchingBreeds;
    } catch (e, stackTrace) {
      log('Error fetching breeds: $e', name: 'BreedsRepository');
      log('StackTrace: $stackTrace', name: 'BreedsRepository');
      return [];
    }
  }
}
