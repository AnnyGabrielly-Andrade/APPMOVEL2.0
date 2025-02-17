import 'package:flutter/material.dart';
import '../models/planet.dart';

class PlanetDetailScreen extends StatelessWidget {
  final Planet planet;

  PlanetDetailScreen({required this.planet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(planet.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Distância do Sol: ${planet.distance} UA", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Tamanho: ${planet.size} km", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Apelido: ${planet.nickname ?? 'Nenhum'}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}