import 'dart:developer';

import 'package:clase_3/data/raza_repository.dart';
import 'package:clase_3/domain/raza.dart';
import 'package:clase_3/domain/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RazasScreen extends StatelessWidget {
  const RazasScreen({super.key, required this.user});

  final String user;
  @override
  Widget build(BuildContext context) {
    return _RazasView(
      razas: razaList,
    );
  }
}

class _RazasView extends StatelessWidget {
  const _RazasView({
    super.key,
    required this.razas,
  });
  final List<Raza> razas;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: razas.length,
      itemBuilder: (context, index) {
        return RazaItem(
          raza: razas[index],
        );
      },
    );
  }
}

class RazaItem extends StatelessWidget {
  const RazaItem({
    super.key,
    required this.raza,
  });
  final Raza raza;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/raza_detail/${raza.id}');
      },
      child: Card(
        color: Colors.white,
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          leading: raza.posterUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(raza.posterUrl!),
                )
              : const Icon(Icons.catching_pokemon),
          title: Text(raza.raza),
          subtitle: Text(raza.peso),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
