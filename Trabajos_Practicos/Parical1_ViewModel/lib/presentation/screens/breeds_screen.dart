import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/presentation/utils/base_state_screen.dart';
import 'package:parcial_1_pineiro/viewmodels/providers.dart';

class Destination {
  const Destination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

class BreedsScreen extends ConsumerStatefulWidget {
  const BreedsScreen({required this.userId, super.key});
  final String userId;

  @override
  ConsumerState<BreedsScreen> createState() => _BreedsScreenState();
}

class _BreedsScreenState extends ConsumerState<BreedsScreen> {
  final TextEditingController _inputFilter = TextEditingController();
  int selectedScreen = 0;
  String? filter;
  late List<Destination> destinations;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(breedsViewModelProvider.notifier).fetchBreds();
      _inputFilter.addListener(
        () {
          ref
              .read(breedsViewModelProvider.notifier)
              .updateFilterText(_inputFilter.text);
        },
      );
    });
    final textsApp = ref.read(configViewModelProvider).textsApp;
    destinations = <Destination>[
      Destination(textsApp['User Profile']!, const Icon(Icons.widgets_outlined),
          const Icon(Icons.widgets)),
      Destination(textsApp['Settings']!, const Icon(Icons.settings_outlined),
          const Icon(Icons.settings)),
      Destination(textsApp['Log Out']!, const Icon(Icons.logout_outlined),
          const Icon(Icons.logout_outlined)),
    ];
  }

  void filterBreeds(String filter) {
    ref.read(breedsViewModelProvider.notifier).filterBreeds(filter);
  }

  void sortBreeds(bool lowHigh, String filter) {
    ref.read(breedsViewModelProvider.notifier).sortBreeds(lowHigh, filter);
  }

  void refresh() async {
    ref.read(breedsViewModelProvider.notifier).fetchBreds();
  }

  Future<bool> logOut() {
    return ref.read(breedsViewModelProvider.notifier).logOut();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(breedsViewModelProvider);
    final textsApp = ref.watch(configViewModelProvider).textsApp;

    return Scaffold(
        appBar: AppBar(
          title: Text(textsApp["Dog Breeds"]!),
          centerTitle: true,
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          }),
        ),
        drawer: Builder(builder: (context) {
          return NavigationDrawer(
            onDestinationSelected: (value) async {
              selectedScreen = value;
              if (selectedScreen == 0) {
                selectedScreen = -1;
                Scaffold.of(context).closeDrawer();
                context.pushNamed('UserProfile', extra: widget.userId);
              }
              if (selectedScreen == 1) {
                Scaffold.of(context).closeDrawer();
                selectedScreen = -1;
                context.goNamed('Config', extra: widget.userId);
              }
              if (selectedScreen == 2) {
                selectedScreen = -1;
                final result = await logOut();
                if (result) {
                  Scaffold.of(context).closeDrawer();

                  context.goNamed('User');
                }
              }
            },
            selectedIndex: selectedScreen,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                child: Text(
                  textsApp['Menu']!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...destinations.map(
                (Destination destination) {
                  return NavigationDrawerDestination(
                    label: Text(destination.label),
                    icon: destination.icon,
                    selectedIcon: destination.selectedIcon,
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
                child: Divider(),
              ),
            ],
          );
        }),
        body: state.screenState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          idle: () {
            return breeds(state.breeds, textsApp);
          },
          empty: () {
            return;
          },
          error: () => Center(
            child: Text('Error: ${state.error}'),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await context.pushNamed('BreedDetail', extra: null);
            result == true ? refresh() : null;
          },
          child: const Icon(Icons.pets),
        ));
  }

  Widget breeds(List<Breed> breeds, Map<String, String> textsApp) {
    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).unfocus();
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: textsApp['Search']!,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                      onPressed: () {
                        _inputFilter.clear();
                        filterBreeds("");
                      },
                      icon: const Icon(Icons.clear)),
                ),
                controller: _inputFilter,
                onChanged: (text) {
                  filterBreeds(text);
                },
              ),
            ),
            chipControl(textsApp),
            Expanded(
                child: RefreshIndicator(
              onRefresh: () async => refresh(),
              child: ListView.builder(
                itemCount: breeds.length,
                itemBuilder: (context, index) {
                  final breed = breeds[index];
                  return GestureDetector(
                    onTap: () async {
                      await context.pushNamed('BreedsInfo', extra: breed.id);
                      refresh();
                    },
                    child: Card(
                      child: ListTile(
                        visualDensity: const VisualDensity(vertical: 4),
                        contentPadding: const EdgeInsets.all(10),
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: breed.posterUrl_1 != ""
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Image.network(
                                    breed.posterUrl_1!,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                ),
                              )
                            : const Icon(Icons.pets),
                        title: Text(breed.breed),
                        subtitle: Text(
                            "${textsApp["Weight"]!}: ${breed.weight}\n${textsApp["Height"]!}: ${breed.height}\n${textsApp["Origin"]!}: ${breed.origin}"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget chipControl(Map<String, String> textsApp) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: Text(textsApp["Weight"]!),
              selected: filter == "Filt Weight",
              onSelected: (bool selected) {
                log("Filter: $filter");
                log("Selected: $selected");

                filter = (filter == "Filt Weight") ? null : "Filt Weight";
                sortBreeds((selected == false) ? false : true, "weight");
              },
              avatar: const Icon(Icons.arrow_circle_down),
              showCheckmark: false,
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: Text(textsApp["Height"]!),
              selected: filter == "Filt Height",
              onSelected: (bool selected) {
                filter = filter == "Filt Height" ? null : "Filt Height";
                sortBreeds((selected == false) ? false : true, "height");
              },
              avatar: const Icon(Icons.arrow_circle_down),
              showCheckmark: false,
            ))
      ],
    );
  }
}
