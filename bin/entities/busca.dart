import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:mysql1/mysql1.dart';
import '../utils/utils.dart';

class Personajes extends ModelClass {
  int? idjuegodetronos;
  String? nombre;
  String? genero;
  String? casa;
  int? nacimiento;
  int? fallecimiento;
  String? cultura;
  List<String> titulos = [];
  List<String> apodos = [];

  String? religion;
  String? nacionalidad;
  bool? vivo;
  @override
  String tableName = "Personajes";
  @override
  String primaryKey = "Personajes";
  Personajes fromDataBase(ResultRow row) => Personajes.fromDataBase(row);
  Personajes({
    this.idjuegodetronos,
    this.nombre,
    this.genero,
    this.casa,
    this.nacimiento,
    this.fallecimiento,
    this.cultura,
    required titulos,
    required apodos,
    this.religion,
    this.nacionalidad,
    this.vivo,
  });

  Personajes.fromApi(Map<String, dynamic> data) {
    idjuegodetronos = data['id'];
    nombre = data['name'];
    genero = data['gender'];
    casa = data['culture'];
    nacimiento = null;
    fallecimiento = null;
    cultura = data['culture'] ?? "";
    for (String titulo in data['titles']) {
      titulos.add(titulo);
    }
    for (String apodo in data['aliases']) {
      apodos.add(apodo);
    }

    religion = data['religion'] ?? "";
    nacionalidad = data['born'] ?? "";
    vivo = data['vivo'] ?? true;
  }

  Personajes.fromDataBase(ResultRow row) {
    idjuegodetronos = row['idjuegodetronos'] ?? -1;
    nombre = row['nombre'] ?? "";
    genero = row['genero'] ?? "";
    casa = row['casa'] ?? "";
    nacimiento = row['nacimiento'] ?? "";
    fallecimiento = row['fallecimiento'] ?? "";
    cultura = row['culture'] ?? "";
    titulos = row['titles'] ?? "";
    apodos = row['aliases'] ?? "";
    religion = row['religion'] ?? "";
    nacionalidad = row['born'] ?? "";
    vivo = row['vivo'] ?? true;
  }

  static Future<Personajes?> obtenerjuegodetronos(
      {required String identificador}) async {
    final query = Uri.encodeComponent(identificador);
    final url = Uri.parse(
        "https://anapioficeandfire.com/api/characters?name=$query&pageSize=1");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;

      if (data.isEmpty) {
        print('No se encontró el personaje: $identificador');
        return null;
      }
      for (var item in data) {
        if ((item['name'] as String).toLowerCase() ==
            identificador.toLowerCase()) {
          return Personajes.fromApi(item as Map<String, dynamic>);
        }
      }
      return Personajes.fromApi(data.first as Map<String, dynamic>);
    }

    print("Error al obtener el personaje.");

    return null;
  }
}
