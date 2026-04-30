import 'dart:async';

import 'package:mysql1/mysql1.dart';
import '../utils/utils.dart';

class Usuario {
  String? nombre;
  String? nick;
  String? password;
  Usuario.fromDataBase(ResultRow row) {
    nombre = row['nombre'] ?? "";
    nick = row['nick'] ?? "";
    password = row['password'] ?? "";
  }
  Usuario fromDataBase(ResultRow row) => Usuario.fromDataBase(row);
  static Future<bool> registro(Map<String, String> datos) async {
    MySqlConnection conn = await DataBase.obtenerConexion();
    var respuesta = await conn.query('SELECT * FROM users WHERE nick = ?', [
      datos['nick'],
    ]);
    bool existe = respuesta.isNotEmpty;
    if (existe) {
      return false;
    }

    await conn.query(
      'INSERT INTO users (nombre,nick,password) VALUES (?,?,?)',
      [datos['nombre'], datos['nick'], datos['password']],
    );
    await conn.close();
    return true;
  }

  static Future<bool> login(String nick, String password) async {
    MySqlConnection conn = await DataBase.obtenerConexion();
    var respuesta = await conn.query(
      'SELECT password FROM users WHERE nick = ?',
      [nick],
    );
    bool noExiste = respuesta.isEmpty;
    if (noExiste || respuesta.first[0] != password) {
      await conn.close();
      return false;
    }

    await conn.close();
    return true;
  }
}
