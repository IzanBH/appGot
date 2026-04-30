import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> RelacionPersonaje() async {
  stdout.writeln('Introduce el nombre del personaje 1:');
  String nombre1Input = stdin.readLineSync() ?? '';

  stdout.writeln('Introduce el nombre del personaje 2:');
  String nombre2Input = stdin.readLineSync() ?? '';

  Map<String, dynamic>? personaje1 =
      await buscarPersonajePorNombre(nombre1Input);
  Map<String, dynamic>? personaje2 =
      await buscarPersonajePorNombre(nombre2Input);

  if (personaje1 == null) {
    print('No se encontró el personaje: $nombre1Input');
    stdin.readLineSync();
    return "home";
  }
  if (personaje2 == null) {
    print('No se encontró el personaje: $nombre2Input');
    stdin.readLineSync();
    return "home";
  }

  String nombre1 = personaje1['name'] ?? 'Desconocido';
  String nombre2 = personaje2['name'] ?? 'Desconocido';
  String relacion = determinarRelacion(personaje1, personaje2);

  print('$nombre1 y $nombre2: $relacion');
  stdout.writeln('\nPulsa Enter para volver...');
  stdin.readLineSync();

  return "home";
}

Future<Map<String, dynamic>?> buscarPersonajePorNombre(String nombre) async {
  var url =
      Uri.https('anapioficeandfire.com', '/api/characters', {'name': nombre});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var lista = jsonDecode(response.body) as List;
    if (lista.isEmpty) return null;
    return lista[0] as Map<String, dynamic>;
  }
  return null;
}

String determinarRelacion(
    Map<String, dynamic> personaje1, Map<String, dynamic> personaje2) {
  List<String> alianzas1 = List<String>.from(personaje1['allegiances'] ?? []);
  List<String> alianzas2 = List<String>.from(personaje2['allegiances'] ?? []);

  List<String> libros1 = List<String>.from(personaje1['books'] ?? []);
  List<String> libros2 = List<String>.from(personaje2['books'] ?? []);

  List<String> series1 = List<String>.from(personaje1['tvSeries'] ?? []);
  List<String> series2 = List<String>.from(personaje2['tvSeries'] ?? []);

  bool mismaAlianza = false;
  for (var alianza in alianzas1) {
    if (alianzas2.contains(alianza)) {
      mismaAlianza = true;
      break;
    }
  }

  bool librosComunes = false;
  for (var libro in libros1) {
    if (libros2.contains(libro)) {
      librosComunes = true;
      break;
    }
  }

  bool seriesComunes = false;
  for (var serie in series1) {
    if (series2.contains(serie)) {
      seriesComunes = true;
      break;
    }
  }

  if (mismaAlianza) {
    return 'pertenecen a la misma casa y son aliados';
  } else if (alianzas1.isNotEmpty && alianzas2.isNotEmpty) {
    return 'pertenecen a casas distintas y podrían ser rivales';
  } else if (librosComunes && seriesComunes) {
    return 'comparten libros y aparecen juntos en la serie';
  } else if (librosComunes) {
    return 'coinciden en los mismos libros de la saga';
  } else if (seriesComunes) {
    return 'aparecen en las mismas temporadas de la serie';
  } else {
    return 'No tienen relación conocida';
  }
}
