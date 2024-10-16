import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_1_pineiro/data/local_breeds_repository.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'dart:developer' as dev;

class SlideInfo {
  final String title;
  final String caption;
  final String? imageUrl;

  SlideInfo({
    required this.title,
    required this.caption,
    required this.imageUrl,
  });
}

class BreedsDetailScreen extends StatefulWidget {
  const BreedsDetailScreen(
      {super.key, required this.breed, required this.repository});
  final Breed breed;
  final LocalBreedRepository repository;

  @override
  State<BreedsDetailScreen> createState() => _BreedsDetailScreenState();
}

class _BreedsDetailScreenState extends State<BreedsDetailScreen> {
  late String breed;
  late String weight;
  late String height;
  late String description;
  late String lifeExpectancy;
  late String? posterUrl_1;
  late String? posterUrl_2;
  late String? posterUrl_3;

  @override
  void initState() {
    super.initState();
    breed = widget.breed.breed;
    weight = widget.breed.weight;
    height = widget.breed.height;
    description = widget.breed.description;
    lifeExpectancy = widget.breed.lifeExpectancy;
    posterUrl_1 = widget.breed.posterUrl_1;
    posterUrl_2 = widget.breed.posterUrl_2;
    posterUrl_3 = widget.breed.posterUrl_3;
  }

  Future<bool?> openDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Estas Seguro?"),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              widget.repository.deleteBreed(widget.breed);
              Navigator.pop(context, true);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breed Detail'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            position: PopupMenuPosition.under,
            onSelected: (value) async {
              if (value == 1) {
                bool? isDeleted = await openDialog(context);
                if (isDeleted == true) {
                  Navigator.pop(context, true);
                }
                dev.log("Deleted?: $isDeleted");
              } else {
                final result = await context.pushNamed('BreedsForm', extra: {
                  'breed': widget.breed,
                  'repository': widget.repository
                });

                result == true
                    ? setState(() {
                        breed = widget.breed.breed;
                        weight = widget.breed.weight;
                        height = widget.breed.height;
                        description = widget.breed.description;
                        lifeExpectancy = widget.breed.lifeExpectancy;
                        posterUrl_1 = widget.breed.posterUrl_1;
                        posterUrl_2 = widget.breed.posterUrl_2;
                        posterUrl_3 = widget.breed.posterUrl_3;
                      })
                    : {null};
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0, // A value to identify the button
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 10),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BreedDetailView(
        breed: breed,
        weight: weight,
        height: height,
        description: description,
        lifeExpectancy: lifeExpectancy,
        posterUrl_1: posterUrl_1,
        posterUrl_2: posterUrl_2,
        posterUrl_3: posterUrl_3,
      ),
    );
  }
}

class BreedDetailView extends StatelessWidget {
  const BreedDetailView({
    super.key,
    required this.breed,
    required this.weight,
    required this.height,
    required this.description,
    required this.lifeExpectancy,
    required this.posterUrl_1,
    required this.posterUrl_2,
    required this.posterUrl_3,
  });
  final String breed;
  final String weight;
  final String height;
  final String description;
  final String lifeExpectancy;
  final String? posterUrl_1;
  final String? posterUrl_2;
  final String? posterUrl_3;
  @override
  Widget build(BuildContext context) {
    final _pageController =
        PageController(initialPage: 0, viewportFraction: 1, keepPage: false);

    final slides = [
      SlideInfo(
        title: 'Description',
        caption: description,
        imageUrl: posterUrl_1,
      ),
      SlideInfo(
        title: 'Stats',
        caption: "They can weigh between $weight and grow up to $height.",
        imageUrl: posterUrl_2,
      ),
      SlideInfo(
        title: 'Life Expectancy',
        caption: 'Their life expectancy can range between $lifeExpectancy.',
        imageUrl: posterUrl_3,
      ),
    ];

    return Stack(
      children: [
        PageView(
          controller: _pageController,
          children: slides
              .map((slide) => SlideView(
                  title: slide.title,
                  caption: slide.caption,
                  imageUrl: slide.imageUrl))
              .toList(),
        ),
      ],
    );
  }
}

class SlideView extends StatelessWidget {
  final String title;
  final String caption;
  final String? imageUrl;

  const SlideView({
    super.key,
    required this.title,
    required this.caption,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        );
    final captionStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title Section
            SizedBox(
              width: 400,
              child: Text(
                title,
                style: titleStyle,
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 24),

            // Image Section
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: 400,
                height: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      )
                    : Icon(
                        Icons.image_not_supported_outlined,
                        size: 100,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
              ),
            ),

            const SizedBox(height: 24),

            // Caption Section
            SizedBox(
              width: 400,
              child: Text(
                caption,
                style: captionStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
