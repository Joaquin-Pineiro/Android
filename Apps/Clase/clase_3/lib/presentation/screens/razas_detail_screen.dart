import 'package:clase_3/data/raza_repository.dart';
import 'package:clase_3/domain/raza.dart';
import 'package:flutter/material.dart';

class RazasDetailScreen extends StatelessWidget {
  const RazasDetailScreen({super.key, required this.razaId});
  final String razaId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raza Detail'),
      ),
      body: MovieDetailView(
          raza: razaList.firstWhere((raza) => raza.id == razaId)),
    );
  }
}

class MovieDetailView extends StatelessWidget {
  const MovieDetailView({
    super.key,
    required this.raza,
  });
  final Raza raza;
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (raza.posterUrl != null)
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  raza.posterUrl!,
                  height: 200,
                ))
          else
            const Icon(Icons.catching_pokemon),
          Text(
            raza.raza,
            style: textStyle.bodyLarge,
          ),
          Text(
            raza.peso,
            style: textStyle.bodyMedium,
          )
        ],
      ),
    );
  }
}
