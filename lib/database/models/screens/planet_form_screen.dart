import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../database/db_helper.dart';

class PlanetFormScreen extends StatefulWidget {
  final Planet? planet;

  PlanetFormScreen({this.planet});

  @override
  _PlanetFormScreenState createState() => _PlanetFormScreenState();
}

class _PlanetFormScreenState extends State<PlanetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  double _distance = 0;
  double _size = 0;
  String? _nickname;

  @override
  void initState() {
    super.initState();
    if (widget.planet != null) {
      _name = widget.planet!.name;
      _distance = widget.planet!.distance;
      _size = widget.planet!.size;
      _nickname = widget.planet!.nickname;
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newPlanet = Planet(
        id: widget.planet?.id,
        name: _name,
        distance: _distance,
        size: _size,
        nickname: _nickname,
      );

      if (widget.planet == null) {
        await DBHelper.insertPlanet(newPlanet);
      } else {
        await DBHelper.updatePlanet(newPlanet);
      }

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.planet == null ? 'Novo Planeta' : 'Editar Planeta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _distance.toString(),
                decoration: InputDecoration(labelText: 'Distância do Sol (UA)'),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value!) == null ? 'Digite um número válido' : null,
                onSaved: (value) => _distance = double.parse(value!),
              ),
              TextFormField(
                initialValue: _size.toString(),
                decoration: InputDecoration(labelText: 'Tamanho (km)'),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value!) == null ? 'Digite um número válido' : null,
                onSaved: (value) => _size = double.parse(value!),
              ),
              TextFormField(
                initialValue: _nickname,
                decoration: InputDecoration(labelText: 'Apelido (opcional)'),
                onSaved: (value) => _nickname = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}