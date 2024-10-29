import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/providers.dart';

class SlideInfo {
  final String title;
  final String caption;
  final String imageUrl;

  SlideInfo({
    required this.title,
    required this.caption,
    required this.imageUrl,
  });
}

class BreedsInfoScreen extends ConsumerStatefulWidget {
  const BreedsInfoScreen({super.key, required this.breedId});

  final String breedId;

  @override
  ConsumerState<BreedsInfoScreen> createState() => _BreedsInfoScreenState();
}

class _BreedsInfoScreenState extends ConsumerState<BreedsInfoScreen> {
  final _pageController =
      PageController(initialPage: 0, viewportFraction: 1, keepPage: false);
  List<SlideInfo> slides = [
    SlideInfo(
      title: 'Description',
      caption: "",
      imageUrl: "",
    ),
    SlideInfo(
      title: 'Stats',
      caption: "",
      imageUrl: "",
    ),
    SlideInfo(
      title: 'Life Expectancy',
      caption: "",
      imageUrl: "",
    ),
  ];
  @override
  void initState() {
    log("Breed Id : ${widget.breedId}");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(breedsInfoViewModelProvider.notifier)
          .fetchBreed(widget.breedId);

      slides = slides.map((slide) {
        if (slide.title == 'Description') {
          return SlideInfo(
            title: slide.title,
            caption: ref.read(breedsInfoViewModelProvider).breed!.description,
            imageUrl: ref.read(breedsInfoViewModelProvider).breed!.posterUrl_1!,
          );
        } else if (slide.title == 'Stats') {
          return SlideInfo(
            title: slide.title,
            caption:
                "They can weigh between ${ref.read(breedsInfoViewModelProvider).breed!.weight} and grow up to ${ref.read(breedsInfoViewModelProvider).breed!.height}.",
            imageUrl: ref.read(breedsInfoViewModelProvider).breed!.posterUrl_2!,
          );
        } else if (slide.title == 'Life Expectancy') {
          return SlideInfo(
            title: slide.title,
            caption:
                "Their life expectancy can range between ${ref.read(breedsInfoViewModelProvider).breed!.lifeExpectancy}.",
            imageUrl: ref.read(breedsInfoViewModelProvider).breed!.posterUrl_3!,
          );
        } else {
          return slide;
        }
      }).toList();

      log("NO ERROR 2");
    });
  }

  Future<bool?> openDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure?"),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              delete();
              Navigator.pop(context, true);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void refreshInfo() async {
    await ref
        .read(breedsInfoViewModelProvider.notifier)
        .fetchBreed(widget.breedId);
    slides = slides.map((slide) {
      if (slide.title == 'Description') {
        return SlideInfo(
          title: slide.title,
          caption: ref.read(breedsInfoViewModelProvider).breed!.description,
          imageUrl: ref.read(breedsInfoViewModelProvider).breed!.posterUrl_1!,
        );
      } else if (slide.title == 'Stats') {
        return SlideInfo(
          title: slide.title,
          caption:
              "They can weigh between ${ref.read(breedsInfoViewModelProvider).breed!.weight} and grow up to ${ref.read(breedsInfoViewModelProvider).breed!.height}.",
          imageUrl: ref.read(breedsInfoViewModelProvider).breed!.posterUrl_2!,
        );
      } else if (slide.title == 'Life Expectancy') {
        return SlideInfo(
          title: slide.title,
          caption:
              "Their life expectancy can range between ${ref.read(breedsInfoViewModelProvider).breed!.lifeExpectancy}.",
          imageUrl: ref.read(breedsInfoViewModelProvider).breed!.posterUrl_3!,
        );
      } else {
        return slide;
      }
    }).toList();
  }

  void delete() {
    ref.read(breedsInfoViewModelProvider.notifier).deleteBreed(widget.breedId);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(breedsInfoViewModelProvider, (_, state) {});

    final state = ref.watch(breedsInfoViewModelProvider);

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
                  log("Deleted?: $isDeleted");
                } else {
                  final result = await context.pushNamed('BreedDetail',
                      extra: widget.breedId);

                  result == true ? refreshInfo() : {null};
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
        body: state.screenState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          idle: () {
            return info(context, slides);
          },
          empty: () {
            return;
          },
          error: () => Center(
            child: Text('Error: ${state.error}'),
          ),
        ));
  }

  Widget info(BuildContext context, List<SlideInfo> slides) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
          children: slides
              .map((slide) => slideView(
                  context, slide.title, slide.caption, slide.imageUrl))
              .toList(),
        ),
      ],
    );
  }

  Widget slideView(
      BuildContext context, String title, String caption, String imageUrl) {
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
                child: imageUrl != ""
                    ? Image.network(
                        imageUrl,
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
