import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parcial_1_pineiro/data/local_breeds_repository.dart';
import 'package:parcial_1_pineiro/data/local_users_repository.dart';
import 'package:parcial_1_pineiro/domain/models/breed.dart';
import 'package:parcial_1_pineiro/domain/models/user.dart';

class Destination {
  const Destination(this.label, this.icon, this.selectedIcon);

  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

const List<Destination> destinations = <Destination>[
  Destination(
      'User Profile', Icon(Icons.widgets_outlined), Icon(Icons.widgets)),
  Destination('Config', Icon(Icons.settings_outlined), Icon(Icons.settings)),
  Destination(
      'Log Out', Icon(Icons.logout_outlined), Icon(Icons.logout_outlined)),
];

class BreedsScreen extends StatefulWidget {
  const BreedsScreen({super.key, required this.user});

  final User user;

  @override
  State<BreedsScreen> createState() => _BreedsScreenState();
}

class _BreedsScreenState extends State<BreedsScreen> {
  final repository = LocalBreedRepository();
  final userRepository = LocalUserRepository();

  late Future<List<Breed>> futureBreeds;
  late List<Breed> filteredBreeds;
  late List<Breed> sortedBreeds;

  final TextEditingController _filtroBreeds = TextEditingController();
  List<String> _filters = [""];
  int selectedScreen = 0;

  @override
  void initState() {
    super.initState();
    futureBreeds = repository.getBreeds();

    _initializeData();
  }

  Future<void> _initializeData() async {
    futureBreeds = repository.getBreeds();

    // You can await async operations here
    filteredBreeds = await repository.getBreeds();
    sortedBreeds = await repository.getBreeds();

    // Optionally trigger a state update if needed
    setState(() {});
  }

  void _refreshBreeds() {
    setState(() {
      futureBreeds = repository.getBreeds();
      //log('Reseteando screen');
    });
  }

  void _filterBreeds(String filter) {
    setState(() {
      futureBreeds =
          repository.filterBreeds(filter, filteredBreeds, sortedBreeds);
      log('2--------');
      for (var breed in filteredBreeds) {
        log('Breed: ${breed.breed}');
      }
    });
  }

  void _filterBreeds2(bool lowHigh, String filter) {
    setState(() {
      futureBreeds = repository.filterBreeds2(
          lowHigh, filter, filteredBreeds, sortedBreeds);

      log('1--------');
      for (var breed in filteredBreeds) {
        log('Breed: ${breed.breed}');
      }
    });
  }

  void _clearBreeds() {
    setState(() {
      futureBreeds = repository.filterBreeds("", filteredBreeds, sortedBreeds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Breeds"),
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
            onDestinationSelected: (value) {
              setState(() {
                selectedScreen = value;
                if (selectedScreen == 0) {
                  selectedScreen = -1;
                  Scaffold.of(context).closeDrawer();
                  context.pushNamed('UserProfile', extra: {
                    'repository': userRepository,
                    'user': widget.user
                  });
                }
                if (selectedScreen == 1) {
                  Scaffold.of(context).closeDrawer();
                  selectedScreen = -1;
                  context.pushNamed('Config');
                }
                if (selectedScreen == 2) {
                  selectedScreen = -1;
                  Scaffold.of(context).closeDrawer();
                  context.goNamed('User');
                }
              });
            },
            selectedIndex: selectedScreen,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                child: Text(
                  'Menu',
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
        body: GestureDetector(
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
                      hintText: 'Search',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _filtroBreeds.clear();
                            _clearBreeds();
                          },
                          icon: const Icon(Icons.clear)),
                    ),
                    controller: _filtroBreeds,
                    onChanged: (text) {
                      _filterBreeds(text);
                    },
                  ),
                ),
                FilterControl(filter: _filterBreeds2),
                Expanded(
                  child: FutureBuilder(
                    future: futureBreeds,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.hasData == true) {
                          final breeds = snapshot.data!;
                          return _BreedsView(
                            breeds: breeds,
                            onRefresh: _refreshBreeds,
                            repository: repository,
                          );
                        } else {
                          return const Text("Error");
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await context.pushNamed('BreedsForm',
                extra: {'repository': repository, 'breed': null});
            result == true ? _refreshBreeds() : null;
          },
          child: const Icon(Icons.pets),
        ));
  }
}

class FilterControl extends StatefulWidget {
  const FilterControl({
    super.key,
    required this.filter,
  });
  final Function filter;

  @override
  State<FilterControl> createState() => _FilterControlState();
}

class _FilterControlState extends State<FilterControl> {
  String? _filter = null;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: const Text("Weight"),
              selected: _filter == "Filt Weight",
              onSelected: (bool selected) {
                setState(() {
                  _filter =
                      _filter == "Filt Weight" ? null : _filter = "Filt Weight";
                  widget.filter(selected ? true : false, "weight");
                });
              },
              avatar: const Icon(Icons.arrow_circle_down),
              showCheckmark: false,
            )),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: const Text("Height"),
              selected: _filter == "Filt Height",
              onSelected: (bool selected) {
                setState(() {
                  _filter =
                      _filter == "Filt Height" ? null : _filter = "Filt Height";
                  widget.filter(selected ? true : false, "height");
                });
              },
              avatar: const Icon(Icons.arrow_circle_down),
              showCheckmark: false,
            ))
      ],
    );
  }
}

class _BreedsView extends StatelessWidget {
  const _BreedsView({
    required this.breeds,
    required this.onRefresh,
    required this.repository,
  });
  final List<Breed> breeds;
  final Function onRefresh;
  final LocalBreedRepository repository;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: breeds.length,
        itemBuilder: (context, index) {
          return BreedItem(
            breed: breeds[index],
            repository: repository,
            onTap: onRefresh,
          );
        },
      ),
    );
  }
}

class BreedItem extends StatelessWidget {
  const BreedItem({
    super.key,
    required this.breed,
    required this.repository,
    required this.onTap,
  });
  final Breed breed;
  final LocalBreedRepository repository;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await context.pushNamed('BreedDetail',
            extra: {'breed': breed, 'repository': repository});
        result == true ? onTap() : null;
      },
      child: Card(
        child: ListTile(
          visualDensity: VisualDensity(vertical: 4),
          contentPadding: EdgeInsets.all(10),
          titleAlignment: ListTileTitleAlignment.center,
          leading: breed.posterUrl_1 != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      breed.posterUrl_1!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                )
              : const Icon(Icons.catching_pokemon),
          title: Text(breed.breed),
          subtitle: Text(
              "Weight: ${breed.weight}\nHeight: ${breed.height}\nOrigin: ${breed.origin}"),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
