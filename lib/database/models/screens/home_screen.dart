import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../database/db_helper.dart';
import 'planet_detail_screen.dart';
import 'planet_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Planet> _planets = [];

  @override
  void initState() {
    super.initState();
    _loadPlanets();
  }

  Future<void> _loadPlanets() async {
    final planets = await DBHelper.fetchPlanets();
    setState(() {
      _planets = planets;
    });
  }

  void _navigateToForm({Planet? planet}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanetFormScreen(planet: planet)),
    );

    if (result == true) {
      _loadPlanets();
    }
  }

  void _deletePlanet(int id) async {
    await DBHelper.deletePlanet(id);
    _loadPlanets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gerenciador de Planetas')),
      body: _planets.isEmpty
          ? Center(child: Text("Nenhum planeta cadastrado."))
          : ListView.builder(
              itemCount: _planets.length,
              itemBuilder: (ctx, index) {
                final planet = _planets[index];
                return ListTile(
                  title: Text(planet.name),
                  subtitle: Text('Distância: ${planet.distance} UA'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _navigateToForm(planet: planet),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deletePlanet(planet.id!),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlanetDetailScreen(planet: planet)),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}